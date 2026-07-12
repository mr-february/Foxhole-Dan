var dx = lengthdir_x(1, direction);
var dy = lengthdir_y(1, direction);

// === SMOKE TRAIL — fading puffs behind the rocket ===
draw_set_color(make_color_rgb(150, 148, 140));
draw_set_alpha(0.30);
draw_circle(x - dx * 14 + random_range(-1, 1), y - dy * 14 + random_range(-1, 1), 4, false);
draw_set_alpha(0.20);
draw_circle(x - dx * 22 + random_range(-2, 2), y - dy * 22 + random_range(-2, 2), 5, false);
draw_set_alpha(0.12);
draw_circle(x - dx * 30 + random_range(-3, 3), y - dy * 30 + random_range(-3, 3), 6, false);
draw_set_alpha(1);

// === EXHAUST FLAME ===
draw_set_color(make_color_rgb(255, 170, 60));
draw_circle(x - dx * 9 + random_range(-1, 1), y - dy * 9 + random_range(-1, 1), 2 + random(2), false);
draw_set_color(make_color_rgb(255, 230, 130));
draw_circle(x - dx * 8, y - dy * 8, 1.5, false);

// === BODY ===
draw_set_color(make_color_rgb(70, 78, 62));
draw_line_width(x - dx * 8, y - dy * 8, x + dx * 4, y + dy * 4, 5);
// Fins
draw_set_color(make_color_rgb(50, 56, 44));
draw_line_width(x - dx * 7 - dy * 4, y - dy * 7 + dx * 4, x - dx * 4, y - dy * 4, 2);
draw_line_width(x - dx * 7 + dy * 4, y - dy * 7 - dx * 4, x - dx * 4, y - dy * 4, 2);
// Warhead
draw_set_color(make_color_rgb(150, 60, 40));
draw_circle(x + dx * 5, y + dy * 5, 3, false);

draw_set_color(c_white);
