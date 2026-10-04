// SKÅDIS holder for TP-Link Omada POE380S PoE++ injector
// Injector: 155 L x 70 x 42 mm (datasheet). Ports + LEDs on one end, AC socket on the other.
// Logo faces out. Four drop-lock hooks.
//
// orient = "landscape": injector lies along the board, slides in from either open end.
//   Print standing on an open end (hooks flush to the bed), supports on build plate only
//   (only the two hooks at the top end need them).
// orient = "portrait" (default): a pocket. The injector drops in from the open top and
//   sits on a floor frame, open in the middle so the plugs on the lower end come straight
//   out underneath; the spring tab holds it snug. print_ready = true lays it upside down
//   (open top on the bed) so the hook tabs grow up from their stems: no supports, just
//   one 70 mm bridge for the front strip of the floor.
// PETG, 0.2 mm, 4 walls, 25% gyroid.
//
// Axes: Y = up the board, Z = out from the board, X = across the board.
// The channel is modelled along X and turned upright for portrait.

orient = "portrait";    // "portrait" | "landscape"
print_ready = false;    // portrait only: flip upside down for printing

$fn = 32;

// --- injector ---
dev_d   = 70;      // vertical on the board
dev_h   = 42;      // depth out from the board
clr     = 0.6;     // total clearance on each cross-section dimension

// --- holder ---
len     = 124.6;   // hooks at both ends, 120 mm apart (3 x 40 mm SKÅDIS pitch)
wall    = 2.4;
back    = 5;      // 5 mm leaves ~1.8 mm behind the hook-bar dovetail grooves
lip     = 6;       // front retaining lip, top and bottom
lip_t   = 2.4;

in_y = dev_d + clr;            // 70.6
in_z = dev_h + clr;            // 42.6
out_y = in_y + 2*wall;         // 75.4
z_lip0 = back + in_z;          // front face of injector

// --- SKÅDIS: obround slots 5 x 15 mm (2.5 mm radius ends), board ~5 mm,
// columns 20 mm apart with alternate columns offset 20 mm, so slots in one
// row repeat every 40 mm and one column repeats every 40 mm vertically.
// Hook = drop-lock J: push the J straight in near the top of the slot, then
// let it drop 10 mm. The tab hangs down behind the board, below the slot.
// The board's slot edge meets the tab tip first as it drops, so the tab face
// ramps from a loose lead-in at the tip to a snug grip where the slot edge
// ends up: weight pulls the back plate tight to the board. A slightly thicker
// board just stops the drop a fraction early; it still locks.
hook_w   = 4.6;    // across the slot (slot is 5 wide)
stem_h   = 8;      // stem is a 4.6 x 8 pill, seats in the slot's round end
                   // (5 mm in the fit test; 8 mm after it, for ~2.5x bending strength)
gap_grip = 4.95;   // back plate -> tab face at the slot edge when seated (board 5.0)
gap_lead = 5.6;    // back plate -> tab face at the tab tip (lead-in)
tab_t    = 4;      // tab thickness behind the board (wall gap ~20 mm)
tab_len  = 12;     // from stem top down: 4 mm below the slot when seated,
                   // and stem + tab only 12 mm tall to pass a 15 mm slot
hook_y   = 20;     // stem centres at +/-hook_y: two slots 40 mm apart in one column

module c_channel() {
    difference() {
        translate([0, -out_y/2, 0]) cube([len, out_y, z_lip0 + lip_t]);
        // device cavity
        translate([-1, -in_y/2, back]) cube([len + 2, in_y, in_z]);
        // open front between the lips
        translate([-1, -in_y/2 + lip, back]) cube([len + 2, in_y - 2*lip, in_z + lip_t + 1]);
        vents();
        spring_cut();
    }
    spring_bump();
}

// vertical vent slots through top and bottom walls (vertical in print = clean)
// bottom wall skips the spring tab
module vents() {
    for (z = [back + 6 : 7 : z_lip0 - 5]) {
        translate([16, in_y/2 - 1, z]) cube([len - 32, wall + 2, 3.2]);
        for (r = [[16, spr_x0 - 5], [spr_x0 + spr_len + 6, len - 16]])
            translate([r[0], -out_y/2 - 1, z]) cube([r[1] - r[0], wall + 2, 3.2]);
    }
}

// sprung tab in the bottom wall pushes the injector up against the top wall
spr_x0 = len/2 - 18;  spr_len = 32;
spr_z0 = back + 11;   spr_wid = 18;
module spring_cut() {
    g = 1.2;
    translate([0, -out_y/2 - 1, 0]) {
        // two long sides + far end, root left attached at spr_x0
        translate([spr_x0, 0, spr_z0 - g]) cube([spr_len + g, wall + 2, g]);
        translate([spr_x0, 0, spr_z0 + spr_wid]) cube([spr_len + g, wall + 2, g]);
        translate([spr_x0 + spr_len, 0, spr_z0 - g]) cube([g, wall + 2, spr_wid + 2*g]);
    }
}
module spring_bump() {
    // 45° wedge, 1.2 mm proud, near the free end
    bx = spr_x0 + spr_len - 6;
    translate([0, -in_y/2, spr_z0 + 1])
        hull() {
            translate([bx - 3, -0.01, 0]) cube([6, 0.01, spr_wid - 2]);
            translate([bx - 0.5, 1.2, 0]) cube([1, 0.01, spr_wid - 2]);
        }
}

