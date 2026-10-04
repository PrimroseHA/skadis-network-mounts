// SKÅDIS pockets for the three smart-home hubs
//  - Heatmiser neoHub Version 2 (HA device info), MEASURED 1 Oct 2026: ~171 long (tape),
//    91.6 front-back, 27.2 thick (datasheet said 25.5 - too thin!). Black, rounded ends;
//    mini-USB power + Ethernet mid-way along the rear long edge, LEDs + button on top.
//  - Lightwave Link Plus L2 (HA integration lightwave_smart), older WEDGE shell,
//    calipered 1 Oct 2026: 114.7 long, ~113 wide across the top (base 95.5-99), flat base
//    with keyholes, top slopes from 36.6 thick to 26.3 thin. Hung thick end DOWN (assumed
//    to be the socket end) so the leads drop out; front lips follow the slope.
//  - SmartThings Hub V3 (V3_HUB), MEASURED 1 Oct 2026: 127.1 x 126.6 (squircle, pillow top);
//    DC (~22 mm in from the left), reset, USB, Ethernet along one edge. 29.5 thick near the
//    edge (datasheet said 31), so the pillow top is gentle and the lips grip the edge.
//
// Every hub: base towards the board, top face out, PORT EDGE DOWN through an open floor
// (ledges only at the two ends), front lips, sprung bump in the back plate for a snug,
// rattle-free fit. Hangs on 2 hook bars (skadis_hooks.scad), slid up from below.
// Print: upside down (open top on the bed), PETG, no supports.
// Axes: X = across the board, Y = up, Z = out from the board (board face z = 0).

include <skadis_hooks.scad>

part = "all";   // all | neohub | linkplus | smartthings | *_print

// thick = one number, or [thickness at the bottom end, thickness at the top end] for a wedge
//            name           across  vertical thick          ledge  pocket_h  bar_x
hubs = [ ["neohub",       172,    91.6,   27.2,          12,    64,       60],
         ["linkplus",     113,   114.7,   [36.6, 26.3],  14,    76,       40],
         ["smartthings",  127.1, 126.6,   29.5,          12,    82,       40] ];

clr_w = 0.8;  clr_t = 0.6;  bump = 1.5;
wall = 2.4;  back_t = 5;  lip = 8;  lip_t = 2.4;  floor_t = 2.4;

// a box from y = ya to yb whose depth (z from z0) runs linearly from da at ya to db at yb
module ramp_box(x0, w, ya, yb, z0, da, db) hull() {
    translate([x0, ya, z0]) cube([w, 0.01, da]);
    translate([x0, yb - 0.01, z0]) cube([w, 0.01, db]);
}
module pocket(w, dv, t, ledge, ph, bx, tab = true, ct = clr_t) {
    tb = is_list(t) ? t[0] : t;   // device thickness at its bottom end
    tt = is_list(t) ? t[1] : t;   // ... at its top end
    in_x = w + clr_w;  out_x = in_x + 2*wall;
    z1 = back_t;
    y0 = -ph/2;  y1 = ph/2;  yd = y0 + floor_t;           // device rests at yd
    inz = function(y) ct + tb + (tt - tb) * (y - yd) / dv;   // cavity depth at height y
    tab_w = 20;  tab_y0 = y0 + floor_t + 6;  tab_len = min(44, ph - floor_t - 16);  g = 1.2;
    difference() {
        // outer shell: depth follows the device, plus back plate and lip
        ramp_box(-out_x/2, out_x, y0, y1, 0, z1 + inz(y0) + lip_t, z1 + inz(y1) + lip_t);
        // cavity
        ramp_box(-in_x/2, in_x, yd, y1 + 1, z1, inz(yd), inz(y1 + 1));
        // open front between the lips (cut generously beyond the sloped lip)
        ramp_box(-in_x/2 + lip, in_x - 2*lip, yd, y1 + 1, z1, inz(yd) + lip_t + 1, inz(y1 + 1) + lip_t + 1);
        translate([-in_x/2 + ledge, y0 - 1, z1]) cube([in_x - 2*ledge, floor_t + 2, inz(y0) + lip_t + 2]);
        // sprung tab in the back plate (U-slot, thinned to 2 mm from behind)
        if (tab) {
            translate([-tab_w/2 - g, tab_y0, -1]) cube([g, tab_len + g, back_t + 2]);
            translate([tab_w/2, tab_y0, -1]) cube([g, tab_len + g, back_t + 2]);
            translate([-tab_w/2 - g, tab_y0 + tab_len, -1]) cube([tab_w + 2*g, g, back_t + 2]);
            translate([-tab_w/2, tab_y0, -1]) cube([tab_w, tab_len, back_t - 2 + 1]);
        }
        for (x = [-bx, bx]) translate([x, 0, 0]) bar_groove(y0);
    }
    if (tab) {
        by = tab_y0 + tab_len - 8;
        translate([0, 0, z1]) hull() {
            translate([-tab_w/2 + 2, by - 4, -0.01]) cube([tab_w - 4, 8, 0.01]);
            translate([-tab_w/2 + 2, by - 0.5, bump - 0.01]) cube([tab_w - 4, 1, 0.01]);
        }
    }
}

function hub(n) = [for (h = hubs) if (h[0] == n) h][0];
module hub_pocket(n) let(h = hub(n)) pocket(h[1], h[2], h[3], h[4], h[5], h[6]);
module hub_pocket_print(n) let(h = hub(n)) translate([0, 0, h[5]/2]) rotate([-90, 0, 0]) hub_pocket(n);

module assembled(n) let(h = hub(n)) {
    hub_pocket(n);
    for (x = [-h[6], h[6]]) translate([x, 0, 0]) hook_bar();
    %let(tb = is_list(h[3]) ? h[3][0] : h[3], tt = is_list(h[3]) ? h[3][1] : h[3])
        hull() {
            translate([-h[1]/2, -h[5]/2 + floor_t, back_t]) cube([h[1], 0.01, tb]);
            translate([-h[1]/2, -h[5]/2 + floor_t + h[2], back_t]) cube([h[1], 0.01, tt]);
        }
}

if (part == "all") for (i = [0:2]) translate([0, i * 150, 0]) assembled(hubs[i][0]);
for (h = hubs) {
    if (part == h[0]) hub_pocket(h[0]);
    if (part == str(h[0], "_print")) hub_pocket_print(h[0]);
}
