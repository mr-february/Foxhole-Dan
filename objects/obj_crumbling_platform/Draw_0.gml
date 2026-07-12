// === CRUMBLING ICE LEDGE — pale cracked slab, distinct from solid rock ===
// (Overrides obj_platform's inherited Draw event.)

// Shake offset while triggered
var ox = 0;
var oy = 0;
if (crumble_timer >= 0) {
    var _mag = 1 + (40 - crumble_timer) * 0.06;
    ox = random_range(-_mag, _mag);
    oy = random_range(-_mag * 0.5, _mag * 0.5);
}

var x1 = x + ox;
var y1 = y + oy;
var x2 = x1 + 32;
var y2 = y1 + 32;

// Position hash for per-tile crack variety
var _h = (x * 7 + y * 13) mod 100;

// Ice body — pale blue-white
draw_set_color(make_color_rgb(168, 190, 210));
draw_rectangle(x1, y1, x2, y2, false);

// Snow cap on top
draw_set_color(make_color_rgb(230, 240, 250));
draw_rectangle(x1, y1, x2, y1 + 6, false);

// Deep blue shadow at the base
draw_set_color(make_color_rgb(110, 135, 165));
draw_rectangle(x1, y2 - 7, x2, y2, false);

// --- CRACKS (always visible — reads as "unsafe" at a glance) ---
draw_set_color(make_color_rgb(70, 92, 120));
if (_h mod 2 == 0) {
    draw_line(x1 + 5,  y1 + 4,  x1 + 14, y1 + 18);
    draw_line(x1 + 14, y1 + 18, x1 + 9,  y2 - 3);
    draw_line(x1 + 14, y1 + 18, x1 + 24, y1 + 24);
    draw_line(x1 + 22, y1 + 2,  x1 + 26, y1 + 12);
} else {
    draw_line(x1 + 26, y1 + 5,  x1 + 17, y1 + 16);
    draw_line(x1 + 17, y1 + 16, x1 + 21, y2 - 4);
    draw_line(x1 + 17, y1 + 16, x1 + 6,  y1 + 22);
    draw_line(x1 + 8,  y1 + 3,  x1 + 11, y1 + 11);
}

// Missing corner chip
draw_set_color(make_color_rgb(84, 108, 136));
if (_h < 50) draw_triangle(x2 - 8, y1, x2, y1, x2, y1 + 8, false);
else         draw_triangle(x1, y1, x1 + 8, y1, x1, y1 + 8, false);

// --- Triggered: cracks widen + red-ish stress tint ---
if (crumble_timer >= 0) {
    var _p = 1 - crumble_timer / 40;
    draw_set_color(make_color_rgb(40, 58, 84));
    draw_line_width(x1 + 4, y1 + 6, x2 - 6, y2 - 6, 1 + _p * 2);
    draw_line_width(x2 - 4, y1 + 8, x1 + 8, y2 - 4, 1 + _p * 2);
    draw_set_alpha(0.25 * _p);
    draw_set_color(make_color_rgb(220, 120, 90));
    draw_rectangle(x1, y1, x2, y2, false);
    draw_set_alpha(1);
    // Falling dust motes
    draw_set_color(make_color_rgb(225, 235, 245));
    draw_set_alpha(0.6);
    for (var _i = 0; _i < 3; _i++) {
        var _dx = x1 + 6 + _i * 10;
        var _dy = y2 + ((current_time * 0.15 + _i * 40) mod 30);
        draw_circle(_dx, _dy, 1.5, false);
    }
    draw_set_alpha(1);
}

// Edge highlight / shadow
draw_set_color(make_color_rgb(240, 248, 255));
draw_line(x1, y1, x2, y1);
draw_line(x1, y1, x1, y2);
draw_set_color(make_color_rgb(90, 115, 145));
draw_line(x1, y2, x2, y2);
draw_line(x2, y1, x2, y2);

draw_set_color(c_white);
