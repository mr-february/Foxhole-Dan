// === DOOR-GUN FOREGROUND FRAME (fixed, upper-left cabin) ===
// Huey-style door-gunner view: olive-drab fuselage roofline sloping down toward
// the nose, a tail boom stub receding off the back, a riveted cabin wall, a
// greenhouse window strip, and a pintle-mounted M60 — instead of the old flat
// grey rectangles, which read as generic scaffolding rather than a helicopter.
// A tiny rotor-driven vibration sells "in flight" without touching real x/y.
var _bob = sin(rotor * 2) * 1.2;
var bx = x, by = y + _bob;

var _olive      = make_color_rgb(74, 82, 52);
var _olive_dk   = make_color_rgb(52, 58, 36);
var _olive_dkr  = make_color_rgb(38, 43, 27);
var _metal      = make_color_rgb(58, 60, 56);
var _metal_dk   = make_color_rgb(34, 36, 33);
var _glass      = make_color_rgb(64, 78, 72);

// --- Fuselage roof: slopes down toward the nose (front-right) instead of a flat slab ---
draw_set_color(_olive);
draw_rectangle(bx - 80, by - 96, bx - 10, by - 40, false);
draw_triangle(bx - 10, by - 96, bx - 10, by - 40, bx + 46, by - 62, false);   // nose taper
draw_set_color(_olive_dkr);
draw_line_width(bx - 80, by - 96, bx + 46, by - 62, 2);                       // roofline highlight edge

// Tail boom stub receding off the back, implying the fuselage continues past frame
draw_set_color(_olive_dk);
draw_rectangle(bx - 140, by - 74, bx - 78, by - 62, false);
draw_set_color(_metal_dk);
draw_line_width(bx - 140, by - 68, bx - 150, by - 66, 2);

// Rotor mast
draw_set_color(_metal_dk);
draw_rectangle(bx - 24, by - 112, bx - 16, by - 96, false);

// Rotor blades — two long blades spinning around the mast, plus a faint
// motion-blur disc so it always reads as "spinning" even at low framerate.
var _rhx = bx - 20, _rhy = by - 112;
draw_set_alpha(0.16);
draw_set_color(make_color_rgb(20, 20, 20));
draw_circle(_rhx, _rhy, 130, false);
draw_set_alpha(1);
for (var _bi = 0; _bi < 2; _bi++) {
    var _bang = rotor + _bi * 180;
    draw_set_color(make_color_rgb(18, 18, 18));
    draw_line_width(_rhx - lengthdir_x(130, _bang), _rhy - lengthdir_y(130, _bang) * 0.28,
                     _rhx + lengthdir_x(130, _bang), _rhy + lengthdir_y(130, _bang) * 0.28, 4);
}
draw_set_color(make_color_rgb(60, 60, 56));
draw_circle(_rhx, _rhy, 8, false);
draw_set_color(make_color_rgb(30, 30, 28));
draw_circle(_rhx, _rhy, 8, true);

// Cabin frame / door edge
draw_set_color(_olive_dk);
draw_rectangle(bx - 60, by - 40, bx + 20, by + 70, false);

// Greenhouse window strip along the top of the cabin wall, with a support strut
draw_set_color(_glass);
draw_rectangle(bx - 58, by - 38, bx + 16, by - 20, false);
draw_set_color(_metal_dk);
draw_rectangle(bx - 12, by - 38, bx - 8, by - 20, false);   // window strut

// Riveted skin — a few small dark dots along the cabin wall for texture
draw_set_color(_olive_dkr);
for (var _rv = 0; _rv < 4; _rv++) {
    draw_circle(bx - 52 + _rv * 20, by - 8, 1.4, false);
    draw_circle(bx - 52 + _rv * 20, by + 40, 1.4, false);
}

draw_set_color(_metal);
draw_rectangle(bx - 60, by - 40, bx - 44, by + 70, false);   // door pillar
draw_set_color(_metal_dk);
draw_rectangle(bx - 80, by + 70, bx + 40, by + 92, false);   // floor / skid line

// Ammo box + pintle mount post (grounds the gun to the airframe)
draw_set_color(_olive_dkr);
draw_rectangle(bx - 44, by + 54, bx - 22, by + 70, false);
draw_set_color(_metal_dk);
draw_rectangle(bx - 4, by + 20, bx + 2, by + 70, false);

// Gunner
draw_set_color(_olive);
draw_rectangle(bx - 34, by - 6, bx - 12, by + 34, false);     // torso
draw_set_color(make_color_rgb(176, 142, 108));
draw_ellipse(bx - 30, by - 22, bx - 14, by - 6, false);       // helmet head
draw_set_color(_olive_dkr);
draw_ellipse(bx - 31, by - 24, bx - 13, by - 10, false);      // flight helmet
draw_set_color(_metal_dk);
draw_rectangle(bx - 30, by - 18, bx - 15, by - 13, false);    // visor band

// The door gun, tracking the aim
var ang = point_direction(bx + 18, by + 30, aim_x, aim_y);
draw_set_color(_olive);
draw_line_width(bx - 34, by + 16, bx - 4, by + 22, 6);        // gunner's arm to the grip
draw_set_color(make_color_rgb(28, 26, 22));
draw_line_width(bx - 6, by + 18, bx + 18 + lengthdir_x(46, ang), by + 30 + lengthdir_y(46, ang), 5);
draw_set_color(_metal);
draw_rectangle(bx - 10, by + 10, bx + 6, by + 26, false);     // receiver

// === RETICLE ===
draw_set_color(make_color_rgb(255, 90, 60));
draw_circle(aim_x, aim_y, 16, true);
draw_line(aim_x - 22, aim_y, aim_x - 8, aim_y);
draw_line(aim_x + 8, aim_y, aim_x + 22, aim_y);
draw_line(aim_x, aim_y - 22, aim_x, aim_y - 8);
draw_line(aim_x, aim_y + 8, aim_x, aim_y + 22);
draw_set_color(c_white);
