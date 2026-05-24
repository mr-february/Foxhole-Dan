// Body
draw_set_color(make_color_rgb(45, 58, 30));
draw_circle(x, y, 5, false);
draw_set_color(make_color_rgb(28, 38, 18));
draw_circle(x, y, 5, true);
// Pin
draw_set_color(make_color_rgb(155, 135, 55));
draw_line(x, y - 5, x + 2, y - 8);
draw_circle(x + 2, y - 8, 2, false);

// Warning pulse when fuse < 40
if (fuse < 40) {
    var _frac = 1.0 - (fuse / 40.0);
    var _pa   = abs(sin(current_time * 0.04)) * _frac * 0.65;
    draw_set_alpha(_pa);
    draw_set_color(make_color_rgb(255, 50, 0));
    draw_circle(x, y, 10 + _frac * 6, true);
    draw_set_alpha(1);
}
draw_set_color(c_white);
