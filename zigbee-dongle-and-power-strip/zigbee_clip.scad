// SKÅDIS clip for the Sonoff ZBDongle-E Zigbee coordinator
// (HA: Zigbee2MQTT bridge reports EZSP v8 6.10.3 = EFR32MG21 = ZBDongle-E).
// Sonoff spec: body 75 x 25.5 x 13.5 mm (aluminium), SMA antenna 108 mm on the far end.
//
// Dongle stands upright, ANTENNA UP, USB plug DOWN through an open floor into a USB
// extension lead, so it can sit 30-50 cm away from the Trigkey / USB3 SSDs (USB3 noise
// wrecks 2.4 GHz Zigbee). Body rests on two 4 mm ledges either side of the plug.
// Two crush ribs on each side wall hold it snug; front lips keep it in.
// Hangs on ONE hook bar (skadis_hooks.scad), slid up from below.
// Print: upside down (open top on the bed), PETG, no supports.
// Axes: X = across the board, Y = up, Z = out from the board.

include <skadis_hooks.scad>

part = "clip";        // clip | clip_print | assembled

dg_w = 25.5;          // across
dg_t = 13.5;          // out from the board
dg_l = 75;            // vertical (preview only)

clr_w = 0.6;  clr_t = 0.6;
rib   = 0.35;         // crush ribs take up the side clearance
wall = 2.4;  back_t = 5;  lip = 4;  lip_t = 2;  floor_t = 2.4;  ledge = 4;
ph = 64;              // pocket height (one hook bar needs >= 64)

in_x = dg_w + clr_w;  in_z = dg_t + clr_t;  out_x = in_x + 2*wall;
z1 = back_t;  z2 = z1 + in_z;  out_z = z2 + lip_t;
y0 = -ph/2;  y1 = ph/2;

module clip() {
    difference() {
        translate([-out_x/2, y0, 0]) cube([out_x, ph, out_z]);
        translate([-in_x/2, y0 + floor_t, z1]) cube([in_x, ph, in_z]);
        // open front between the lips (shows the dongle, lets air round the aluminium body)
        translate([-in_x/2 + lip, y0 + floor_t, z2 - 1]) cube([in_x - 2*lip, ph, lip_t + 2]);
        // open floor between the ledges: USB plug + extension socket pass through
        translate([-in_x/2 + ledge, y0 - 1, z1]) cube([in_x - 2*ledge, floor_t + 2, in_z + lip_t + 1]);
        bar_groove(y0);
    }
    // crush ribs: two per side, vertical (print-friendly), 0.35 mm proud
    for (s = [-1, 1], z = [z1 + in_z*0.3, z1 + in_z*0.7])
        translate([s > 0 ? in_x/2 - rib : -in_x/2 - 0.02, y0 + floor_t + ph*0.2, z])
            cube([rib + 0.02, ph*0.6, 1.2]);
}

module assembled() {
    clip();
    hook_bar();
    %translate([-dg_w/2, y0 + floor_t, z1 + clr_t/2]) cube([dg_w, dg_l, dg_t]);
    %translate([0, y0 + floor_t + dg_l, z1 + clr_t/2 + dg_t/2]) rotate([-90, 0, 0]) cylinder(d = 10, h = 108);
}

if (part == "clip") clip();
if (part == "clip_print") translate([0, 0, y1]) rotate([-90, 0, 0]) clip();
if (part == "assembled") assembled();
