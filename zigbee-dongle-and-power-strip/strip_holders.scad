// SKÅDIS holders for the white 6-way mains extension lead, mounted upright, sockets out.
// Calipered: 58.3 mm wide x 25.4 mm thick. Plug bodies and chargers overhang BOTH sides of
// the lead, so nothing may sit in front of its face anywhere along the sockets (v1's
// 64 mm pocket + sleeve covered socket 1 and socket 6). v2 holds the two plain ends only:
//  - strip_foot: shallow cup for the bottom (switch / neon) end. Floor + 20 mm cable slot
//    open to the front, front lips only 6 mm tall (plug 6 starts ~10 mm from the end); above
//    that the side walls stop 3.4 mm short of the face so overhanging plugs clear them.
//  - strip_hood: cap over the top (surge-label) end, roof + side lips 18 mm deep (plug 1
//    starts ~30 mm down). The back half of each side wall is cut away so the round tab on
//    the side of the head (about 4-12 mm down) passes through. It
//    RIDES on its two hook bars: the grooves are 70 mm longer than a fixed part's, so it
//    drops onto the lead's top end whatever the lead's length. Hook its bars in the pair
//    of rows that puts the bar centre 45-85 mm below the lead's top end (bar centre =
//    midway between the bar's two hooks). Lift the hood up to 12 mm more to fit the lead.
// Fit the lead: hook all 4 bars, slide the hood on from above, lift it, feed the top of
// the lead up into the hood, swing the bottom in over the foot's lips, lower it into
// the foot and the hood drops back onto it.
// PETG, no supports. Foot prints floor down, hood prints roof down.
// Axes: X = across the board, Y = up, Z = out from the board (board face z = 0).

include <skadis_hooks.scad>

part = "assembled";   // assembled | foot | hood | foot_print | hood_print | plate

sl_w = 58.3;  sl_t = 25.4;
clr_w = 0.8;  clr_t = 0.6;
wall = 2.4;  back_t = 5;  lip = 8;  lip_t = 2.4;  floor_t = 2.4;
bx = 20;                         // bar columns at +/-20 (one SKÅDIS row pair)

in_x  = sl_w + clr_w;
out_x = in_x + 2*wall;
face  = back_t + sl_t + clr_t;   // inside of the lips
front = face + lip_t;            // outside of the lips
low_z = back_t + sl_t - 3.4;     // side walls stop here where plugs can overhang

// ---------- foot ----------
cup_h   = 30;                    // side walls above the floor
cup_lip = 6;                     // lip height above the floor (plug 6 starts ~10 mm up)
slot_w  = 20;
foot_y0 = bar_y0;                // floor underside = bottom of the bar groove run-out
foot_yd = foot_y0 + floor_t;     // lead's bottom end rests here
foot_y1 = bar_y1 + 2;            // back plate top (covers the bar)

module foot() difference() {
    union() {
        translate([-out_x/2, foot_y0, 0]) cube([out_x, foot_y1 - foot_y0, back_t]);
        translate([-out_x/2, foot_y0, 0]) cube([out_x, floor_t, front]);                  // floor
        for (s = [-1, 1]) translate([s > 0 ? in_x/2 : -out_x/2, foot_y0, 0]) {
            cube([wall, floor_t + cup_h, low_z]);                                      // side wall
            cube([wall, floor_t + cup_lip, front]);                                    // lip post
        }
        for (s = [-1, 1]) translate([s > 0 ? in_x/2 - lip : -in_x/2, foot_y0, face])
            cube([lip, floor_t + cup_lip, lip_t]);                                     // front lip
    }
    translate([-slot_w/2, foot_y0 - 1, back_t]) cube([slot_w, floor_t + 2, front]);    // cable slot
    for (x = [-bx, bx]) translate([x, 0, 0]) bar_groove(foot_y0);
}

// ---------- hood ----------
// hood origin: y = 0 is the lead's top end (underside of the roof)
hood_d   = 18;                   // lips/walls reach this far down over the head
roof_t   = 2.4;
D_min    = 45;  D_max = 85;      // bar centre below the lead's top end (fitted range)
lift     = 12;                   // extra travel to get the lead in (clears the 6 mm foot lips)
tab_relief = 12;                 // side walls open from the back plate out to here
spine_w  = 2*bx + hook_w + 2*dv_flare + 8;
spine_y0 = -(D_max + lift) + bar_y0 - 2;

module hood() difference() {
    union() {
        translate([-out_x/2, -hood_d, 0]) cube([out_x, hood_d + roof_t, front]);       // box
        translate([-spine_w/2, spine_y0, 0]) cube([spine_w, -spine_y0, back_t]);       // spine
    }
    translate([-in_x/2, -hood_d - 1, back_t]) cube([in_x, hood_d + 1, sl_t + clr_t]);  // cavity
    translate([-in_x/2 + lip, -hood_d - 1, back_t]) cube([in_x - 2*lip, hood_d + 1, front]);
    for (x = [-bx, bx]) translate([x, 0, 0])
        bar_body(dv_clr, spine_y0 - 1, -D_min + bar_y1 + dv_clr);
    // side-wall relief for the head's round tab: back 12 mm of each wall, full hood depth
    translate([-out_x/2 - 1, -hood_d - 1, back_t]) cube([out_x + 2, hood_d + 1, tab_relief]);
}

// ---------- views / print poses ----------
L_demo = 380;   // only for the assembled preview; the parts don't depend on it
module lead() %translate([-sl_w/2, foot_yd, back_t]) cube([sl_w, L_demo, sl_t]);

if (part == "assembled") {
    foot();  for (x = [-bx, bx]) translate([x, 0, 0]) hook_bar();
    lead();
    D = 60;  translate([0, foot_yd + L_demo, 0]) hood();
    for (x = [-bx, bx]) translate([x, foot_yd + L_demo - D, 0]) hook_bar();
}
if (part == "foot") foot();
if (part == "hood") hood();
// floor down: y -> z
module foot_pose() rotate([90, 0, 0]) translate([0, -foot_y0, 0]) foot();
// roof down: -y -> z
module hood_pose() rotate([-90, 0, 0]) translate([0, -roof_t, 0]) hood();
if (part == "foot_print") foot_pose();
if (part == "hood_print") hood_pose();
if (part == "plate") { translate([-40, 0, 0]) foot_pose(); translate([40, 0, 0]) hood_pose(); }
