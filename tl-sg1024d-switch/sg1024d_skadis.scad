// SKÅDIS mount for TP-Link TL-SG1024D 24-port switch (294 W x 180 D x 44 H mm)
// using its own 19" rack brackets.
//
// The switch hangs flat on the board: base towards the board, ports facing DOWN,
// power socket at the top. The metal 19" brackets stay on the switch as TP-Link
// intended; their flanges stick out sideways at the port edge.
//  - 2 x rack shelf: each flange rests on a printed shelf and is bolted through
//    the standard rack holes (M6 x 20 + M6 nut, nut sits in a slot under the shelf).
//  - 2 x side clip: grip the switch sides near the top, lip over the front edge,
//    so the top can't tip away from the board.
//  - 6 x hook bar (skadis_hooks.scad): 2 per shelf, 1 per clip, slid up from below.
//
// Layout on the board: switch centre sits on a SKÅDIS column. Shelf columns at
// +/-220 and +/-260 mm, clip columns at +/-160 mm (all whole 20 mm steps).
// Rack holes are the EIA-310 standard: 465.1 mm apart (232.55 each side of centre),
// 31.75 mm apart within the 1U flange (6.35 mm and 38.1 mm from its edge).
// CHECKED against the real brackets 1 Oct 2026: 48.3 cm tip to tip, two oval slots across
// the 44 mm flange ~1 cm from the tip, ~30-32 mm apart (inside the +/-2.5 mm bolt slots).
// Switch has no rubber feet fitted. Clip walls left solid (no vent windows, easier print).
// Bolt holes are slotted +/-2.5 mm towards/away from the board for bracket variation.
//
// Axes: X = across (0 = switch centre), Y = up (0 = top of shelf = underside of the
// bracket flanges), Z = out from the board (board face z = 0).

include <skadis_hooks.scad>

part = "assembled";   // assembled | shelf_r | shelf_l | clip_r | clip_l | bar

// --- switch ---
sw_w   = 294;
sw_d   = 180;
sw_h   = 44;
sw_gap = 5;        // switch base stands 5 mm off the board (rubber feet up to ~5 mm OK)

// --- rack brackets ---
rack_x    = 465.1 / 2;              // hole centre from switch centre
rack_z    = [6.35, 38.1];           // hole centres from the flange edge nearest the board
flange_t  = 1.5;                    // only used for the assembled preview
rack_ear  = 482.6 / 2;              // flange tip from switch centre
bolt_d    = 6.8;                    // M6 clearance
bolt_slot = 2.5;                    // +/- slot towards/away from the board
nut_af    = 10.2;                   // M6 nut 10 mm across flats + clearance
nut_h     = 5.5;

back_t  = 5;                        // back plate thickness

// --- shelf (right-hand; left is a mirror) ---
sh_cols = [220, 260];
sh_x0 = 205;  sh_x1 = 275;          // back plate
sh_top_x1 = 250;                    // shelf runs past the flange tip (241.3)
sh_t  = 10;                         // shelf thickness
sh_dz = sw_gap + 44.45 + 3;         // shelf depth out from the board
sh_h  = 64;                         // back plate height, hanging below the shelf
sh_rc = -sh_h/2;                    // bar centre

module shelf_body() {
    // back plate
    translate([sh_x0, -sh_h, 0]) cube([sh_x1 - sh_x0, sh_h, back_t]);
    difference() {
        union() {
            translate([sh_x0, -sh_t, 0]) cube([sh_top_x1 - sh_x0, sh_t, sh_dz]);
            // gussets under the shelf
            for (gx = [sh_x0, sh_top_x1 - 5])
                hull() {
                    translate([gx, -sh_h + 4, 0]) cube([5, 0.01, back_t]);
                    translate([gx, -sh_t - 0.01, 0]) cube([5, 0.01, sh_dz]);
                }
        }
        for (z = rack_z) {
            zc = sw_gap + z;
            // bolt slot
            hull() for (dz = [-bolt_slot, bolt_slot])
                translate([rack_x, 1, zc + dz]) rotate([90, 0, 0]) cylinder(d = bolt_d, h = sh_t + 2);
            // nut slot from underneath (flats across X so the nut can't turn)
            hull() for (dz = [-bolt_slot, bolt_slot])
                translate([rack_x, -sh_t - 1, zc + dz]) rotate([-90, 0, 0]) rotate([0, 0, 30])
                    cylinder(r = nut_af / sqrt(3), h = nut_h + 1, $fn = 6);
        }
    }
}
module shelf(side = 1) {   // side = 1 right, -1 left
    difference() {
        if (side > 0) shelf_body(); else mirror([1, 0, 0]) shelf_body();
        for (x = sh_cols) translate([side * x, sh_rc, 0]) bar_groove();
    }
}

