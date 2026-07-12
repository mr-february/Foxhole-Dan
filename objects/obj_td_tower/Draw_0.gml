if (tower_type == 0) {
    // MG Nest — sandbag ring + gun barrel
    draw_set_color(make_color_rgb(140, 115, 72));
    draw_circle(x, y, 16, false);
    draw_set_color(make_color_rgb(110, 88, 55));
    draw_circle(x, y, 16, true);
    // Gun barrel — recoils back while firing
    var _blen = 20 - fire_flash * 0.7;
    var _bx2 = x + lengthdir_x(_blen, aim_dir);
    var _by2 = y + lengthdir_y(_blen, aim_dir);
    draw_set_color(make_color_rgb(60, 60, 60));
    draw_line_width(x, y, _bx2, _by2, 4);
    // Muzzle flash
    if (fire_flash > 0) {
        var _mfa = fire_flash / 8.0;
        draw_set_alpha(0.85 * _mfa);
        draw_set_color(make_color_rgb(255, 230, 110));
        draw_circle(_bx2 + lengthdir_x(4, aim_dir), _by2 + lengthdir_y(4, aim_dir), 3 + (8 - fire_flash) * 0.6, false);
        draw_set_alpha(0.40 * _mfa);
        draw_set_color(c_white);
        draw_circle(_bx2 + lengthdir_x(5, aim_dir), _by2 + lengthdir_y(5, aim_dir), 6 + (8 - fire_flash) * 0.8, false);
        draw_set_alpha(1);
    }
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
    // Gun barrel (wider) — recoils on fire
    var _alen = 28 - fire_flash * 1.1;
    var _bx2 = x + lengthdir_x(_alen, aim_dir);
    var _by2 = y + lengthdir_y(_alen, aim_dir);
    draw_set_color(make_color_rgb(45, 45, 52));
    draw_line_width(x, y, _bx2, _by2, 7);
    // Muzzle
    draw_set_color(make_color_rgb(70, 70, 80));
    draw_circle(_bx2, _by2, 4, false);
    // Firing blast — smoke ring + flame cone
    if (fire_flash > 0) {
        var _afa  = fire_flash / 8.0;
        var _grow = (8 - fire_flash);
        draw_set_alpha(0.75 * _afa);
        draw_set_color(make_color_rgb(255, 170, 50));
        draw_circle(_bx2 + lengthdir_x(6, aim_dir), _by2 + lengthdir_y(6, aim_dir), 4 + _grow * 1.1, false);
        draw_set_alpha(0.35 * _afa);
        draw_set_color(make_color_rgb(180, 170, 160));
        draw_circle(_bx2 + lengthdir_x(8, aim_dir), _by2 + lengthdir_y(8, aim_dir), 8 + _grow * 1.6, true);
        draw_circle(_bx2 + lengthdir_x(8, aim_dir), _by2 + lengthdir_y(8, aim_dir), 10 + _grow * 1.8, true);
        draw_set_alpha(1);
    }
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
