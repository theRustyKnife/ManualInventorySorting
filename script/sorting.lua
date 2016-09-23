util = require "util"

local sorting = {}

function sorting.sort_orders(orders, sorting_prefs)
	for i, v in pairs(sorting_prefs.keep_on_top) do
		util.remove_element(orders, v)
		table.insert(orders, 1, v)
	end
	
	return orders
end

function sorting.sort_inventory(arg)
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
	
	sort_limit_override = (sort_limit_override and global.player_settings[player_index].sort_limit_override) or force_override
	
	local player = game.players[player_index]
	if not inventory then inventory = player.get_inventory(defines.inventory.player_main) end
	local stacks = {}
	local orders = {}
	local sort_limit = #inventory
	
	if (not sort_limit_override) and global.player_settings[player_index].sort_limit_enabled then
		if global.player_settings[player_index].sort_limit >= 0 and global.player_settings[player_index].sort_limit < sort_limit then
			sort_limit = global.player_settings[player_index].sort_limit
		elseif global.player_settings[player_index].sort_limit < 0 and global.player_settings[player_index].sort_limit > 0 - sort_limit then
			sort_limit = sort_limit + global.player_settings[player_index].sort_limit
		end
	end
	
	for i = 1, sort_limit do -- put the content into a table
		local stack = inventory[i]
		if stack ~= nil and stack.valid_for_read and stack.valid then
			local prototype = game.item_prototypes[stack.name]
			
			local order = ""
			if (prototype.group) then order = order .. prototype.group.order .. prototype.group.name end
			if (prototype.subgroup) then order = order .. prototype.subgroup.order .. prototype.subgroup.name end
			if (prototype.order) then order = order .. prototype.order end
			order = order .. prototype.name
			
			table.insert(stacks, {stack = stack, prototype = prototype, order = order})
		end
	end
	
	for i, v in pairs(stacks) do -- make a list of all the order strings
		util.add_unique(orders, v.order)
	end
	table.sort(orders) -- sort the strings alphabetically
	
	if global.player_settings[player_index].custom_sort_enabled then sorting.sort_orders(orders, global.player_settings[player_index].sorting_prefs) end
	
	-- build a temporary chest to put the items into - this is a lazier way of saving all the stack properties
	local t_chest = player.surface.create_entity{name = "manual-inventory-sort-tmp-chest", position = player.position}
	t_chest.destructible = false
	t_chest.operable = false
	local t_chest_inventory = t_chest.get_inventory(defines.inventory.chest)
	
	local i_slot = 1	
	for i = 1, #orders do -- order the items into the chest (this is where the actual sorting is done)
		local t_stacks = util.get_staks_with_order(orders[i], stacks)
		local damaged_stacks = {}
		local first = true
		
		for i_stack = 1, #t_stacks do
			local c_stack = t_stacks[i_stack]
			
			if (not first) and t_chest_inventory[i_slot].name == c_stack.stack.name then
				local free_space = c_stack.prototype.stack_size -  t_chest_inventory[i_slot].count
				
				local extra_properties = {}
				if c_stack.stack.type == "ammo" then extra_properties.ammo = c_stack.stack.ammo end
				if c_stack.stack.health and c_stack.stack.health ~= 1 then extra_properties.health = c_stack.stack.health end
				if c_stack.stack.durability then extra_properties.durability = c_stack.stack.durability end
				
				if extra_properties.ammo then -- ammo
					t_chest_inventory[i_slot + 1].set_stack(c_stack.stack)
					if util.compress_ammo(t_chest_inventory[i_slot], t_chest_inventory[i_slot + 1]) then i_slot = i_slot + 1 end
				elseif extra_properties.health then -- item is damaged - put at the end and do not stack!
					table.insert(damaged_stacks, c_stack)
				elseif extra_properties.durability then -- durability
					t_chest_inventory[i_slot + 1].set_stack(c_stack.stack)
					if util.compress_usable_stacks(t_chest_inventory[i_slot], t_chest_inventory[i_slot + 1]) then i_slot = i_slot + 1 end
				else -- everything else
					if c_stack.stack.count == free_space then
						t_chest_inventory[i_slot].count = c_stack.prototype.stack_size
						
					elseif c_stack.stack.count < free_space then t_chest_inventory[i_slot].count = t_chest_inventory[i_slot].count + c_stack.stack.count
					elseif c_stack.stack.count > free_space then
						t_chest_inventory[i_slot].count = c_stack.prototype.stack_size
						i_slot = i_slot + 1
						c_stack.stack.count = c_stack.stack.count - free_space
						t_chest_inventory[i_slot].set_stack(c_stack.stack)
					end
				end
			else
				if c_stack.stack.health and c_stack.stack.health ~= 1 then table.insert(damaged_stacks, c_stack)
				else 
					t_chest_inventory[i_slot].set_stack(c_stack.stack)
					first = false
				end
			end
		end
		
		for i_damaged = 1, #damaged_stacks do
			if not first then i_slot = i_slot + 1 else first = false end
			t_chest_inventory[i_slot].set_stack(damaged_stacks[i_damaged].stack)
		end
		
		i_slot = i_slot + 1
	end
	
	if (t_chest.valid) then
		for i = 1, sort_limit do inventory[i].set_stack(t_chest_inventory[i]) end
		t_chest.destroy()
	end
end

return sorting