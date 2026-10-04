# Printables listings (andiprint) — SKÅDIS network rack
Licence on all: CC BY-NC-SA 4.0. Category: Household > Organization (fallback: Hobby & Makers > Organizers).
Common print settings: PETG, 0.2 mm layers, 4 walls, 25% gyroid, no supports. Printer: Creality K2.
Footer on every description:
  Part of my SKÅDIS network rack collection. Editable OpenSCAD source for everything: https://github.com/PrimroseHA/skadis-network-mounts

## 1. SKÅDIS slide-in drop-lock hook bars (the base system)
Summary: Hook bars that slide into a dovetail groove on any part and drop-lock into IKEA SKÅDIS. Build your own holders.
Tags: skadis, ikea, pegboard, hook, dovetail, openscad, parametric, organizer
Description:
Every holder in my SKÅDIS network rack hangs on these: small printed bars with two drop-lock hooks, 40 mm apart, that slide up into a dovetail groove in the back of the part.

Why separate bars?
- Hooks print strong, flat on their side, instead of as weak overhangs on the back of a big part.
- The holder itself prints with no supports.
- Swap or reprint a bar without reprinting the holder.

How it works: offer the bar up 4 to 7 mm above its seat, push the hooks straight into the slots and let it drop. The tab face ramps from a loose lead-in to a 4.95 mm grip, so the weight pulls the part tight to the board. Then slide your holder down over the bars.

Designing your own part: include skadis_hooks.scad and difference bar_groove(part_bottom) from your back plate (back face at z = 0). Pass the part's bottom edge so the groove runs right out through the bottom, or the bar can't slide in. Columns 40 mm apart (bars at x = ±20) put both bars in the same row.

Print the bars on their flat side (hook_bar_print() in the scad).
Files: skadis_hooks.scad, skadis_hook_bar.stl
Images: hookbar_render.png (cover), HOW_dovetail_cross_section.png, HOW_slots_from_below.png, board_full.jpg

## 2. SKÅDIS holder for TP-Link Omada POE380S PoE++ injector
Summary: Portrait pocket for the TP-Link Omada POE380S (90 W PoE++) injector on IKEA SKÅDIS. Plugs exit straight out underneath.
Tags: skadis, ikea, pegboard, tp-link, omada, poe, injector, homelab, network
Description:
A pocket that holds the TP-Link Omada POE380S PoE++ injector (155 x 70 x 42 mm) upright on SKÅDIS. The injector drops in from the open top and sits on a floor frame that is open in the middle, so the leads on the bottom end come straight out. A spring tab keeps it snug and the logo faces out.

This was the first part of my rack and the test bed for the hook design, so it uses its own hook bars (included). Print the pocket upside down (open top on the bed): no supports, one 70 mm bridge. skadis_fit_check.scad is the fit test I used for the hooks.
Files: poe380s_skadis.scad, lib.scad, skadis_fit_check.scad, poe380s_pocket_PRINT.stl, poe380s_hook_bar_PRINT_x2.stl, POE380S_pocket_full_plate.3mf
Images: poe.jpg (cover), pocket_assembled_view.png, pocket_view.png

## 3. SKÅDIS mount for TP-Link TL-SG1024D 24-port switch (uses its own 19" ears)
Summary: Hang a TP-Link TL-SG1024D 24-port switch flat on IKEA SKÅDIS, ports down, using its own 19" rack ears.
Tags: skadis, ikea, pegboard, tp-link, switch, network switch, 19 inch, rack, homelab
Description:
Hangs the TP-Link TL-SG1024D (294 x 180 x 44 mm) flat on the board with the ports facing down and power at the top. It reuses the switch's own metal 19" rack ears: they rest on two printed shelves, bolted through the rack holes with M6 bolts (holes slotted ±2.5 mm). Two side clips near the top have a lip over the front edge, and they grip clear of the side vents.

Parts: 2 shelves (L/R), 2 clips (L/R), 6 hook bars. Hardware: 4 x M6 x 16 bolts and nuts. The full plate is about 190 g of PETG.
Bonus: board_fixings.scad, spacer.stl and cap.stl are the 20 mm wall spacers and caps I used to fix the SKÅDIS board to a brick wall (4.5 x 60 screws, M5 penny washers).
Files: sg1024d_skadis.scad, skadis_hooks.scad, shelf_l.stl, shelf_r.stl, clip_l.stl, clip_r.stl, hook_bar_x6.stl, SG1024D_switch_mount_full_plate.3mf, board_fixings.scad, spacer.stl, cap.stl
Images: switch.jpg (cover), assembled_view.png, plate_layout.png, spacer_view.png

