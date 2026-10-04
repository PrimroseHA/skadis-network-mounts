// SKÅDIS rack for 2 x UGREEN 2.5" USB-C 3.1 Gen 2 SSD enclosures
// (Amazon B0851B6TCC, model 80556): 134 L x 82 W x 16 H mm per the listing (rounded,
// so width has 1 mm play). A sprung bump in each slot grips 14.6-16.6 mm thick.
//
// Both drives stand upright, one in front of the other, faces parallel to the board.
// The rack holds the lower ~70 mm; the rest stands proud. Floor is two side ledges with
// the middle open, so a USB-C lead can come straight out the bottom (or fit port-up).
// Front of the front slot is open between 8 mm lips, so labels/LEDs show.
// Hangs on 2 hook bars (skadis_hooks.scad), slid up from below.
//
// Print: upside down (open top on the bed), PETG, no supports.
// Axes: X = across the board, Y = up, Z = out from the board (board face z = 0).

include <skadis_hooks.scad>

part = "rack";        // rack | rack_print | assembled

enc_w   = 82;         // enclosure width (across the board)
enc_t   = 16;         // listed thickness
enc_l   = 134;        // listed length (preview only)

clr_w   = 1.0;        // total clearance across the width (listing is rounded)
clr_t   = 0.6;        // total clearance on thickness (bump takes up the rest)
bump    = 2.0;        // spring bump height

wall    = 2.4;
back_t  = 5;          // back plate (hook-bar grooves 3 deep)
div_t   = 2.4;        // divider between the slots
lip     = 8;
lip_t   = 2.4;
ledge   = 8;          // floor ledge width each side
floor_t = 2.4;
rack_h  = 72;         // height of the rack body

slot_w  = enc_w + clr_w;          // 82.6
slot_t  = enc_t + clr_t;          // 15.6
out_w   = slot_w + 2*wall;        // 87.4
z1      = back_t;                 // rear slot front face of back plate
z2      = z1 + slot_t;            // divider back face
z3      = z2 + div_t;             // front slot starts
z4      = z3 + slot_t;            // front slot ends (lips)
out_z   = z4 + lip_t;

y0 = -rack_h/2;  y1 = rack_h/2;
bar_xs = [-20, 20];

// sprung tab: U-slot cut, tab root at the bottom, free end up, 45° bump near the top
tab_w = 24;  tab_y0 = y0 + floor_t + 6;  tab_len = 44;  tab_g = 1.2;
module tab_cut(z_a, z_b) {          // cut through a wall spanning z_a..z_b
    translate([-tab_w/2 - tab_g, tab_y0, z_a - 1]) cube([tab_g, tab_len + tab_g, z_b - z_a + 2]);
    translate([tab_w/2, tab_y0, z_a - 1]) cube([tab_g, tab_len + tab_g, z_b - z_a + 2]);
    translate([-tab_w/2 - tab_g, tab_y0 + tab_len, z_a - 1]) cube([tab_w + 2*tab_g, tab_g, z_b - z_a + 2]);
}
module tab_bump(z_face) {           // wedge on a front face at z_face, pointing +Z
    by = tab_y0 + tab_len - 8;
    translate([0, 0, z_face]) hull() {
        translate([-tab_w/2 + 2, by - 4, -0.01]) cube([tab_w - 4, 8, 0.01]);
        translate([-tab_w/2 + 2, by - 0.5, bump - 0.01]) cube([tab_w - 4, 1, 0.01]);
    }
}

module rack_body() {
    difference() {
        translate([-out_w/2, y0, 0]) cube([out_w, rack_h, out_z]);
        // rear slot, front slot
        translate([-slot_w/2, y0 + floor_t, z1]) cube([slot_w, rack_h, slot_t]);
        translate([-slot_w/2, y0 + floor_t, z3]) cube([slot_w, rack_h, slot_t]);
        // open front between the lips
        translate([-slot_w/2 + lip, y0 + floor_t, z4 - 1]) cube([slot_w - 2*lip, rack_h, lip_t + 2]);
        // open floor between the ledges (both slots, through the divider's foot too)
        translate([-slot_w/2 + ledge, y0 - 1, z1]) cube([slot_w - 2*ledge, floor_t + 2, z4 - z1]);
        // sprung tabs: back plate (thinned to 2 mm from behind) and divider
        tab_cut(0, back_t);
        translate([-tab_w/2, tab_y0, -1]) cube([tab_w, tab_len, back_t - 2 + 1]);
        tab_cut(z2, z3);
        // hook-bar grooves
        for (x = bar_xs) translate([x, 0, 0]) bar_groove(y0);
    }
    tab_bump(z1);
    tab_bump(z3);
}

module assembled() {
    rack_body();
    for (x = bar_xs) translate([x, 0, 0]) hook_bar();
    %for (z = [z1 + clr_t/2, z3 + clr_t/2])
        translate([-enc_w/2, y0 + floor_t, z]) cube([enc_w, enc_l, enc_t - bump + clr_t/2]);
}

if (part == "rack") rack_body();
if (part == "rack_print") translate([0, 0, y1]) rotate([-90, 0, 0]) rack_body();
if (part == "assembled") assembled();
