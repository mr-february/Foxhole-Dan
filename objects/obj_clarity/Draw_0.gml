var bob = sin(current_time * 0.003 + bob_offset) * 3;
var bx = x - 8;
var by = y - 8 + bob;

// Blue pill / calm symbol
draw_set_color(make_color_rgb(30, 80, 200));
draw_rectangle(bx, by + 3, bx + 15, by + 12, false);
draw_set_color(c_white);
// Cross / peace mark
draw_rectangle(bx + 7, by + 4, bx + 8, by + 11, false);
draw_rectangle(bx + 3, by + 7, bx + 12, by + 8, false);
draw_set_color(make_color_rgb(80, 140, 255));
draw_rectangle(bx, by + 3, bx + 15, by + 12, true);

// Glow pulse
var pulse = abs(sin(current_time * 0.004));
draw_set_alpha(pulse * 0.3);
draw_set_color(make_color_rgb(100, 180, 255));
draw_rectangle(bx - 2, by + 1, bx + 17, by + 14, false);
draw_set_alpha(1);
draw_set_color(c_white);
