# Description #
**Ever wanted to split your stacks before inserting them into machines but still keep the inventory nicely sorted? Or perhaps you just wanted to organize the inventory to your liking?
Well then I'm here to save you from the trouble of opening the settings menu.**  
This mod adds various hotkeys and settings to allow you to sort your inventory exactly the way you want to.

-----------------------
# Features #
- A  hotkey to sort inventory (default: "shift + q")
- A hotkey to sort the currently open chest, car or wagon (default: "ctrl + q")
- GUI to sort inventory
- A hotkey to toggle auto-sort (default: "shift + y")
- ~~Part inventory sorting (toggled from the options)~~ Removed in 2.0 because the new system doesn't allow it

**Note that the game's auto-sort has to be disabled for the player inventory sorting features to work.**  
If you only want to use the chest sorting features and have auto-sort on, leave the game's auto-sort on, but make sure the mod's auto-sort is off, so the inventory doesn't get sorted twice.

# Hotkeys #
*All hotkeys are customizable in the game's settings.*

- "shift + q" = sort inventory
- "ctrl + q" = sort open chest
- "shift + y" = toggle auto-sort

**Any feedback or suggestions are welcome!**

**You can also ask questions on the [forum](https://forums.factorio.com/viewtopic.php?f=92&t=34409)!**

**[Check out my other mods too!](https://mods.factorio.com/user/theRustyKnife)**

---------------------
## 2.0.0 ##
### Features ###
 - Added an option to automatically sort containers when opened ([5a5f1b0dadcc441024d76d79](https://mods.factorio.com/mod/manual-inventory-sort/discussion/5a5f1b0dadcc441024d76d79))
 - Added an option to automatically sort player's inventory when opened
### Changes ###
 - Used the new API features to replace the old sorting mechanism ([0.16.21](https://forums.factorio.com/viewtopic.php?f=3&t=57372#p339957))
 - Autosort is now much faster and sorts on each inventory change
 - Settings have been moved to the mod options (autosort is only togglable via the hotkey)
 - Removed part inventory sorting as it's not possible with the new system

## 1.8.1 ##
### Bugfixes ###
 - Fixed filters in the main inventory weren't taken into account

## 1.8.0 ##
### Bugfixes ###
 - Fixed that opened blueprint books and similar items would close when the inventory was sorted ([4](https://github.com/theRustyKnife/ManualInventorySorting/issues/4))
### Changes ###
 - Updated for 0.16

## 1.7.0 ##
### Features ###
 - A new option for part inventory sorting for sorting beggining/end of the inventory ([10](https://github.com/theRustyKnife/ManualInventorySorting/pull/10))

## 1.6.1 ##
### Bugfixes ###
 - Fixed stackable items with equipment grids could get deleted in some cases ([14638](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/14638))

## 1.6.0 ##
### Changes ###
 - Updated for Factorio 0.15

## 1.5.5 ##
### Bugfixes ###
 - Fixed sorting of certain items would cause a crash when there were filters for them ([6067](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/6067))
 - Fixed a possible crash when sorting cars or wagons with bigger inventories than any chest

## 1.5.4 ##
### Bugfixes ###
 - Fixed filtered car sorting ([5284](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/5284))

## 1.5.3 ##
### Bugfixes ###
 - Fixed temporary chests being selectable ([3947](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3947))

## 1.5.2 ##
### Bugfixes ###
 - No more temporary entity spawning and destroying on every player inventory sort
 - Fixed filtered cargo-wagons weren't sorted properly

## 1.5.1 ##
### Bugfixes ###
 - Removed the left-over debugging message when auto-sorting

## 1.5.0 ##
### Changes ###
 - Internal changes
 - Improved auto-sort performance ([3558](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3558))

## 1.4.5 ##
### Bugfixes ###
 - Fixed GUI buttons would not appear when opened a logistic chest
### Features ###
 - Added car and wagon sorting
 - Added Russian translation (by [Apriori](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3041))

## 1.4.4 ##
### Changes ###
 - Updated for Factorio 0.14

## 1.4.3 ##
### Bugfixes ###
 - Fixed sorting big chests caused a crash ([2008](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/2008))

## 1.4.2 ##
### Bugfixes ###
 - Fixed logistic chests were not sortable

## 1.4.1 ##
### Bugfixes ###
 - Fixed a bug causing a crash when loading existing saves without the mod installed before

## 1.4.0 ##
### Bugfixes ###
 - Fixed broken migration script (hopefully), apologies to anyone who had problems with this - it should be safe now to migrate from any version to 1.4
### Features ###
 - Added sorting GUI

## 1.3.0 ##
### Features ###
 - Added chest sorting
### Changes ###
 - Changed the default shortcuts to use shift instead of ctrl (it's a lot more comfortable this way)

## 1.2.0 ##
### Features ###
 - Addded an options menu
 - Added part inventory sorting

## 1.1.2 ##
### Changes ###
 - Use of new API features of 0.13.12 to get rid of the need to place temporary entities

## 1.1.1 ##
### Bugfixes ###
 - Fixed auto-sort performance, now sorting is done only when actually needed

## 1.1.0 ##
### Bugfixes ###
 - Fixed a bug making it possible to duplicate items with durability in certain cases
### Features ###
 - Added the auto-sort feature. It has performance problems to be solved though.

## 1.0.1 ##
### Bugfixes ###
 - Fixed a bug causing items to be lost when inserted in the tick after sorting was triggered

## 1.0.0 ##
 - Initital release
