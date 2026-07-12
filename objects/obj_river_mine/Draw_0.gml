// Mooring cable
draw_set_color(make_color_rgb(40, 50, 54));
draw_line_width(x, y, x, room_height, 2);
// Spiked mine body
draw_set_color(make_color_rgb(30, 34, 30));
draw_circle(x, y, 16, false);
draw_set_color(make_color_rgb(48, 52, 46));
draw_circle(x, y, 16, true);
// Spikes
draw_set_color(make_color_rgb(60, 62, 58));
for (var a = 0; a < 360; a += 45) {
    draw_line_width(x + lengthdir_x(14, a), y + lengthdir_y(14, a), x + lengthdir_x(24, a), y + lengthdir_y(24, a), 3);
}
// Warning glint
draw_set_color(make_color_rgb(200, 60, 40));
draw_circle(x - 4, y - 4, 3, false);
draw_set_color(c_white);
