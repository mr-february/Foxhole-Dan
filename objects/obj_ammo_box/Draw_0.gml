var bob = sin(current_time * 0.003 + bob_offset) * 3;
var bx = x - 8;
var by = y - 8 + bob;

// Yellow box with bullet silhouette
draw_set_color(make_color_rgb(200, 160, 20));
draw_rectangle(bx, by, bx + 15, by + 15, false);
draw_set_color(make_color_rgb(40, 40, 40));
// Bullet shape
draw_rectangle(bx + 5, by + 3, bx + 10, by + 7, false);
draw_rectangle(bx + 6, by + 7, bx + 9, by + 12, false);
draw_set_color(make_color_rgb(240, 200, 40));
draw_rectangle(bx, by, bx + 15, by + 15, true);
draw_set_color(c_white);
