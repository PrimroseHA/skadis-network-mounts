// Shared SKÅDIS drop-lock hooks on slide-in dovetail bars.
// Proven on the POE380S pocket test frame (fit "perfect"), then stems made 8 mm tall.
//
// SKÅDIS: obround slots 5 x 15 mm (2.5 mm radius ends), board ~5 mm, ~20 mm off the wall.
// Columns 20 mm apart, alternate columns offset 20 mm: slots in one row repeat every
// 40 mm, and one column repeats every 40 mm vertically.
// Hook = drop-lock J: offer it up 4-7 mm above its seat, push straight in, let it drop.
// The tab face ramps from a loose lead-in to a 4.95 mm grip, so weight pulls the part
// tight to the board.
//
// Axes: X = across the board, Y = up the board, Z = out from the board (board face z = 0).

$fn = 32;

hook_w   = 4.6;
stem_h   = 8;
gap_grip = 4.95;
gap_lead = 5.6;
tab_t    = 4;
tab_len  = 12;

dv_d     = 3;      // dovetail depth into the part's back plate
dv_flare = 1.6;    // undercut on one side only, so the bar's other side prints flat
dv_clr   = 0.15;   // clearance per side

// one bar = one column, two hooks 40 mm apart; origin = column centre, midway between rows
bar_rows = [20, -20];
bar_y0   = -32;                 // bar bottom (open end of the groove)
bar_y1   = 20 + stem_h/2 + 2;   // bar top = groove stop

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

module dovetail2d(c) {   // x across, y = depth into the back plate
    o = c > 0 ? 1 : 0;   // groove: run 1 mm out through the back face
    polygon([[-hook_w/2 - c, -o], [hook_w/2 + c, -o], [hook_w/2 + c, 0],
             [hook_w/2 + dv_flare + c, dv_d + c], [-hook_w/2 - c, dv_d + c]]);
}
module bar_body(c, y0, y1) translate([0, y1, 0]) rotate([90, 0, 0])
    linear_extrude(y1 - y0) dovetail2d(c);

module hook_bar() {
    bar_body(0, bar_y0, bar_y1);
    for (y = bar_rows) translate([0, y - stem_h/2, 0]) hook();
}
// cut this from a part's back plate (back face at z = 0); bar slides in from below.
// part_bottom = the part's bottom edge relative to the bar centre: the groove MUST run
// out through it, or the bar can't get in.
module bar_groove(part_bottom = bar_y0) bar_body(dv_clr, min(part_bottom, bar_y0) - 1, bar_y1 + dv_clr);

// print pose: flat side down
module hook_bar_print() translate([0, 0, hook_w/2]) rotate([0, -90, 0]) hook_bar();
