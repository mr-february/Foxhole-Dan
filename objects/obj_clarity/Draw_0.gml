var bob = sin(current_time * 0.003 + bob_offset) * 4;
var bx  = x - 14;
var by  = y - 14 + bob;

// Pulsing glow ring
draw_set_alpha(0.28 + 0.22 * abs(sin(current_time * 0.005 + 2.1)));
draw_set_color(make_color_rgb(80, 160, 255));
draw_ellipse(bx - 7, by - 7, bx + 35, by + 35, false);
draw_set_alpha(1);

// Blue box body
draw_set_color(make_color_rgb(24, 72, 195));
draw_rectangle(bx, by, bx + 28, by + 28, false);
// Inner dark panel
draw_set_color(make_color_rgb(14, 42, 120));
draw_rectangle(bx + 4, by + 4, bx + 24, by + 24, false);
// Peace/calm cross symbol
draw_set_color(make_color_rgb(160, 210, 255));
draw_rectangle(bx + 12, by + 5, bx + 16, by + 23, false);
draw_rectangle(bx + 5,  by + 12, bx + 23, by + 16, false);
// Small corner dots (calm pattern)
draw_set_color(make_color_rgb(100, 180, 255));
draw_circle(bx + 7,  by + 7,  2, false);
draw_circle(bx + 21, by + 7,  2, false);
draw_circle(bx + 7,  by + 21, 2, false);
draw_circle(bx + 21, by + 21, 2, false);
// Blue border
draw_set_color(make_color_rgb(100, 180, 255));
draw_rectangle(bx, by, bx + 28, by + 28, true);
draw_set_color(c_white);
