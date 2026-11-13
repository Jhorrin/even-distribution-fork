# Mod guide

Even Distribution Fork for Factorio 2.1. Fill several buildings at once or move excess inventory items into nearby machines.

> [!NOTE]
> See the [Mod Portal downloads](https://mods.factorio.com/mod/even-distribution-fork/downloads) for the version available in-game.

[Mod Portal](https://mods.factorio.com/mod/even-distribution-fork) · [Report an issue](https://github.com/Jhorrin/even-distribution-fork/issues/new)

## How it works

| Action | Controls |
| --- | --- |
| **Drag** | Hold an item, start over empty ground, and sweep across the buildings with **Ctrl + Left mouse**. **Ctrl + Right mouse** offers half. |
| **Dump** | Press **Shift + C** to move excess items to compatible buildings nearby. |

Both actions use the distribution mode you selected. In **Even Distribute**, a full building's rejected Drag share stays with you. Dump can try the remaining eligible destinations. Items that cannot be placed stay at their source.

**Balance Inventory** can move matching items between buildings to even out their stock. When turrets or vehicles are destinations, their existing stock counts toward the balance and stays in place. Drag can swap loaded ammo for stronger ammo when upgrades are enabled.

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

Open the **blue button beside your inventory**. With GUI Unifyer installed, the shared mod button opens the settings fully expanded.

- Choose Drag sources from the cursor, inventory, and vehicle cargo.
- Set separate fuel and ammo limits for Drag and Dump. Drag can upgrade ammo and swap wood for coal.
- Configure range, delay, and ignored buildings. Hover over **ⓘ** for setting details.
- Enable chest filling or machine output filling as needed. Ordinary chests need the item already inside. Requester chests follow their requests.

**Personal logistic requests** tell regular Dump how much to keep. It uses the requested maximum by default. Enable minimum-request cleanup to use the minimum instead. A minimum of 0 and an unlimited maximum exclude the item from regular Dump. **2.2.0** can still top up compatible ammo and fuel slots from requested stock.

## Changes since the original

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Bioflux.png/32px-Bioflux.png"> Bio items

Spoilable items are distributed in three groups, from mostly spoiled through medium freshness to fresh. Freshness is averaged by item count within the group being transferred.

- **2.1.9** starts with the oldest available group for each item. Repeat Drag or Dump to distribute further groups.
- **2.2.0** adds **Spoiled first** (default) and **Fresh first** under **Advanced**. One Drag can work through up to three groups as space allows. Dump offers one group per item.

**Nutrients** can fill recipe inputs and fuel slots. In **2.2.0**, dragging Nutrients over a Biochamber that can use both opens **Where do you want the nutrients?** Choose **Input slot**, **Fuel slot**, **Both**, or **Cancel**. Dump can also fill a matching Bioflux recipe input and the Nutrients fuel slot in the same action.

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Firearm_magazine.png/32px-Firearm_magazine.png"> Ammo

Dump offers partly spent magazines first within each type. Drag and Dump protect a reserve of **100** for each equipped ammo item and quality, counting weapon slots, inventory, and cursor.

**2.2.0** adds a **Dump ammo** checkbox, enabled by default. Under **Advanced**, choose **Low tier ammo first** (default) or **High tier ammo first**. The order applies within each ammo family, including magazines, cannon shells, and rockets. Dump can refill compatible ammo slots from personally requested stock. Each action moves up to 100 of the matching equipped ammo from carried stock, subject to the reserve.

**Atomic bombs** can go to compatible turrets through Drag. Dump can send them to eligible chests.

<details>
<summary>Magazine progression · 2.2.0</summary>

Eight empty gun turrets with **Low tier ammo first** and a **0.1-stack** limit. The player starts with 80 yellow magazines and 120 red magazines in inventory, plus 20 red magazines equipped.

| Step | Turrets | Yellow in inventory | Red in inventory | Red equipped |
| --- | --- | ---: | ---: | ---: |
| Start | 8 empty | 80 | 120 | 20 |
| First Dump | 8 loaded with 10 yellow each | 0 | 120 | 20 |
| After firing | 4 empty, 4 still holding yellow | 0 | 120 | 20 |
| Second Dump | 4 loaded with 10 red each, 4 still holding yellow | 0 | 80 | 20 |

You finish with **100 red magazines** across inventory and equipped slots.

</details>

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Rocket_fuel.png/32px-Rocket_fuel.png"> Fuel

Dump refills boilers and other compatible burners, subject to the configured fuel limit. **2.2.0** adds **Low fuel value first** (default) and **High fuel value first** under **Advanced**. Fuel reserved by a personal logistic request can go directly into a compatible fuel slot.

### Quality

Drag supports all qualities. Dump handles Normal quality by default. **2.2.0** adds the opt-in **Dump higher-quality items (Beta)** setting. Hover over its **ⓘ** for details before distributing valuable items.

### <img width="28" alt="" src="https://wiki.factorio.com/images/thumb/Speed_module_3.png/32px-Speed_module_3.png"> Dragging modules

When a building in the Drag accepts the selected module as both a recipe ingredient and an installed module, the popup asks **Where do you want the modules?** Choose **Input slot**, **Module slot**, or **Cancel**.

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

- **Dump above the minimum personal logistic request** and **Drop items to machine outputs** are off by default.
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
