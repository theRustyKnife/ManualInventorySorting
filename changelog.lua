return {
	{
		name = "1.8.1",
		date = "16. 12. 2017",
		Bugfixes = {
			"Fixed filters in the main inventory weren't taken into account",
		},
	},
	{
		name = "1.8.0",
		date = "16. 12. 2017",
		Changes = {
			"Updated for 0.16",
		},
		Bugfixes = {
			{
				"Fixed that opened blueprint books and similar items would close when the inventory was sorted",
				more = {["4"] = "https://github.com/theRustyKnife/ManualInventorySorting/issues/4"},
			},
		},
	},
	{
		name = "1.7.0",
		date = "15. 07. 2017",
		Features = {
			{
				"A new option for part inventory sorting for sorting beggining/end of the inventory",
				more = {["10"] = "https://github.com/theRustyKnife/ManualInventorySorting/pull/10"},
			},
		},
	},
	{
		name = "1.6.1",
		date = "05. 06. 2017",
		Bugfixes = {
			{
				"Fixed stackable items with equipment grids could get deleted in some cases",
				more = {["14638"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/14638"},
			},
		},
	},
	{
		name = "1.6.0",
		date = "24. 04. 2017",
		Changes = {
			"Updated for Factorio 0.15",
		},
	},
	{
		name = "1.5.5",
		date = "10. 12. 2016",
		Bugfixes = {
			{
				"Fixed sorting of certain items would cause a crash when there were filters for them",
				more = {["6067"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/6067"},
			},
			"Fixed a possible crash when sorting cars or wagons with bigger inventories than any chest",
		},
	},
	{
		name = "1.5.4",
		date = "07. 11. 2016",
		Bugfixes = {
			{
				"Fixed filtered car sorting",
				more = {["5284"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/5284"},
			},
		},
	},
	{
		name = "1.5.3",
		date = "27. 09. 2016",
		Bugfixes = {
			{
				"Fixed temporary chests being selectable",
				more = {["3947"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3947"},
			},
		},
	},
	{
		name = "1.5.2",
		date = "29. 06. 2017",
		Bugfixes = {
			"No more temporary entity spawning and destroying on every player inventory sort",
			"Fixed filtered cargo-wagons weren't sorted properly",
		},
	},
	{
		name = "1.5.1",
		date = "21. 09. 2016",
		Bugfixes = {
			"Removed the left-over debugging message when auto-sorting",
		},
	},
	{
		name = "1.5.0",
		date = "19. 09. 2016",
		Changes = {
			"Internal changes",
			{
				"Improved auto-sort performance",
				more = {["3558"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3558"},
			},
		},
	},
	{
		name = "1.4.5",
		date = "06. 09. 2016",
		Bugfixes = {
			"Fixed GUI buttons would not appear when opened a logistic chest",
		},
		Features = {
			"Added car and wagon sorting",
			{
				"Added Russian translation",
				by = {["Apriori"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3041"},
			},
		},
	},
	{
		name = "1.4.4",
		date = "26. 08. 2016",
		Changes = {
			"Updated for Factorio 0.14",
		},
	},
	{
		name = "1.4.3",
		date = "12. 08. 2016",
		Bugfixes = {
			{
				"Fixed sorting big chests caused a crash",
				more = {["2008"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/2008"},
			},
		},
	},
	{
		name = "1.4.2",
		date = "02. 08. 2016",
		Bugfixes = {
			{
				"Fixed logistic chests were not sortable",
				{["1519"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1519"},
			},
		},
	},
	{
		name = "1.4.1",
		date = "30. 07. 2016",
		Bugfixes = {
			{
				"Fixed a bug causing a crash when loading existing saves without the mod installed before",
				{["1494"] = "https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1494"},
			},
		},
	},
	{
		name = "1.4.0",
		date = "30. 07. 2016",
		Bugfixes = {
			"Fixed broken migration script (hopefully), apologies to anyone who had problems with this - it should be safe now to migrate from any version to 1.4",
		},
		Features = {
			"Added sorting GUI",
		},
	},
	{
		name = "1.3.0",
		date = "30. 07. 2016",
		Changes = {
			"Changed the default shortcuts to use shift instead of ctrl (it's a lot more comfortable this way)",
		},
		Features = {
			"Added chest sorting",
		},
	},
	{
		name = "1.2.0",
		date = "30. 07. 2016",
		Features = {
			"Addded an options menu",
			"Added part inventory sorting",
		},
	},
	{
		name = "1.1.2",
		date = "30. 07. 2016",
		Changes = {
			"Use of new API features of 0.13.12 to get rid of the need to place temporary entities",
		},
	},
	{
		name = "1.1.1",
		date = "28. 07. 2016",
		Bugfixes = {
			"Fixed auto-sort performance, now sorting is done only when actually needed",
		},
	},
	{
		name = "1.1.0",
		date = "27. 07. 2016",
		Bugfixes = {
			"Fixed a bug making it possible to duplicate items with durability in certain cases",
		},
		Features = {
			"Added the auto-sort feature. It has performance problems to be solved though.",
		},
	},
	{
		name = "1.0.1",
		date = "27. 07. 2016",
		Bugfixes = {
			"Fixed a bug causing items to be lost when inserted in the tick after sorting was triggered",
		},
	},
	{
		name = "1.0.0",
		"Initital release",
	},
}
