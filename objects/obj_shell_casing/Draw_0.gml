var _a = clamp(life / 18.0, 0.0, 1.0);
draw_set_alpha(_a);

var _len = 5;
var x1 = x + lengthdir_x(_len, angle);
var y1 = y + lengthdir_y(_len, angle);
var x2 = x + lengthdir_x(-_len, angle);
var y2 = y + lengthdir_y(-_len, angle);

// Brass body
draw_set_color(make_color_rgb(205, 155, 50));
draw_line_width(x1, y1, x2, y2, 4);
// Highlight glint
draw_set_color(make_color_rgb(255, 220, 110));
draw_line_width(x1, y1, x2, y2, 1);

draw_set_alpha(1);
draw_set_color(c_white);
