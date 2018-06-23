--TODO: Autosort containers while open?
--TODO: Stop autosort while open?
--TODO: Autosort state indicator?


local SORTABLE = {
	['container'] = true,
	['logistic-container'] = true,
	['car'] = true,
	['cargo-wagon'] = true,
}


local function init()
	global.auto_sort = global.auto_sort or {}
end


local function sort_player(index)
	game.players[index].get_main_inventory().sort_and_merge()
end

local function sort_opened(index)
	local player = game.players[index]
	if player.opened_gui_type == defines.gui_type.entity and SORTABLE[player.opened.type] then
		(
			player.opened.get_inventory(defines.inventory.car_trunk) or
			player.opened.get_inventory(defines.inventory.chest) or
			player.opened.get_inventory(defines.inventory.cargo_wagon)
		).sort_and_merge()
	end
end


local function sort_buttons_gui(index)
	local player = game.players[index]
	if player.opened or player.opened_self then
		if not player.gui.left['manual-inventory-sort-buttons'] then
			local frame = player.gui.left.add{
				type='frame',
				name='manual-inventory-sort-buttons',
				direction='vertical',
				caption={'manual-inventory-gui-sort-title'},
			}
			frame.add{type='button', name='manual-inventory-sort-player', caption={'manual-inventory-gui-sort_player'}}
			if player.opened_gui_type == defines.gui_type.entity and SORTABLE[player.opened.type] then
				frame.add{type='button', name='manual-inventory-sort-opened', caption={'manual-inventory-gui-sort_chest'}}
			end
		end
	elseif player.gui.left['manual-inventory-sort-buttons'] then
		player.gui.left['manual-inventory-sort-buttons'].destroy()
	end
end


script.on_init(init)
script.on_configuration_changed(init) --TODO: Empty the global table if migrating from an older version


script.on_event('manual-inventory-sort', function(event) sort_player(event.player_index); end)

script.on_event('manual-inventory-sort-opened', function(event) sort_opened(event.player_index); end)

script.on_event('manual-inventory-auto-sort-toggle', function(event)
	local player = game.players[event.player_index]
	global.auto_sort[player.index] = not global.auto_sort[player.index]
	if global.auto_sort[player.index] then
		player.print{"manual-inventory-auto-sort-on"}
		sort_player(player.index)
	else player.print{"manual-inventory-auto-sort-off"}; end
end)


script.on_event(defines.events.on_player_main_inventory_changed, function(event)
	if global.auto_sort[event.player_index] then sort_player(event.player_index); end
end)


script.on_event(defines.events.on_gui_opened, function(event)
	local player = game.players[event.player_index]
	local options = settings.get_player_settings(player)
	
	if options['manual-inventory-sort-buttons'].value then sort_buttons_gui(player.index); end
	if options['manual-inventory-sort-on-open'].value then sort_opened(player.index); end
	if options['manual-inventory-sort-self-on-open'].value then sort_player(player.index); end
end)
script.on_event(defines.events.on_gui_closed, function(event) sort_buttons_gui(event.player_index); end)

script.on_event(defines.events.on_gui_click, function(event)
	if event.element.name == 'manual-inventory-sort-player' then
		sort_player(event.player_index)
	elseif event.element.name == 'manual-inventory-sort-opened' then
		sort_opened(event.player_index)
	end
end)
