// === WIND STREAKS — faint horizontal lines streaming through the zone ===
if (gust_pct <= 0.02) exit;

// Only draw the part of the zone that's near the camera (cheap cull)
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
if (y > _cam_y + _cam_h + 60 || y + zone_h < _cam_y - 60) exit;

var _t = current_time * (0.35 + 0.25 * gust_pct);

draw_set_color(make_color_rgb(215, 230, 245));
for (var _i = 0; _i < 26; _i++) {
    var _len = 46 + (_i mod 5) * 16;
    var _sy  = y + ((_i * 157) mod zone_h);
    // Streaks travel in wind_dir; wrap within the zone width
    var _off = (_t + _i * 211) mod (zone_w + _len);
    var _sx  = (wind_dir > 0) ? (x - _len + _off) : (x + zone_w - _off);
    var _x1  = clamp(_sx, x, x + zone_w);
    var _x2  = clamp(_sx + wind_dir * _len, x, x + zone_w);
    if (_x1 == _x2) continue;
    draw_set_alpha((0.06 + (_i mod 4) * 0.03) * gust_pct);
    // Slight sag in the middle of each streak
    var _my = _sy + 3 * sin(_t * 0.01 + _i);
    draw_line_width(_x1, _sy, (_x1 + _x2) * 0.5, _my, 1);
    draw_line_width((_x1 + _x2) * 0.5, _my, _x2, _sy, 1);
}

// A few snow motes carried sideways
draw_set_color(c_white);
for (var _i = 0; _i < 10; _i++) {
    var _px  = x + ((_t * 1.4 + _i * 331) mod zone_w);
    if (wind_dir < 0) _px = x + zone_w - (_px - x);
    var _py  = y + ((_i * 199 + _t * 0.15) mod zone_h);
    draw_set_alpha(0.18 * gust_pct);
    draw_circle(_px, _py, 1.5, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
