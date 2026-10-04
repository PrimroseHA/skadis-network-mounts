// SKÅDIS holders for the white mains extension lead (calipered 2 Oct 2026:
// 58.3 mm wide x 25.4 mm thick), mounted upright, sockets facing out.
//  - strip_base:  pocket with a floor; the lead's bottom end rests on it, 16 mm slot in
//                 the middle of the floor lets the mains cable out underneath.
//  - strip_sleeve: same section, no floor - stops the top tipping forward.
// 8 mm front lips only cover the lead's edges (sockets clear). No sprung tab (too
// fiddly to print) - 0.3 mm front-back clearance keeps it snug instead. Each hangs on 2 hook bars (+/-20 mm), slid up from below.
// Built from the same pocket() as the hub pockets. Print upside down, PETG, no supports.

include <skadis_hooks.scad>
use <hub_pockets.scad>

part = "base";   // base | sleeve | base_print | sleeve_print

sl_w = 58.3;  sl_t = 25.4;
ph   = 64;
cable_slot = 16;
ledge_base = ((sl_w + 0.8) - cable_slot) / 2;   // floor either side of the cable slot

// pocket(w, dv, t, ledge, ph, bx); dv only matters for wedges
module strip_base()   pocket(sl_w, 100, sl_t, ledge_base, ph, 20, tab = false, ct = 0.3);
// sleeve: ledge 0 = the whole floor is cut away
module strip_sleeve() pocket(sl_w, 100, sl_t, 0, ph, 20, tab = false, ct = 0.3);

if (part == "base")   strip_base();
if (part == "sleeve") strip_sleeve();
if (part == "base_print")   translate([0, 0, ph/2]) rotate([-90, 0, 0]) strip_base();
if (part == "sleeve_print") translate([0, 0, ph/2]) rotate([-90, 0, 0]) strip_sleeve();
