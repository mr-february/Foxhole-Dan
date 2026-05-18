var trail = 16;
var tx = x - lengthdir_x(trail, direction);
var ty = y - lengthdir_y(trail, direction);

// Outer glow — red
draw_set_alpha(0.28);
draw_set_color(make_color_rgb(255, 60, 60));
draw_line_width(tx, ty, x, y, 5);

// Core streak
draw_set_alpha(0.80);
draw_set_color(make_color_rgb(255, 140, 140));
draw_line_width(tx, ty, x, y, 2);

// Hot tip
draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 80, 80));
draw_circle(x, y, 2, false);

draw_set_alpha(1);
draw_set_color(c_white);
