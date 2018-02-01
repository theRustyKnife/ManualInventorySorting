--TODO: Empty the global table if migrating from an older version
--TODO: GUI
--TODO: Autosort toggle


local SORTABLE = {
	['container'] = true,
	['logistic-container'] = true,
	['car'] = true,
	['cargo-wagon'] = true,
}


local function sort_player(index)
	game.players[index].get_main_inventory().sort_and_merge()
end

local function sort_opened(index)
	local player = game.players[index]
	if player.opened and SORTABLE[player.opened.type] then
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
			if player.opened and SORTABLE[player.opened.type] then
				frame.add{type='button', name='manual-inventory-sort-opened', caption={'manual-inventory-gui-sort_chest'}}
			end
		end
	elseif player.gui.left['manual-inventory-sort-buttons'] then
		player.gui.left['manual-inventory-sort-buttons'].destroy()
	end
end


script.on_event('manual-inventory-sort', function(event) sort_player(event.player_index); end)

script.on_event('manual-inventory-sort-opened', function(event) sort_opened(event.player_index); end)


script.on_event(defines.events.on_gui_opened, function(event)
	--TODO: Cache this somewhere
	if settings.get_player_settings(game.players[event.player_index])['manual-inventory-sort-buttons'].value then
		sort_buttons_gui(event.player_index)
	end
end)
script.on_event(defines.events.on_gui_closed, function(event) sort_buttons_gui(event.player_index); end)

script.on_event(defines.events.on_gui_click, function(event)
	if event.element.name == 'manual-inventory-sort-player' then
		sort_player(event.player_index)
	elseif event.element.name == 'manual-inventory-sort-opened' then
		sort_opened(event.player_index)
	end
end)
