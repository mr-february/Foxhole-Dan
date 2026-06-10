var bob = sin(current_time * 0.003 + bob_offset) * 4;
var bx  = x - 14;
var by  = y - 14 + bob;

// Pulsing glow ring
draw_set_alpha(0.30 + 0.20 * abs(sin(current_time * 0.005)));
draw_set_color(make_color_rgb(255, 80, 80));
draw_ellipse(bx - 7, by - 7, bx + 35, by + 35, false);
draw_set_alpha(1);

// Red box body
draw_set_color(make_color_rgb(210, 28, 28));
draw_rectangle(bx, by, bx + 28, by + 28, false);
// White cross
draw_set_color(c_white);
draw_rectangle(bx + 11, by + 4, bx + 17, by + 24, false);
draw_rectangle(bx + 4,  by + 11, bx + 24, by + 17, false);
// Red border
draw_set_color(make_color_rgb(255, 100, 100));
draw_rectangle(bx, by, bx + 28, by + 28, true);
draw_set_color(c_white);
