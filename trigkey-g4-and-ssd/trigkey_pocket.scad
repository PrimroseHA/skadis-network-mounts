// SKÅDIS pocket for TRIGKEY G4 (N100) mini PC
// Measured with calipers 1 Oct 2026: 115.9 W (port faces) x ~102 D x 44.4 H (incl. feet).
// Front face: 2 x USB-A, power plug, LED, power button. Vents low on both sides.
//
// Stands upright, base towards the board, logo facing out, FRONT PORTS FACING DOWN
// through an open floor (only 7 mm ledges at each end). Rear ports at the top, clear.
// Side walls and back plate are opened up so the side vents and the base can breathe.
// A sprung bump in the back plate pushes it forward onto the front lips: snug, no rattle.
// Hangs on 2 hook bars (skadis_hooks.scad), slid up from below.
//
// Print: upside down (open top on the bed), PETG, no supports.
// Axes: X = across the board, Y = up, Z = out from the board (board face z = 0).

include <skadis_hooks.scad>

part = "pocket";      // pocket | pocket_print | assembled

pc_w = 115.9;         // across the board (front/rear port faces are at the bottom/top)
pc_d = 102.5;         // vertical
pc_h = 44.4;          // out from the board, incl. rubber feet

clr_w  = 0.8;
clr_h  = 0.6;
bump   = 1.5;

wall    = 2.4;
back_t  = 5;
lip     = 8;
lip_t   = 2.4;
ledge   = 7;
floor_t = 2.4;
pk_h    = 80;          // pocket height; the PC stands ~25 mm proud of the top

in_x = pc_w + clr_w;            // 116.7
in_z = pc_h + clr_h;            // 45.0
out_x = in_x + 2*wall;
z1 = back_t;  z2 = z1 + in_z;  out_z = z2 + lip_t;
y0 = -pk_h/2;  y1 = pk_h/2;
bar_xs = [-40, 40];             // 80 mm apart = two SKÅDIS same-row steps

// sprung tab in the back plate, centre, root at the bottom
tab_w = 20;  tab_y0 = y0 + floor_t + 8;  tab_len = 48;  tab_g = 1.2;

module pocket_body() {
    difference() {
        translate([-out_x/2, y0, 0]) cube([out_x, pk_h, out_z]);
        // cavity
        translate([-in_x/2, y0 + floor_t, z1]) cube([in_x, pk_h, in_z]);
        // open front between lips
        translate([-in_x/2 + lip, y0 + floor_t, z2 - 1]) cube([in_x - 2*lip, pk_h, lip_t + 2]);
        // open floor between end ledges (front ports + plugs drop through)
        translate([-in_x/2 + ledge, y0 - 1, z1]) cube([in_x - 2*ledge, floor_t + 2, in_z + lip_t + 1]);
        // side-wall vent windows (PC's side vents sit near its base, i.e. near the board)
        for (s = [-1, 1])
            translate([s > 0 ? in_x/2 - 1 : -out_x/2 - 1, y0 + floor_t + 6, z1 + 1])
                cube([wall + 2, pk_h - floor_t - 12, in_z - 4]);
        // back-plate windows either side of the tab, clear of the hook-bar grooves
        for (s = [-1, 1])
            translate([s > 0 ? 14 : -32, y0 + floor_t + 6, -1]) cube([18, pk_h - floor_t - 12, back_t + 2]);
        // sprung tab: U-slot + thinned to 2 mm from behind
        translate([-tab_w/2 - tab_g, tab_y0, -1]) cube([tab_g, tab_len + tab_g, back_t + 2]);
        translate([tab_w/2, tab_y0, -1]) cube([tab_g, tab_len + tab_g, back_t + 2]);
        translate([-tab_w/2 - tab_g, tab_y0 + tab_len, -1]) cube([tab_w + 2*tab_g, tab_g, back_t + 2]);
        translate([-tab_w/2, tab_y0, -1]) cube([tab_w, tab_len, back_t - 2 + 1]);
        // hook-bar grooves
        for (x = bar_xs) translate([x, 0, 0]) bar_groove(y0);
    }
    // 45° bump near the tab's free end
    by = tab_y0 + tab_len - 8;
    translate([0, 0, z1]) hull() {
        translate([-tab_w/2 + 2, by - 4, -0.01]) cube([tab_w - 4, 8, 0.01]);
        translate([-tab_w/2 + 2, by - 0.5, bump - 0.01]) cube([tab_w - 4, 1, 0.01]);
    }
}

module assembled() {
    pocket_body();
    for (x = bar_xs) translate([x, 0, 0]) hook_bar();
    %translate([-pc_w/2, y0 + floor_t, z1 + clr_h/2]) cube([pc_w, pc_d, pc_h]);
}

if (part == "pocket") pocket_body();
if (part == "pocket_print") translate([0, 0, y1]) rotate([-90, 0, 0]) pocket_body();
if (part == "assembled") assembled();
