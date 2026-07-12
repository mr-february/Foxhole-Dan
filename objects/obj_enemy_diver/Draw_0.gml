var bx = x, by = y, f = facing;

// Wetsuit body
draw_set_color(make_color_rgb(24, 30, 34));
draw_ellipse(bx - f * 14, by - 7, bx + f * 12, by + 7, false);
// Head + mask
draw_set_color(make_color_rgb(30, 38, 42));
draw_circle(bx + f * 12, by, 6, false);
draw_set_color(make_color_rgb(120, 170, 190));
draw_circle(bx + f * 13, by - 1, 2, false);   // mask glint
// Tank
draw_set_color(make_color_rgb(60, 66, 62));
draw_rectangle(bx - f * 12, by - 5, bx - f * 6, by + 5, false);
// Fins
draw_set_color(make_color_rgb(18, 22, 24));
var kick = sin(bob * 1.6) * 5;
draw_line_width(bx - f * 12, by - 2, bx - f * 22, by - 2 + kick, 4);
// Knife
draw_set_color(make_color_rgb(150, 155, 160));
draw_line_width(bx + f * 8, by + 2, bx + f * 18, by + 2, 2);

if (hit_flash > 0) {
    draw_set_alpha(0.6); draw_set_color(c_white);
    draw_ellipse(bx - f * 14, by - 7, bx + f * 12, by + 7, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