// 2D pill, x = across slot, y = up the slot, origin at the bottom of the pill
module pill(h) {
    r = hook_w/2;
    hull() { translate([0, r]) circle(r); translate([0, h - r]) circle(r); }
}

module hook() {   // on the back face (z <= 0), origin = stem bottom
    r = hook_w/2;
    translate([0, 0, -gap_grip]) linear_extrude(gap_grip + 0.01) pill(stem_h);
    hull() {
        translate([0, stem_h - r, -gap_grip - tab_t]) cylinder(r = r, h = tab_t);
        translate([-r, 0, -gap_grip - tab_t]) cube([hook_w, 0.01, tab_t]);
        translate([0, stem_h - tab_len + r, -gap_lead - tab_t]) cylinder(r = r, h = tab_t);
    }
}
// stem centres. Same-row slots repeat every 40 mm, a column every 40 mm.
// landscape: columns 120 mm apart at the holder ends, rows 40 mm apart
// portrait:  columns 40 mm apart, rows 80 mm apart
mount_pts = orient == "portrait"
    ? [for (x = [-20, 20], y = [40, -40]) [x, y]]
    : [for (x = [hook_w/2, len - hook_w/2], y = [hook_y, -hook_y]) [x, y]];

module mounts() {
    for (p = mount_pts) translate([p[0], p[1] - stem_h/2, 0]) hook();
}

// portrait: floor frame at the bottom end, window clear of the RJ45s / LEDs / AC plug
floor_side  = 4;   // across the 70 mm face
floor_frbk  = 8;   // back and front strips
module portrait_floor() {
    y0 = -len/2;
    difference() {
        translate([-out_y/2, y0, 0]) cube([out_y, wall, z_lip0 + lip_t]);
        translate([-in_y/2 + floor_side, y0 - 1, back + floor_frbk])
            cube([in_y - 2*floor_side, wall + 2, in_z - 2*floor_frbk]);
    }
}

// --- portrait: hooks on two separate bars that slide up dovetail grooves in the back ---
// Each bar carries one column's two hooks and prints lying on its flat side, so the
// hooks need no supports and their layers run along the hook outline. The bar slides
// in from the bottom of the pocket up to a stop; the load on the hooks pushes the
// bar against the stop. A drop of glue is optional.
dv_d     = 3;      // dovetail depth into the back plate
dv_flare = 1.6;    // undercut on one side only, so the bar's other side prints flat
dv_clr   = 0.15;   // clearance per side
bar_xs   = [-20, 20];
bar_top  = 40 + stem_h/2 + 2;   // groove stop, 2 mm above the upper stem
bar_bot  = -len/2;              // flush with the bottom of the pocket

module dovetail2d(c) {   // x across, y = depth into the back plate
    o = c > 0 ? 1 : 0;   // groove: run 1 mm out through the back face
    polygon([[-hook_w/2 - c, -o], [hook_w/2 + c, -o], [hook_w/2 + c, 0],
             [hook_w/2 + dv_flare + c, dv_d + c], [-hook_w/2 - c, dv_d + c]]);
}
module bar_body(c, y0, y1) translate([0, y1, 0]) rotate([90, 0, 0])
    linear_extrude(y1 - y0) dovetail2d(c);

module hook_bar() {      // one column, origin at its stem centreline
    bar_body(0, bar_bot, bar_top);
    for (y = [40, -40]) translate([0, y - stem_h/2, 0]) hook();
}

module holder() {
    if (orient == "portrait") {
        difference() {
            union() {
                translate([0, -len/2, 0]) rotate([0, 0, 90]) c_channel();
                portrait_floor();
            }
            for (x = bar_xs) translate([x, 0, 0])
                bar_body(dv_clr, bar_bot - 1, bar_top + dv_clr);
        }
    } else { c_channel(); mounts(); }
}
module assembled() { holder(); if (orient == "portrait") for (x = bar_xs) translate([x, 0, 0]) hook_bar(); }

// sizing test: a thin open frame carrying the same four hooks. Plate thickness doesn't
// change the fit, because the hooks are measured from the plate's back face.
test_t   = 2;    // frame thickness
test_bar = 10;   // frame bar width
module test_strip() {
    xs = [for (p = mount_pts) p[0]];  ys = [for (p = mount_pts) p[1]];
    x0 = min(xs) - 7;  x1 = max(xs) + 7;  y0 = min(ys) - 7;  y1 = max(ys) + 7;
    difference() {
        translate([x0, y0, 0]) cube([x1 - x0, y1 - y0, test_t]);
        translate([x0 + test_bar, y0 + test_bar, -1])
            cube([x1 - x0 - 2*test_bar, y1 - y0 - 2*test_bar, test_t + 2]);
    }
    mounts();
}

// part = "holder" for the real thing, "test" for a quick back-plate strip with the
// same four hooks to check the board fit before printing the whole holder
part = "holder";
module place(top) {   // top = highest Y of the part, lands on the bed
    if (print_ready && orient == "portrait")
        translate([0, 0, top]) rotate([-90, 0, 0]) children();
    else children();
}
if (part == "holder") place(len/2) holder();
// print 2 of these, flat side down
if (part == "bar") translate([0, 0, hook_w/2]) rotate([0, -90, 0]) hook_bar();
if (part == "assembled") assembled();
if (part == "test") place(max([for (p = mount_pts) p[1]]) + 7) test_strip();
