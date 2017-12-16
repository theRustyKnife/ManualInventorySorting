data:extend({
	{
		type = "custom-input",
		name = "manual-inventory-sort",
		key_sequence = "SHIFT + Q",
		consuming = "all"
	},
	{
		type = "custom-input",
		name = "manual-inventory-sort-opened",
		key_sequence = "CONTROL + Q",
		consuming = "all"
	},
	{
		type = "custom-input",
		name = "manual-inventory-auto-sort-toggle",
		key_sequence = "SHIFT + Y",
		consuming = "all"
	},
	{
		type = "custom-input",
		name = "manual-inventory-options",
		key_sequence = "SHIFT + X",
		consuming = "all"
	},
	{
		type = "container",
		name = "manual-inventory-sort-tmp-chest",
		icon = "__manual-inventory-sort__/graphics/trans.png",
		icon_size = 32,
		flags = {"placeable-neutral", "placeable-off-grid"},
		max_health = 10000,
		selectable_in_game = false,
		corpse = "small-remnants",
		collision_mask = {},
		collision_box = {{0, 0}, {0, 0}},
		selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
		inventory_size = 1000,
		order = "none",
		open_sound = { filename = "__base__/sound/wooden-chest-open.ogg" },
		close_sound = { filename = "__base__/sound/wooden-chest-close.ogg" },
		vehicle_impact_sound =  { filename = "__base__/sound/car-wood-impact.ogg", volume = 1.0 },
		picture =
		{
			filename = "__manual-inventory-sort__/graphics/trans.png",
			priority = "extra-high",
			width = 0,
			height = 0
		},
		circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
		circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
		circuit_wire_max_distance = 0
	},
})