// --- side clip (right-hand; left is a mirror) ---
cl_col  = 160;
cl_in   = sw_w/2 + 0.3;     // inner face, 0.3 mm clear of the switch side
cl_wall = 4;
cl_lip  = 8;                // over the switch's front edge
cl_lt   = 3;
cl_x1   = 172;
cl_h    = 64;
cl_z0   = sw_gap + sw_h + 0.6;   // lip underside

// The switch's sides are vented except the rear (top) 20 mm. Hook rows sit on the 40 mm
// grid, and with the shelves on their columns the clip centre lands at y = 148: the side
// wall + lip then run y 162..180, i.e. 18 mm of grip inside the vent-free strip
// (switch top edge at 181.5), leaving the vents open. Below that the clip is just the
// back plate carrying the hook bar, out to the side of the switch.
cl_wy0 = 14;            // wall + lip from here (clip-local) ...
cl_wy1 = cl_h/2;        // ... to the clip's top end
module clip_body() {
    translate([cl_in, -cl_h/2, 0]) cube([cl_x1 - cl_in, cl_h, back_t]);
    translate([cl_in, cl_wy0, 0]) cube([cl_wall, cl_wy1 - cl_wy0, cl_z0 + cl_lt]);
    translate([cl_in + cl_wall - cl_lip - cl_wall, cl_wy0, cl_z0])
        cube([cl_lip + cl_wall, cl_wy1 - cl_wy0, cl_lt]);
}
module clip(side = 1) {
    difference() {
        if (side > 0) clip_body(); else mirror([1, 0, 0]) clip_body();
        translate([side * cl_col, 0, 0]) bar_groove();
    }
}

// --- preview of the whole thing ---
clip_y = 148;   // the one grid position that grips only the vent-free rear 20 mm
module switch_ghost() {
    color("dimgray") translate([-sw_w/2, flange_t, sw_gap]) cube([sw_w, sw_d, sw_h]);
    color("silver") for (s = [-1, 1]) {
        // flange in the front-panel plane, side leg along the switch side
        translate([s > 0 ? sw_w/2 : -rack_ear, 0, sw_gap]) cube([rack_ear - sw_w/2, flange_t, 44.45]);
        translate([s > 0 ? sw_w/2 : -sw_w/2 - flange_t, 0, sw_gap]) cube([flange_t, 30, sw_h]);
    }
}
module assembled() {
    for (s = [-1, 1]) {
        shelf(s);
        for (x = sh_cols) translate([s * x, sh_rc, 0]) hook_bar();
        translate([0, clip_y, 0]) { clip(s); translate([s * cl_col, 0, 0]) hook_bar(); }
    }
    %switch_ghost();
}

// --- print poses ---
// shelf: upside down, shelf top on the bed; clip: standing on its top end; bar: flat side down
if (part == "assembled") assembled();
if (part == "shelf_r") rotate([-90, 0, 0]) shelf(1);
if (part == "shelf_l") rotate([-90, 0, 0]) shelf(-1);
// clips print standing on their TOP end so the short wall grows straight up from the bed
if (part == "clip_r")  translate([0, 0, cl_h/2]) rotate([-90, 0, 0]) clip(1);
if (part == "clip_l")  translate([0, 0, cl_h/2]) rotate([-90, 0, 0]) clip(-1);
if (part == "bar")     hook_bar_print();
