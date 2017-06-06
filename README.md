# Description #
**Ever wanted to split your stacks before inserting them into machines but still keep the inventory nicely sorted? Or perhaps you just wanted to organize the inventory to your liking?
Well then I'm here to save you from the trouble of opening the settings menu.**  
This mod adds various hotkeys and settings to allow you to sort your inventory exactly the way you want to.

-----------------------
# Features #
- A  hotkey to sort inventory (default: "shift + q")
- A hotkey to sort the currently open chest, car or wagon (default: "ctrl + q") - Thanks to Tone for [this](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1363) suggestion
- GUI to sort inventory - Thanks to Adventurer for [this](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1416) suggestion
- A hotkey to toggle auto-sort (default: "shift + y")
- Options menu (by default opened with "shift + x")
- Part inventory sorting (toggled from the options) - Thanks to ssilk for [this](https://forums.factorio.com/viewtopic.php?f=6&t=29675#p188530) suggestion (unfortunately I couldn't make the dragbar)

# Hotkeys #
*All hotkeys are customizable in the games settings.*

- "shift + q" = sort inventory
- "ctrl + q" = sort open chest
- "shift + y" = toggle auto-sort
- "shift + x" = open options menu

# Options menu #
- Enable/disable automatic inventory sorting
- Enable/disable and configure part inventory sorting
    - The number in the textfield determines how much of your inventory is going to be sorted (in slots, starting top-left). If the number is negative, it's going to leave that many slots at the end unsorted 
    - Manual sorting ignores limit makes the manual shortcut sort the entire inventory even if you set a limit
    - Sorting limit is always ignored when sorting chests
- Display sorting buttons makes buttons appear when you open your inventory that allow you to sort without using hotkeys

# Future plans #
- Custom sorting (keep certain items on top and so on)

**Any feedback or suggestions are welcome!**

**You can now also ask questions on the [forum](https://forums.factorio.com/viewtopic.php?f=92&t=34409)!**

**[Check out my other mods too!](https://mods.factorio.com/mods/theRustyKnife)**

---------------------
# Changelog #
## 1.6.1 ##
* Fixed stackable items with equipment grids could get deleted in some cases ([14638](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/14638))

## 1.6.0 ##
* Updated for Factorio 0.15

## 1.5.5 ##
* Fixed sorting of certain items would cause a crash when there were filters for them ([6067](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/6067))
* Fixed a possible crash when sorting cars or wagons with bigger inventories than any chest

## 1.5.4 ##
* Fixed filtered car sorting ([5284](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/5284))

## 1.5.3 ##
* Fixed temporary chests being selectable ([3947](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3947))

## 1.5.2 ##
* No more temporary entity spawning and destroying on every player inventory sort
* Fixed filtered cargo-wagons weren't sorted properly

## 1.5.1 ##
* Removed the left-over debugging message when auto-sorting

## 1.5.0 ##
* Internal changes
* Improved auto-sort performance ([3558](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3558))

## 1.4.5 ##
* Fixed GUI buttons would not appear when opened a logistic chest
+ Added car and wagon sorting
+ Added Russian translation thanks to [Apriori](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/3041)

## 1.4.4 ##
* Updated for Factorio 0.14

## 1.4.3 ##
* Fixed sorting big chests caused a crash ([2008](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/2008))

## 1.4.2 ##
* Fixed logistic chests were not sortable ([1519](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1519))

## 1.4.1 ##
* Fixed a bug causing a crash when loading existing saves without the mod installed before ([1494](https://mods.factorio.com/mods/theRustyKnife/manual-inventory-sort/discussion/1494))

## 1.4.0 ##
* Fixed broken migration script (hopefully), apologies to anyone who had problems with this - it should be safe now to migrate from any version to 1.4
+ Added sorting GUI

## 1.3.0 ##
* Changed the default shortcuts to use shift instead of ctrl (it's a lot more comfortable this way)
+ Added chest sorting

## 1.2.0 ##
+ Addded an options menu
+ Added part inventory sorting

## 1.1.2 ##
* Use of new API features of 0.13.12 to get rid of the need to place temporary entities

## 1.1.1 ##
* Fixed auto-sort performance, now sorting is done only when actually needed

## 1.1.0 ##
* Fixed a bug making it possible to duplicate items with durability in certain cases
+ Added the auto-sort feature. It has performance problems to be solved though.

## 1.0.1 ##
* Fixed a bug causing items to be lost when inserted in the tick after sorting was triggered

## 1.0.0 ##
+ Initial release
