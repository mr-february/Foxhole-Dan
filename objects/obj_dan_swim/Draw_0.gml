var bx = x, by = y, f = facing;

// Trailing bubbles
draw_set_color(make_color_rgb(180, 210, 230));
draw_set_alpha(0.5);
for (var i = 0; i < 3; i++) {
    var t = bub + i * 2;
    draw_circle(bx - f * (10 + i * 6), by - 6 - (t mod 14), 2 - i * 0.4, false);
}
draw_set_alpha(1);

// Body (streamlined swimmer, olive fatigues)
draw_set_color(make_color_rgb(52, 62, 40));
draw_ellipse(bx - f * 16, by - 7, bx + f * 12, by + 7, false);
// Head
draw_set_color(make_color_rgb(180, 148, 112));
draw_circle(bx + f * 12, by, 6, false);
// Legs kicking
draw_set_color(make_color_rgb(44, 52, 34));
var kick = sin(bub * 1.5) * 5;
draw_line_width(bx - f * 14, by - 2, bx - f * 24, by - 2 + kick, 3);
draw_line_width(bx - f * 14, by + 2, bx - f * 24, by + 2 - kick, 3);
// Arm forward
draw_set_color(make_color_rgb(52, 62, 40));
draw_line_width(bx + f * 8, by, bx + f * 20, by - 2, 3);

// Low-air face gasp tint
if (air < 25) {
    draw_set_color(make_color_rgb(120, 160, 220));
    draw_set_alpha(0.3);
    draw_circle(bx + f * 12, by, 8, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
