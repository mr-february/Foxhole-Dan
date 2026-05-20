if (tower_type == 0) {
    // MG Nest — sandbag ring + gun barrel
    draw_set_color(make_color_rgb(140, 115, 72));
    draw_circle(x, y, 16, false);
    draw_set_color(make_color_rgb(110, 88, 55));
    draw_circle(x, y, 16, true);
    // Gun barrel
    var _bx2 = x + lengthdir_x(20, aim_dir);
    var _by2 = y + lengthdir_y(20, aim_dir);
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_line_width(x, y, _bx2, _by2, 4);
    // Centre
    draw_set_color(make_color_rgb(80, 65, 40));
    draw_circle(x, y, 6, false);
    // Range ring (faint)
    if (initialized) {
        draw_set_color(make_color_rgb(200, 180, 100));
        draw_set_alpha(0.12);
        draw_circle(x, y, range, false);
        draw_set_alpha(0.25);
        draw_circle(x, y, range, true);
        draw_set_alpha(1);
    }
}

if (tower_type == 1) {
    // Artillery — wide base + thick barrel
    draw_set_color(make_color_rgb(55, 58, 65));
    draw_circle(x, y, 22, false);
    draw_set_color(make_color_rgb(40, 42, 48));
    draw_circle(x, y, 22, true);
    // Gun barrel (wider)
    var _bx2 = x + lengthdir_x(28, aim_dir);
    var _by2 = y + lengthdir_y(28, aim_dir);
    draw_set_color(make_color_rgb(45, 45, 52));
    draw_line_width(x, y, _bx2, _by2, 7);
    // Muzzle
    draw_set_color(make_color_rgb(70, 70, 80));
    draw_circle(_bx2, _by2, 4, false);
    // Centre
    draw_set_color(make_color_rgb(80, 82, 90));
    draw_circle(x, y, 8, false);
    // Range ring
    if (initialized) {
        draw_set_color(make_color_rgb(100, 140, 220));
        draw_set_alpha(0.10);
        draw_circle(x, y, range, false);
        draw_set_alpha(0.22);
        draw_circle(x, y, range, true);
        draw_set_alpha(1);
    }
}

if (tower_type == 2) {
    // Barricade — row of sandbag rectangles
    var _angle_r = 0;  // not tracking orientation; just draw as square cluster
    draw_set_color(make_color_rgb(145, 118, 72));
    // 3x3 sandbag cluster, top-down view
    for (var _si = -1; _si <= 1; _si++) {
        for (var _sj = -1; _sj <= 1; _sj++) {
            var _sx = x + _si * 12;
            var _sy = y + _sj * 10;
            draw_rectangle(_sx - 5, _sy - 4, _sx + 5, _sy + 4, false);
            draw_set_color(make_color_rgb(120, 96, 58));
            draw_rectangle(_sx - 5, _sy - 4, _sx + 5, _sy + 4, true);
            draw_set_color(make_color_rgb(145, 118, 72));
        }
    }
    // Slow radius indicator
    draw_set_color(make_color_rgb(160, 140, 80));
    draw_set_alpha(0.18);
    draw_circle(x, y, 52, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