## 4. SKÅDIS pockets for smart home hubs: Heatmiser neoHub, SmartThings v3, Lightwave Link Plus
Summary: Pockets that hold a Heatmiser neoHub v2, Samsung SmartThings Hub v3 and Lightwave Link Plus on IKEA SKÅDIS, ports down.
Tags: skadis, ikea, pegboard, smart home, smartthings, heatmiser, lightwave, home assistant, hub
Description:
Three calipered pockets for smart home hubs, all built from one parametric pocket() module:
- Heatmiser neoHub v2: 172 x 91.6 x 27.2 mm (the datasheet says 25.5, which is too thin!)
- Samsung SmartThings Hub v3: 127.1 x 126.6 x 29.5 mm
- Lightwave Link Plus L2 (older wedge shell): 114.7 long, sloping 36.6 to 26.3 mm. The pocket follows the slope.

Each hub sits base to the board with the port edge DOWN through an open floor, so leads drop straight out. Front lips hold it in and a sprung bump in the back plate stops rattles. Each pocket hangs on 2 hook bars. Print upside down (open top on the bed), no supports.
Got a different hub? Add a line to the hubs table in hub_pockets.scad.
Files: hub_pockets.scad, skadis_hooks.scad, neohub_PRINT.stl, smartthings_PRINT.stl, linkplus_PRINT.stl, hook_bar_x6.stl, Hub_pockets_full_plate.3mf
Images: hubs.jpg (cover), neohub.jpg, hub_pockets_view.png

## 5. SKÅDIS pocket for TRIGKEY G4 (N100) mini PC
Summary: Upright pocket for the TRIGKEY G4 N100 mini PC on IKEA SKÅDIS. Front ports face down, vents stay open.
Tags: skadis, ikea, pegboard, mini pc, trigkey, n100, homelab, proxmox, home assistant
Description:
Holds a TRIGKEY G4 (N100) mini PC (calipered 115.9 x ~102 x 44.4 mm incl. feet) upright, logo out, with the front ports (2 x USB-A, power, button) facing DOWN through an open floor. The side walls and back plate are opened up so the side vents and base can breathe. A sprung bump in the back pushes it onto the front lips: snug, no rattle.
It runs my Proxmox / Home Assistant box. Hangs on 2 hook bars. Print upside down, no supports.
Files: trigkey_pocket.scad, skadis_hooks.scad, trigkey_pocket_PRINT.stl, hook_bar_x2.stl
Images: trigkey.jpg (cover), trigkey_pocket_view.png

## 6. SKÅDIS rack for 2 x UGREEN 2.5" USB-C SSD enclosures
Summary: Holds two UGREEN 2.5" USB-C SSD enclosures upright on IKEA SKÅDIS, with an open floor for the leads.
Tags: skadis, ikea, pegboard, ssd, ugreen, 2.5 inch, enclosure, nas, homelab
Description:
Two upright slots, front to back, for UGREEN USB-C 3.1 Gen 2 2.5" enclosures (model 80556, 134 x 82 x 16 mm). Sprung bumps in each slot grip anything from 14.6 to 16.6 mm thick. The floor is two side ledges with the middle open, so a USB-C lead comes straight out the bottom. 8 mm front lips leave the labels and LEDs showing.
Hangs on 2 hook bars. Print upside down, no supports. About 76 g.
Files: ssd_rack.scad, skadis_hooks.scad, ssd_rack_PRINT.stl, hook_bar_x2.stl, UGREEN_SSD_rack_full_plate.3mf
Images: ugreen.jpg (cover), ssd_rack_view.png

## 7. SKÅDIS clip for Sonoff ZBDongle-E Zigbee dongle
Summary: Holds a Sonoff ZBDongle-E upright on IKEA SKÅDIS, antenna up, on a USB extension away from USB3 noise.
Tags: skadis, ikea, pegboard, sonoff, zigbee, zbdongle, zigbee2mqtt, home assistant
Description:
Stands a Sonoff ZBDongle-E (75 x 25.5 x 13.5 mm body) upright with the antenna up and the USB plug down through an open floor into a USB extension lead. That lets it sit 30 to 50 cm away from the mini PC and USB3 drives, because USB3 noise wrecks 2.4 GHz Zigbee. The body rests on two 4 mm ledges, crush ribs hold it snug and front lips keep it in.
Hangs on ONE hook bar. Print upside down, no supports.
Files: zigbee_clip.scad, skadis_hooks.scad, zigbee_clip_PRINT.stl, hook_bar_x1.stl
Images: zigbee.jpg (cover), zigbee_clip_view.png

## Collection: SKÅDIS network rack
Description: Everything on my home network SKÅDIS board: switch, PoE injector, mini PC, SSDs, smart home hubs and Zigbee dongle, all hanging on the same slide-in hook bars. Cover: board_full.jpg

## HELD BACK: 6-way extension lead holder v2 (not printed or tested yet). Publish after a test fit.
