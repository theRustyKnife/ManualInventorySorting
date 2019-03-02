--TODO: Autosort containers while open?
--TODO: Notify the player that the game's autosort has to be disabled either on init or on first autosort toggle.
--TODO: Reimplement partial inventory sorting using a dummy chest probably


------- Constants -------

local SORTABLE = {
	['container'] = true,
	['logistic-container'] = true,
	['car'] = true,
	['cargo-wagon'] = true,
}


------- Init options caching -------

local function update_options_cache(player_index)
	local options = settings.get_player_settings(player_index)
	local cache = global.options_cache[player_index] or {}
	global.options_cache[player_index] = cache
	
	cache.sort_buttons = options['manual-inventory-sort-buttons'].value
	cache.sort_on_open = options['manual-inventory-sort-on-open'].value
	cache.sort_self_on_open = options['manual-inventory-sort-self-on-open'].value
	cache.auto_sort = options['manual-inventory-auto-sort'].value
end

local function init()
	if not global.options_cache then
		global.options_cache = {}
		for _, player in pairs(game.players) do update_options_cache(player.index); end
	end
end

script.on_init(init)
script.on_configuration_changed(init)
script.on_event(defines.events.on_player_joined_game, function(event) update_options_cache(event.player_index); end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	update_options_cache(event.player_index)
end)


------- Some helper functions -------

local function sort_player(index) game.players[index].get_main_inventory().sort_and_merge(); end

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


------- Sorting event handling -------

script.on_event('manual-inventory-sort', function(event) sort_player(event.player_index); end)
script.on_event('manual-inventory-sort-opened', function(event) sort_opened(event.player_index); end)

script.on_event('manual-inventory-auto-sort-toggle', function(event)
	local player = game.players[event.player_index]
	local options = settings.get_player_settings(player)
	
	local value = not options['manual-inventory-auto-sort'].value
	options['manual-inventory-auto-sort'] = {value = value}
	update_options_cache(player.index) -- This can be removed if the above line ever starts raising an event properly
	
	player.print{value and 'manual-inventory-auto-sort-on' or 'manual-inventory-auto-sort-off'}
	if value then sort_player(player.index); end
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(event)
	if global.options_cache[event.player_index].auto_sort then sort_player(event.player_index); end
end)


------- Gui stuff -------

local function sort_buttons_gui(player_index)
	local player = game.players[player_index]
	local frame = player.gui.left['manual-inventory-sort-buttons']
	if player.opened or player.opened_self then
		if not frame then
			frame = player.gui.left.add{
				type = 'frame',
				name = 'manual-inventory-sort-buttons',
				direction = 'vertical',
				caption = {'manual-inventory-gui-sort-title'},
			}
			frame.add{type='button', name='manual-inventory-sort-player', caption={'manual-inventory-gui-sort_player'}}
			if player.opened_gui_type == defines.gui_type.entity and SORTABLE[player.opened.type] then
				frame.add{type='button', name='manual-inventory-sort-opened', caption={'manual-inventory-gui-sort_chest'}}
			end
		end
	elseif frame then frame.destroy(); end
end


------- Gui events -------

script.on_event(defines.events.on_gui_opened, function(event)
	local options = global.options_cache[event.player_index]
	
	if options.sort_buttons then sort_buttons_gui(event.player_index); end
	if options.sort_on_open then sort_opened(event.player_index); end
	if options.sort_self_on_open then sort_player(event.player_index); end
end)
script.on_event(defines.events.on_gui_closed, function(event) sort_buttons_gui(event.player_index); end)

script.on_event(defines.events.on_gui_click, function(event)
	if event.element.name == 'manual-inventory-sort-player' then sort_player(event.player_index)
	elseif event.element.name == 'manual-inventory-sort-opened' then sort_opened(event.player_index); end
end)
