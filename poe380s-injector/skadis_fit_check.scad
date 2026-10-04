include <lib.scad>
// board slots for this holder: top-hook slots and peg slots (seated frame)
slot_bot_hook = hook_y - stem_h/2;
module slot2d() hull() { translate([0, 2.5]) circle(2.5); translate([0, 12.5]) circle(2.5); }
module slots2d() for (p = mount_pts) translate([p[0], p[1] - stem_h/2]) slot2d();
module board(t, dy) translate([0, dy, -t]) linear_extrude(t)
    difference() { translate([-100, -100]) square([300, 200]); slots2d(); }
mode = 0;
// 0: seated, board 5.0 -> expect only the thin wedge pinch
if (mode == 0) intersection() { mounts(); board(5.0, 0); }
// 1: insertion, holder 10 up, board infinite in z -> must be empty
if (mode == 1) intersection() { translate([0, drop, 0]) mounts(); translate([0, 0, 50]) board(100, 0); }
// 2: seated on a 4.9 / 5.1 board
if (mode == 2) intersection() { mounts(); board(4.9, 0); }
if (mode == 3) intersection() { mounts(); board(5.1, 0); }
// 4: drop sweep - holder at each drop height on a 5.0 board, report interference
if (mode == 4) intersection() { translate([0, drop, 0]) mounts(); board(5.0, 0); }
