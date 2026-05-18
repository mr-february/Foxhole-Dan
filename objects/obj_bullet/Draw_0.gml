var trail = 20;
var tx = x - lengthdir_x(trail, direction);
var ty = y - lengthdir_y(trail, direction);

// Outer glow
draw_set_alpha(0.30);
draw_set_color(make_color_rgb(255, 235, 140));
draw_line_width(tx, ty, x, y, 5);

// Core streak
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(255, 255, 210));
draw_line_width(tx, ty, x, y, 2);

// Hot tip
draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 240, 100));
draw_circle(x, y, 3, false);

draw_set_alpha(1);
draw_set_color(c_white);
