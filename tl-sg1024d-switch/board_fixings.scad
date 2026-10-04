// SKÅDIS board wall fixings (1 Oct 2026), each fixing, from the front:
//   printed cap -> M5 x 25 penny washer -> SKÅDIS board -> printed 20 mm spacer -> brick
//   screw: Spectre 4.5 x 60 mm, brown 7 mm plug.
// 8 fixings; print 10 of each for spares.

$fn = 64;
part = "spacer";   // spacer | cap

// --- 20 mm stand-off ---
sp_len = 20;
sp_od  = 16;
sp_id  = 5.0;      // clearance for a 4.5 mm screw
sp_ch  = 0.8;      // edge chamfer

// Locating boss on the board end (like IKEA's): sits 2.5 mm into a 5 x 15 mm SKÅDIS slot
// so the spacer can't slide. The slot is only 5 mm wide, so with the screw through the
// middle the boss is the slot shape with the screw hole cut out: two lugs that fill the
// slot's ends above and below the screw.
boss_h = 2.5;          // board is 5 mm thick
boss_w = 4.6;          // slot 5 wide
boss_l = 14.4;         // slot 15 long
module spacer() {
    difference() {
        union() {
            hull() {
                cylinder(d = sp_od - 2*sp_ch, h = sp_len);
                translate([0, 0, sp_ch]) cylinder(d = sp_od, h = sp_len - 2*sp_ch);
            }
            // boss on top (board end) - prints straight up, no overhang
            translate([0, 0, sp_len - 0.01]) linear_extrude(boss_h + 0.01)
                hull() for (y = [-1, 1]) translate([0, y * (boss_l - boss_w)/2]) circle(d = boss_w);
        }
        translate([0, 0, -1]) cylinder(d = sp_id, h = sp_len + boss_h + 2);
    }
}

// --- black cap that press-fits over the penny washer and hides the screw head ---
wa_od   = 25;      // F&F penny washer M5 x 25
wa_t    = 1.5;     // washer thickness
head_h  = 3.2;     // a 4.5 mm countersunk head sits ~3 mm proud of a flat washer
cap_wall = 1.6;
cap_top  = 1.2;
cap_bore = wa_od + 0.4;          // 25.4 bore ...
rib_in   = 0.35;                 // ... with 6 crush ribs gripping at ~24.7
skirt    = wa_t + 0.3;           // grips the washer edge, sits on the board
cap_od   = cap_bore + 2*cap_wall;
cap_h    = skirt + head_h + cap_top;

// modelled top-down (flat top at z = 0) = its print orientation, no overhangs
module cap() {
    difference() {
        hull() {
            cylinder(d = cap_od - 2, h = 0.01);
            translate([0, 0, 1]) cylinder(d = cap_od, h = cap_h - 1);
        }
        translate([0, 0, cap_top]) cylinder(d = cap_bore, h = cap_h);
    }
    // crush ribs on the skirt only
    for (a = [0 : 60 : 359]) rotate(a)
        translate([cap_bore/2 - rib_in, -0.6, cap_h - skirt]) cube([rib_in + 0.2, 1.2, skirt]);
}

if (part == "spacer") spacer();
if (part == "cap") cap();
