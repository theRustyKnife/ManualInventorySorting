--TODO: Autosort containers while open?
--TODO: Notify the player that the game's autosort has to be disabled either on init or on first autosort toggle.
--TODO: Reimplement partial inventory sorting using a dummy chest probably


------- Constants -------

local SORTABLE = {
	['container'] = true,
	['logistic-container'] = true,
	['car'] = true,
	['cargo-wagon'] = true,
	['spider-vehicle'] = true,
}

local SORTABLE_CONTROLLERS = {
	[defines.controllers.character] = true,
	[defines.controllers.god] = true,
}


------- Init options caching -------

local options_cache

local function load_options_cache(player_index)
	local options = settings.get_player_settings(player_index)
	return {
		sort_buttons = options['manual-inventory-sort-buttons'].value,
		sort_on_open = options['manual-inventory-sort-on-open'].value,
		sort_self_on_open = options['manual-inventory-sort-self-on-open'].value,
		auto_sort = options['manual-inventory-auto-sort'].value,
	}
end

local function init_options_cache(clear)
	if clear then
		storage.options_cache = nil
		options_cache = nil
	end

	storage.options_cache = storage.options_cache or {}
	options_cache = options_cache or setmetatable(storage.options_cache, {
		__index = function(self, player_index)
			local cache = load_options_cache(player_index)
			self[player_index] = cache
			return cache
		end,
	})
end

local function update_options_cache(player_index)
	if player_index then options_cache[player_index] = nil
	else options_cache = {}; end
end


script.on_init(init_options_cache)
script.on_load(init_options_cache)
script.on_configuration_changed(init_options_cache)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	if event.player_index then update_options_cache(event.player_index)
	else init_options_cache(true); end
end)


------- Some helper functions -------

local function sort_player(index)
	local player = game.get_player(index)
	if not SORTABLE_CONTROLLERS[player.controller_type] then return; end
	player.get_main_inventory().sort_and_merge()
end

local function sort_player_trash(index)
	local player = game.get_player(index)
	-- God controller doesn't have trash slots, so this is just hardcoded here for now.
	if player.controller_type ~= defines.controllers.character then return; end
	player.get_inventory(defines.inventory.character_trash).sort_and_merge()
end

local function sort_opened(index)
	local player = game.get_player(index)
	if not SORTABLE_CONTROLLERS[player.controller_type] then return; end
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
	local player = game.get_player(event.player_index)
	local options = settings.get_player_settings(player)

	local value = not options['manual-inventory-auto-sort'].value
	options['manual-inventory-auto-sort'] = {value = value}
	update_options_cache(player.index) -- This can be removed if the above line ever starts raising an event properly

	player.print{value and 'manual-inventory-auto-sort-on' or 'manual-inventory-auto-sort-off'}
	if value then sort_player(player.index); end
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(event)
	if options_cache[event.player_index].auto_sort then sort_player(event.player_index); end
end)


------- Gui stuff -------

local function sort_buttons_gui(player_index, closing)
	local player = game.get_player(player_index)
	local frame = player.gui.left['manual-inventory-sort-buttons']
	if not closing and (player.opened or player.opened_self) then
		if not frame then
			frame = player.gui.left.add{
				type = 'frame',
				name = 'manual-inventory-sort-buttons',
				direction = 'vertical',
				caption = {'manual-inventory-gui-sort-title'},
			}
			frame.add{type='button', name='manual-inventory-sort-player', caption={'manual-inventory-gui-sort_player'}}
			if player.controller_type == defines.controllers.character then
				frame.add{type='button', name='manual-inventory-sort-player-trash', caption={'manual-inventory-gui-sort_player_trash'}}
			end
			if player.opened_gui_type == defines.gui_type.entity and SORTABLE[player.opened.type] then
				frame.add{type='button', name='manual-inventory-sort-opened', caption=player.opened.localised_name}
			end
		end
	elseif frame then frame.destroy(); end
end


------- Gui events -------

script.on_event(defines.events.on_gui_opened, function(event)
local options = options_cache[event.player_index]

	if options.sort_buttons then sort_buttons_gui(event.player_index); end
	if options.sort_on_open then sort_opened(event.player_index); end
	if options.sort_self_on_open then sort_player(event.player_index); end
end)
script.on_event(defines.events.on_gui_closed, function(event) sort_buttons_gui(event.player_index, true); end)

script.on_event(defines.events.on_gui_click, function(event)
	if event.element.name == 'manual-inventory-sort-player' then sort_player(event.player_index)
	elseif event.element.name == 'manual-inventory-sort-player-trash' then sort_player_trash(event.player_index)
	elseif event.element.name == 'manual-inventory-sort-opened' then sort_opened(event.player_index); end
end)
