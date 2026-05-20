// ============================================================
// MAP BACKGROUND — drawn at depth 10 so it's behind all units
// ============================================================

// Grass
draw_set_color(make_color_rgb(28, 72, 28));
draw_rectangle(0, 0, room_width, room_height, false);

// Roads (horizontal + vertical from edges to house)
draw_set_color(make_color_rgb(68, 68, 75));
draw_rectangle(0,    354, room_width, 406, false);  // horizontal
draw_rectangle(934,  0,   986, room_height, false); // vertical

// Road centre lines (dashed amber)
draw_set_color(make_color_rgb(200, 185, 40));
for (var _rx = 0; _rx < room_width; _rx += 48) {
    if (_rx < 910 || _rx > 1010) {
        draw_rectangle(_rx, 377, _rx + 24, 383, false);
    }
}
for (var _ry = 0; _ry < room_height; _ry += 48) {
    if (_ry < 340 || _ry > 420) {
        draw_rectangle(957, _ry, 963, _ry + 24, false);
    }
}

// Yard (lighter lawn around the house)
draw_set_color(make_color_rgb(40, 100, 40));
draw_rectangle(692, 212, 1228, 548, false);

// Fence (with gaps where roads cross)
draw_set_color(make_color_rgb(158, 133, 88));
draw_rectangle(692, 212, 1228, 218, false);
draw_rectangle(692, 542, 1228, 548, false);
draw_rectangle(692, 212, 698, 548, false);
draw_rectangle(1222, 212, 1228, 548, false);
// Gate openings — paint lawn colour over fence where road passes
draw_set_color(make_color_rgb(40, 100, 40));
draw_rectangle(692, 354, 698, 406, false);
draw_rectangle(1222, 354, 1228, 406, false);
draw_rectangle(934, 212, 986, 218, false);
draw_rectangle(934, 542, 986, 548, false);

// Corner trees (top-down: overlapping circles)
var _trees = [[718,236],[756,228],[1172,236],[1202,230],[714,524],[750,530],[1170,522],[1206,530]];
for (var _ti = 0; _ti < 8; _ti++) {
    var _tx = _trees[_ti][0];
    var _ty = _trees[_ti][1];
    draw_set_color(make_color_rgb(18, 55, 18));
    draw_circle(_tx, _ty, 26, false);
    draw_set_color(make_color_rgb(28, 76, 28));
    draw_circle(_tx + 6, _ty - 4, 18, false);
}

// ============================================================
// HOUSE (top-down, centred on x=960 y=380)
// ============================================================
// Drop shadow
draw_set_color(make_color_rgb(15, 15, 15));
draw_set_alpha(0.35);
draw_rectangle(884, 318, 1048, 462, false);
draw_set_alpha(1);

// Walls
draw_set_color(make_color_rgb(205, 188, 165));
draw_rectangle(878, 310, 1042, 452, false);

// Roof (dominant in top-down view)
draw_set_color(make_color_rgb(138, 62, 42));
draw_rectangle(876, 308, 1044, 338, false);  // north face
draw_rectangle(876, 422, 1044, 454, false);  // south face
draw_rectangle(876, 308, 906, 454, false);   // west face
draw_rectangle(1014, 308, 1044, 454, false); // east face
draw_set_color(make_color_rgb(112, 50, 33)); // ridge line
draw_rectangle(958, 308, 962, 454, false);
// Chimney
draw_set_color(make_color_rgb(96, 85, 74));
draw_rectangle(998, 316, 1022, 340, false);
draw_set_color(make_color_rgb(75, 65, 56));
draw_rectangle(998, 308, 1022, 318, false);

// Windows (lit warm yellow)
draw_set_color(make_color_rgb(200, 208, 255));
draw_rectangle(910, 328, 944, 356, false);
draw_rectangle(1014, 328, 1038, 356, false);
draw_set_color(make_color_rgb(240, 220, 160));
draw_set_alpha(0.18);
draw_rectangle(910, 328, 944, 356, false);
draw_rectangle(1014, 328, 1038, 356, false);
draw_set_alpha(1);

// Door
draw_set_color(make_color_rgb(88, 60, 38));
draw_rectangle(944, 416, 976, 454, false);
draw_set_color(make_color_rgb(200, 148, 48));
draw_circle(972, 432, 3, false);

// ============================================================
// HOUSE HP BAR (above the house)
// ============================================================
var _pct = hp / max_hp;
var _bx  = 848;
var _by  = 290;
draw_set_color(make_color_rgb(30, 30, 30));
draw_rectangle(_bx, _by, _bx + 224, _by + 14, false);
draw_set_color(make_color_rgb(40 + 180 * (1 - _pct), 180 * _pct, 40));
draw_rectangle(_bx, _by, _bx + 224 * _pct, _by + 14, false);
draw_set_color(c_white);
draw_rectangle(_bx, _by, _bx + 224, _by + 14, true);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(960, _by - 15, "HOME  " + string(floor(hp)) + " / " + string(max_hp), 0.82, 0.82, 0);
draw_set_halign(fa_left);
draw_set_color(c_white);
