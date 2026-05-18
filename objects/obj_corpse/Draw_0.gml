draw_set_alpha(clamp(fade / 255, 0, 1));

var f = facing;

// Collapsed body - lying on its side
// Torso horizontal
draw_set_color(make_color_rgb(120, 30, 30));
draw_rectangle(x - 15 * f, y - 5, x + 15 * f, y + 5, false);

// Head further out
draw_set_color(make_color_rgb(160, 110, 75));
draw_rectangle(x + 14 * f, y - 5, x + 22 * f, y + 5, false);

// Legs splayed slightly
draw_set_color(make_color_rgb(50, 60, 40));
draw_rectangle(x - 5, y + 3, x - 20 * f, y + 10, false);
draw_rectangle(x - 2, y + 6, x - 18 * f, y + 13, false);

// Helmet on the ground
draw_set_color(make_color_rgb(40, 50, 28));
draw_rectangle(x + 12 * f, y - 9, x + 22 * f, y - 3, false);

// Blood pool
draw_set_color(make_color_rgb(80, 5, 5));
draw_set_alpha(clamp(fade / 255 * 0.7, 0, 0.7));
draw_ellipse(x, y + 4, x + 10 * f, y + 16, false);

draw_set_alpha(1);
draw_set_color(c_white);
