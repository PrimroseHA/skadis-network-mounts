# SKÅDIS network & smart-home mounts

3D-printable mounts that hang home-network kit on an IKEA SKÅDIS pegboard. Every holder uses the same **drop-lock hooks on slide-in dovetail bars** (`skadis_hooks.scad`). You print the bars separately, slide them up into grooves in the part, and they lock into the board's 5 × 15 mm slots.

All parts are parametric OpenSCAD with ready-to-print STLs and full-plate 3MFs alongside. They were designed for **PETG at 0.2 mm, 4 walls, 25% gyroid**, and most print with no supports (each `.scad` header gives the print orientation).

| Folder | What it holds | Notes |
|---|---|---|
| `poe380s-injector/` | TP-Link Omada POE380S PoE++ injector (155 × 70 × 42) | Portrait pocket, plugs exit underneath. `skadis_fit_check.scad` is the hook-fit test rig |
| `tl-sg1024d-switch/` | TP-Link TL-SG1024D 24-port switch | Uses the switch's own 19" brackets on 2 printed shelves (4 × M6×16 bolts + nuts) plus 2 side clips. `board_fixings.scad` = wall spacers and caps for the board itself |
| `smart-home-hubs/` | Heatmiser neoHub v2, SmartThings Hub v3, Lightwave Link Plus L2 | Measured dimensions in the `.scad` header |
| `trigkey-g4-and-ssd/` | TRIGKEY G4 (N100) mini PC + 2 × 2.5" SSD enclosures | Pocket stands upright with ports down; sprung-bump grip |
| `ugreen-ssd-rack/` | 2 × UGREEN USB-C 2.5" enclosures (model 80556) | Sprung bumps grip 14.6–16.6 mm thick |
| `zigbee-dongle-and-power-strip/` | Sonoff ZBDongle-E clip + upright mains extension-lead holders | Lead holders sized for a 58.3 × 25.4 mm strip |
| `combined-plates/` | Mixed full-bed plates of the above | |

## Customising

Open the `.scad` file in [OpenSCAD](https://openscad.org) and change the device dimensions at the top (most have a clearance variable too). Each folder carries its own copy of `skadis_hooks.scad`, so a folder works on its own.

When you design a new part, pass its bottom edge to `bar_groove()` so the groove runs right out through the bottom. If you don't, the hook bars can't slide in.

## Licence

[CC BY-NC-SA 4.0](LICENSE): you're free to print, remix and share these for non-commercial use, with attribution, under the same licence.
