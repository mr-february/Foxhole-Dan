var bob = sin(current_time * 0.003 + bob_offset) * 4;
var bx  = x - 14;
var by  = y - 14 + bob;

// Pulsing glow ring
draw_set_alpha(0.30 + 0.20 * abs(sin(current_time * 0.005 + 1.0)));
draw_set_color(make_color_rgb(255, 215, 40));
draw_ellipse(bx - 7, by - 7, bx + 35, by + 35, false);
draw_set_alpha(1);

// Yellow box body
draw_set_color(make_color_rgb(195, 155, 18));
draw_rectangle(bx, by, bx + 28, by + 28, false);
// Stencil: AMMO text area (dark)
draw_set_color(make_color_rgb(30, 30, 30));
draw_rectangle(bx + 4, by + 4, bx + 24, by + 24, false);
// Bullet silhouettes (3 rounds)
draw_set_color(make_color_rgb(215, 185, 40));
draw_rectangle(bx + 7,  by + 5, bx + 11, by + 12, false);
draw_rectangle(bx + 13, by + 5, bx + 17, by + 12, false);
draw_rectangle(bx + 19, by + 5, bx + 23, by + 12, false);
draw_rectangle(bx + 7,  by + 12, bx + 23, by + 23, false);
// Yellow border
draw_set_color(make_color_rgb(255, 220, 60));
draw_rectangle(bx, by, bx + 28, by + 28, true);
draw_set_color(c_white);
