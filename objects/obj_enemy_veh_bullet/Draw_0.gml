var trail = 18;
var tx = x - lengthdir_x(trail, direction);
var ty = y - lengthdir_y(trail, direction);

draw_set_alpha(0.25);
draw_set_color(make_color_rgb(255, 80, 40));
draw_line_width(tx, ty, x, y, 5);

draw_set_alpha(0.8);
draw_set_color(make_color_rgb(255, 140, 80));
draw_line_width(tx, ty, x, y, 2);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 100, 60));
draw_circle(x, y, 2, false);

draw_set_alpha(1);
draw_set_color(c_white);
