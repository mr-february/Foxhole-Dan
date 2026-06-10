var angle = point_direction(0, 0, speed, vspd);
var trail = 22;
var tx = x - lengthdir_x(trail, angle);
var ty = y - lengthdir_y(trail, angle);

draw_set_alpha(0.25);
draw_set_color(make_color_rgb(255, 235, 140));
draw_line_width(tx, ty, x, y, 6);

draw_set_alpha(0.85);
draw_set_color(make_color_rgb(255, 255, 200));
draw_line_width(tx, ty, x, y, 2);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 240, 100));
draw_circle(x, y, 3, false);

draw_set_alpha(1);
draw_set_color(c_white);
