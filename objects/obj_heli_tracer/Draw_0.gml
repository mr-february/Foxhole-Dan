var trail = 30;
var tx = x - lengthdir_x(trail, direction);
var ty = y - lengthdir_y(trail, direction);

draw_set_alpha(0.28);
draw_set_color(tracer_col);
draw_line_width(tx, ty, x, y, 5);

draw_set_alpha(0.9);
draw_set_color(c_white);
draw_line_width(tx, ty, x, y, 2);

draw_set_alpha(1);
draw_set_color(tracer_col);
draw_circle(x, y, 3, false);

draw_set_alpha(1);
draw_set_color(c_white);
