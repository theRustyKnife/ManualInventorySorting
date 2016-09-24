util = require "util"

local sorting = {}

function sorting.sort_orders(orders, sorting_prefs) -- WIP
	for i, v in pairs(sorting_prefs.keep_on_top) do
		util.remove_element(orders, v)
		table.insert(orders, 1, v)
	end
	
	return orders
end

-- possible arguments:
--		player_index (mandatory)
--		override_possible (optional), default: false - can the sortlimit be overriden in this process? (true for player manual sort and false for everything else)
--		force_override (optional), default: false - override the sorting limit regardless of other settings. (false for player and true for other entities)
--		inventory (optional), default: nil, but uses the inventory of the player with passed player_index. - determines what to sort, obviously...
--
-- the arguments have to be passed as a table, unless you only pass player_index
function sorting.sort_inventory(arg)
	-- get the arguments if they're passed as a table
	local player_index = 0
	local sort_limit_override = false
	local force_override = false
	local inventory = nil
	
	if (type(arg) == "table") then
		player_index = arg.player_index
		if arg.override_possible then sort_limit_override = arg.override_possible end
		if arg.force_override then force_override = arg.force_override end
		if arg.inventory then inventory = arg.inventory end
		
	else player_index = arg
	end
	
	migration.check_settings(player_index)
	
	sort_limit_override = sort_limit_override and global.player_settings[player_index].sort_limit_override or force_override
	
	local sorting_player = inventory == nil -- need to remember this for destroying t_chests of non-player entities
	local t_chest
	
	if sorting_player then -- sorting player inventory - use players t_chest
		local player = game.players[player_index]
		inventory = player.get_inventory(defines.inventory.player_main)
		
		if not global.player_t_chests[player_index] or not global.player_t_chests[player_index].valid then -- this player doesn't have her t_chest yet, so create one
			global.player_t_chests[player_index] = player.surface.create_entity{name = "manual-inventory-sort-tmp-chest", position = player.position}
			global.player_t_chests[player_index].destructible = false
			global.player_t_chests[player_index].operable = false
		end
		
		t_chest = global.player_t_chests[player_index]
		
	else -- sorting a specified inventory - need to build a new t_chest
		t_chest = game.players[player_index].surface.create_entity{name = "manual-inventory-sort-tmp-chest", position = game.players[player_index].position}
		t_chest.destructible = false
		t_chest.operable = false
	end
	
	local t_chest_inventory = t_chest.get_inventory(defines.inventory.chest)
	
	local stacks = {}
	local orders = {}
	local sort_limit = #inventory
	
	if (not sort_limit_override) and global.player_settings[player_index].sort_limit_enabled then
		-- sort limit is enabled - need to figure out what it actually is
		if global.player_settings[player_index].sort_limit >= 0 and global.player_settings[player_index].sort_limit < sort_limit then -- for positive limits (can't exceed inventory size)
			sort_limit = global.player_settings[player_index].sort_limit
			
		elseif global.player_settings[player_index].sort_limit < 0 and global.player_settings[player_index].sort_limit > 0 - sort_limit then -- for negative limits (result can't be <= 0)
			sort_limit = sort_limit + global.player_settings[player_index].sort_limit
		end
	end
	
	------------ SORTING ------------
	
	for i = 1, sort_limit do -- put the content into a table
		local stack = inventory[i]
		if stack ~= nil and stack.valid_for_read and stack.valid then
			local prototype = game.item_prototypes[stack.name]
			
			-- figure out the full order string of this stack - Why is there no API function for this???
			local order = ""
			if (prototype.group) then order = order .. prototype.group.order .. prototype.group.name end
			if (prototype.subgroup) then order = order .. prototype.subgroup.order .. prototype.subgroup.name end
			if (prototype.order) then order = order .. prototype.order end
			order = order .. prototype.name
			
			table.insert(stacks, {stack = stack, prototype = prototype, order = order})
			util.add_unique(orders, order)
		end
	end
	
	table.sort(orders) -- sort the strings alphabetically
	
	-- if global.player_settings[player_index].custom_sort_enabled then sorting.sort_orders(orders, global.player_settings[player_index].sorting_prefs) end -- WIP custom sorting (waiting for GUI)
	
	-- arrange the stacks in correct order into the t_chest inventory
	local i_slot = 1 -- the next valid slot index
	for i = 1, #orders do -- go one order at a time, this also ensures that there's going to be only one item type in each iteration of this loop
		local t_stacks = util.get_staks_with_order(orders[i], stacks)
		local damaged_stacks = {} -- because stacks with damage go at the end
		local first = true -- first can't merge with previous stacks, since they're a different type
		
		for i_stack = 1, #t_stacks do
			local c_stack = t_stacks[i_stack]
			
			if (not first) and t_chest_inventory[i_slot].name == c_stack.stack.name then -- there's a stack available for merge
				local free_space = c_stack.prototype.stack_size -  t_chest_inventory[i_slot].count
				
				local extra_properties = {}
				if c_stack.stack.type == "ammo" then extra_properties.ammo = c_stack.stack.ammo end
				if c_stack.stack.health and c_stack.stack.health ~= 1 then extra_properties.health = c_stack.stack.health end
				if c_stack.stack.durability then extra_properties.durability = c_stack.stack.durability end
				
				if extra_properties.ammo then -- ammo
					t_chest_inventory[i_slot + 1].set_stack(c_stack.stack) -- put the stack into the next slot
					if util.compress_ammo(t_chest_inventory[i_slot], t_chest_inventory[i_slot + 1]) then i_slot = i_slot + 1 end -- merge stacks and only iterate i_slot if the next slot still as something in it
					
				elseif extra_properties.health then -- item is damaged - put at the end and do not stack!
					table.insert(damaged_stacks, c_stack)
					
				elseif extra_properties.durability then -- durability (same as ammo)
					t_chest_inventory[i_slot + 1].set_stack(c_stack.stack)
					if util.compress_usable_stacks(t_chest_inventory[i_slot], t_chest_inventory[i_slot + 1]) then i_slot = i_slot + 1 end
					
				else -- everything else
					--[[if c_stack.stack.count == free_space then
						t_chest_inventory[i_slot].count = c_stack.prototype.stack_size
						
					else]]if c_stack.stack.count <= free_space then -- fits into the last stack
						t_chest_inventory[i_slot].count = t_chest_inventory[i_slot].count + c_stack.stack.count
						
					elseif c_stack.stack.count > free_space then -- doesn't fit into the last stack - merge and put overflow into the next one
						t_chest_inventory[i_slot].count = c_stack.prototype.stack_size
						i_slot = i_slot + 1
						c_stack.stack.count = c_stack.stack.count - free_space
						t_chest_inventory[i_slot].set_stack(c_stack.stack)
					end
				end
			else -- there are no stacks to merge with
				if c_stack.stack.health and c_stack.stack.health ~= 1 then -- damaged - goes to the end
					table.insert(damaged_stacks, c_stack)
					
				else -- set it to the next stack
					t_chest_inventory[i_slot].set_stack(c_stack.stack)
					first = false
				end
			end
		end
		
		for i_damaged = 1, #damaged_stacks do -- insert the dmaged stacks (for now these are inserted in the order they were originally - vanilla sorts them by ammount of health left)
			if not first then i_slot = i_slot + 1 else first = false end -- prevent overwriting last non-damaged slot if there is one
			t_chest_inventory[i_slot].set_stack(damaged_stacks[i_damaged].stack)
		end
		
		i_slot = i_slot + 1
	end
	
	------------ END OF SORTING ------------
	
	for i = 1, sort_limit do inventory[i].set_stack(t_chest_inventory[i]) end -- copy the sorted content back to the original inventory
	
	if sorting_player then t_chest_inventory.clear() -- leave the t_chest in place with empty inventory if we were sorting players inventory
	else t_chest.destroy() end -- destroy the chest otherwise
end

return sorting