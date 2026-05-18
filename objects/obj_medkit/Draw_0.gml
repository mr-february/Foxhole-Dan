var bob = sin(current_time * 0.003 + bob_offset) * 3;
var bx = x - 8;
var by = y - 8 + bob;

// White cross on red background
draw_set_color(make_color_rgb(200, 30, 30));
draw_rectangle(bx, by, bx + 15, by + 15, false);
draw_set_color(c_white);
draw_rectangle(bx + 6, by + 2, bx + 9, by + 13, false);
draw_rectangle(bx + 2, by + 6, bx + 13, by + 9, false);
draw_set_color(make_color_rgb(255, 80, 80));
draw_rectangle(bx, by, bx + 15, by + 15, true);
draw_set_color(c_white);
