// === AVALANCHE — translucent churning snow sheet (world space) ===
var _cam_y = camera_get_view_y(view_camera[0]);

// --- Telegraph phase: snow dust trickling at the top of the view ---
if (!active) {
    var _wa = clamp((110 - warn_timer) / 110, 0, 1);
    draw_set_color(c_white);
    draw_set_alpha(0.10 + 0.14 * _wa);
    draw_rectangle(band_x, _cam_y, band_x + band_w, _cam_y + 26, false);
    // Trickle particles
    draw_set_alpha(0.35 * _wa);
    for (var _i = 0; _i < 14; _i++) {
        var _tx = band_x + ((_i * 149 + current_time * 0.05) mod band_w);
        var _ty = _cam_y + 8 + ((_i * 83 + current_time * 0.12) mod 60);
        draw_circle(_tx, _ty, 2, false);
    }
    draw_set_alpha(1);
    draw_set_color(c_white);
    exit;
}

// --- The sweep: layered translucent white band with churning lobes ---
var _t  = current_time * 0.01;
var _y1 = band_y;
var _y2 = band_y + band_h;

// Core sheet
draw_set_color(c_white);
draw_set_alpha(0.34);
draw_rectangle(band_x, _y1, band_x + band_w, _y2, false);

// Denser leading edge (bottom of the band)
draw_set_alpha(0.5);
draw_rectangle(band_x, _y2 - 44, band_x + band_w, _y2, false);

// Churning lobes along the leading edge
for (var _i = 0; _i < 12; _i++) {
    var _lx = band_x + (_i + 0.5) * (band_w / 12);
    var _lr = 20 + 12 * abs(sin(_t + _i * 1.7));
    draw_set_alpha(0.42);
    draw_circle(_lx, _y2 - 6 + 6 * sin(_t * 1.3 + _i), _lr, false);
}

// Interior swirls
draw_set_color(make_color_rgb(226, 238, 250));
for (var _i = 0; _i < 9; _i++) {
    var _sx = band_x + ((_i * 211 + current_time * 0.08) mod band_w);
    var _sy = _y1 + 30 + ((_i * 127) mod (band_h - 70));
    draw_set_alpha(0.28);
    draw_circle(_sx, _sy, 12 + (_i mod 4) * 5, false);
}

// Faint spray above the sheet
draw_set_color(c_white);
draw_set_alpha(0.14);
draw_rectangle(band_x, _y1 - 50, band_x + band_w, _y1, false);

draw_set_alpha(1);
draw_set_color(c_white);
