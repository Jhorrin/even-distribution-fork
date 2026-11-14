# Mod guide

Even Distribution Fork for Factorio 2.1. Fill several buildings at once or move excess inventory items into nearby machines.

> [!NOTE]
> See the [Mod Portal downloads](https://mods.factorio.com/mod/even-distribution-fork/downloads) for the version available in-game.

[Mod Portal](https://mods.factorio.com/mod/even-distribution-fork) · [Report an issue](https://github.com/Jhorrin/even-distribution-fork/issues/new)

## How it works

| Action | Controls |
| --- | --- |
| **Drag** | Hold an item and start the drag away from buildings that can take items. Concrete, pipes, and solar panels are fine. Sweep across buildings with **Ctrl + Left mouse**. **Ctrl + Right mouse** offers half. |
| **Dump** | Press **Shift + C** to move excess items to compatible buildings nearby. |

Both actions use the distribution mode you selected. In **Even Distribute**, a full building's rejected Drag share stays with you. Dump can try the remaining eligible destinations. Items that cannot be placed stay at their source.

**Balance Inventory** counts what is already in each building and aims for even final stock. It can also redistribute matching stock from ordinary machines and chests. Existing stock in turrets and vehicles stays in place during balancing.

<details>
<summary>Distribution example</summary>

Offer **60 items** to three buildings that already contain **30 / 0 / 0**.

| Mode | Items added | Final stock |
| --- | --- | --- |
| **Even Distribute** | 20 / 20 / 20 | **50 / 20 / 20** |
| **Balance Inventory** | 0 / 30 / 30 | **30 / 30 / 30** |

</details>

<details>
<summary>Watch the original Drag demonstration</summary>

![321freddy's original Drag demonstration](https://assets-mod.factorio.com/assets/ext/c77df84062b34f76cd391c99e2d49f3426023951df1daa8e7dd7bde26b7cf1cc.gif)

</details>

## Settings

Blue button beside your inventory, or the GUI Unifyer bar.

### General

- **Distribution mode** offers Even Distribute or Balance Inventory.
- **Fuel and ammo limits** apply per building. Enable separately for Drag and Dump.

### Drag

- **Distribute items from** selects cursor, inventory and vehicle cargo.
- **Ammo and fuel upgrades** allow stronger ammo or coal in place of wood, at the same quality.

### Dump

- **Dump ammo** is on by default.
- **Dump higher-quality items (Beta)** is off by default.
- **Destinations** include chests with matching stock, requester chests and optional machine outputs.

### Advanced

| Setting | What it does |
| --- | --- |
| **Spoiled first / Fresh first** | Freshness order for Drag and Dump. |
| **Low tier ammo first / High tier ammo first** | Dump order within each ammo family. |
| **Low fuel value first / High fuel value first** | Fuel order for Dump. |
| **Respect requests / Ignore requests** | Respect (default) keeps up to your request maximum and uses default filters for unrequested items. Ignore skips both and keeps the equipped ammo reserve. |
| **Distribution delay** | Wait before Drag applies. Default 0.9 s. |
| **Inventory Cleanup range** | Dump search radius. Default cap 30 tiles. |
| **Ignored buildings** | Building types skipped by Drag and Dump. |

## Changes since the original

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Bioflux.png/32px-Bioflux.png"> Bio items

Spoilable items are distributed in three groups, from mostly spoiled through medium freshness to fresh. Freshness is averaged by item count within the group being transferred.

- **2.1.9** starts with the oldest available group for each item. Repeat Drag or Dump to distribute further groups.
- **2.2.0** adds **Spoiled first** (default) and **Fresh first** under **Advanced**. One Drag can work through up to three groups as space allows. Dump offers one group per item.

**Nutrients** can fill recipe inputs and fuel slots. In **2.2.0**, dragging Nutrients over a Biochamber that can use both opens **Where do you want the nutrients?** Choose **Input slot**, **Fuel slot**, **Both**, or **Cancel**. Dump can also fill a matching Bioflux recipe input and the Nutrients fuel slot in the same action.

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Firearm_magazine.png/32px-Firearm_magazine.png"> Ammo

Dump offers partly spent magazines first within each type. **Dump → Ignore requests** keeps a reserve of **100** for each equipped ammo type and quality across weapon slots, inventory and cursor. **Respect requests** uses the personal request maximum instead.

**Dump ammo** is on by default. The ammo order under **Advanced** applies within each ammo family, including magazines, cannon shells, and rockets.

Drag can move multiple stacks in one action with **Inventory** selected under **Distribute items from**. The ammo limit applies per destination.

**Atomic bombs** can go to compatible turrets through Drag. Dump can send them to eligible chests.

<details>
<summary>Ammo and personal requests</summary>

You have **1,000 piercing magazines total**, with 980 in inventory and 20 equipped. Your request maximum is **600**. The 48 empty gun turrets have a limit of **0.2 stacks** (20 magazines each).

| After one Dump | To turrets | Left in inventory | Equipped |
| --- | ---: | ---: | ---: |
| **Respect requests** | 380 (7 or 8 each) | 600 | 20 |
| **Ignore requests** | 900 (18 or 19 each) | 80 | 20 |

**Ignore requests** leaves 100 magazines across inventory and weapon slots. Your request stays at 600.

</details>

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Rocket_fuel.png/32px-Rocket_fuel.png"> Fuel

Dump refills boilers and other compatible burners, subject to the configured fuel limit. **2.2.0** adds **Low fuel value first** (default) and **High fuel value first** under **Advanced**. With **Respect requests**, Dump keeps the fuel you’ve requested in personal logistics. Fuel in trash slots is available in either mode.

### Quality

Drag supports all qualities. Dump handles Normal quality by default. **2.2.0** adds the opt-in **Dump higher-quality items (Beta)** setting. Hover over its **ⓘ** for details before distributing valuable items.

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Speed_module_3.png/32px-Speed_module_3.png"> Dragging modules

Drag opens the module popup when a building accepts the module in both its input slot and its module slot. Choose **Input slot**, **Module slot**, or **Cancel**.

### Dragging placeable items

Drag can distribute placeable items such as transport belts to machines that use them as recipe ingredients.

### Protected destinations

| Destination | Dump behavior |
| --- | --- |
| Recycler and heating tower | Tops up the input or fuel slot once it already contains items. Use Drag to fill it initially. |
| Nuclear and fusion reactors | Use Drag to supply them. |

## Settings, compatibility, and fixes

<details>
<summary>Settings and compatibility</summary>

- Added more help icons.
- **Space Age** and **GUI Unifyer** are recommended dependencies. Other Even Distribution variants are incompatible.
- Fixed Modlist UI requests for outdated thumbnail dimensions.
- Inherited Dump defaults take effect when matching items or groups exist. The original defaults include Bob’s Mods, Angel’s Mods, Pyanodons, Space Exploration, Industrial Revolution, DyTech, and ScienceCostTweaker. Current overhaul versions have not been retested. The original mod marked DyTech and Pyanodons as untested.

</details>

<details>
<summary>Reliability and performance</summary>

- Supports Factorio 2.1 fuel categories and preserves quality, remaining shots, durability, and health during transfers.
- Handles partial transfers and rejected shares, restores cursor items safely after native transfers, and preserves allocation order when buildings fill.
- Imports preferences and ignored-building entries from the original mod. Mod updates preserve saved preferences.
- Corrected Spidertron marker positions and recognized recipe outputs with a zero minimum yield.
- Reduced repeated inventory scans, temporary-inventory allocation, and transfer backup cleanup.

</details>

## Feedback

**Popups and toggles.** Do the popups appear when you expect them? How do the freshness, ammo, and fuel toggles feel in play?

**Reports.** The Mod Portal and GitHub are equally welcome. Use GitHub for screenshots or videos. A GitHub account is required to post there.

[Mod Portal discussion](https://mods.factorio.com/mod/even-distribution-fork/discussion) · [GitHub Issues](https://github.com/Jhorrin/even-distribution-fork/issues/new)

## Credits

- Original mod by [321freddy](https://mods.factorio.com/user/321freddy)
- Fork and maintenance by [Jhorr](https://mods.factorio.com/user/Jhorr)
- Initial spoilage preservation contribution by [FallenPaladin](https://mods.factorio.com/user/FallenPaladin)
- Quality-loss report by [Sgamez](https://mods.factorio.com/user/Sgamez)
- Module handling report by [Deadpoolweid](https://mods.factorio.com/user/Deadpoolweid)

Icons from the [Factorio Wiki](https://wiki.factorio.com/) and [Wube Software](https://www.factorio.com/).
