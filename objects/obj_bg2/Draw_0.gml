var cx  = camera_get_view_x(view_camera[0]);
var cy  = camera_get_view_y(view_camera[0]);
var vw  = camera_get_view_width(view_camera[0]);
var vh  = camera_get_view_height(view_camera[0]);
var hz  = 500;   // horizon / road surface y

// === SKY — overcast European war sky ===
for (var si = 0; si < 10; si++) {
    var t = si / 10;
    draw_set_color(make_color_rgb(
        round(lerp(105, 158, t)),
        round(lerp(112, 162, t)),
        round(lerp(128, 172, t))
    ));
    draw_rectangle(cx, cy + t * (hz - cy), cx + vw, cy + (t + 0.1) * (hz - cy), false);
}
// Overcast haze
draw_set_alpha(0.25);
draw_set_color(make_color_rgb(188, 178, 155));
draw_rectangle(cx, cy, cx + vw, hz, false);
draw_set_alpha(1);

// === DISTANT HILLS (parallax 0.15x) ===
var p1 = cx * 0.15;
draw_set_color(make_color_rgb(78, 98, 62));
for (var h = 0; h < 10; h++) {
    var hx    = cx + (h * 700 - p1 mod 700);
    var hw    = 380 + (h * 71) mod 200;
    var hh    = 55  + (h * 43) mod 45;
    draw_ellipse(hx, hz - hh, hx + hw, hz, false);
}

// === BACKGROUND TREES (parallax 0.3x) ===
var p2 = cx * 0.30;
draw_set_color(make_color_rgb(48, 68, 32));
for (var tr = 0; tr < 24; tr++) {
    var tx  = cx + (tr * 260 - p2 mod 260);
    var th  = 65 + (tr * 47) mod 40;
    var tw  = 14 + (tr * 19) mod 12;
    draw_triangle(tx + tw, hz - th,      tx, hz - 20, tx + tw * 2, hz - 20, false);
    draw_triangle(tx + tw, hz - th - 18, tx + 4, hz - th + 8, tx + tw * 2 - 4, hz - th + 8, false);
    // Trunks
    draw_set_color(make_color_rgb(55, 42, 28));
    draw_rectangle(tx + tw - 3, hz - 20, tx + tw + 3, hz, false);
    draw_set_color(make_color_rgb(48, 68, 32));
}

// === ROAD SURFACE ===
draw_set_color(make_color_rgb(86, 76, 58));
draw_rectangle(cx, hz, cx + vw, cy + vh, false);
// Road edge / shoulder
draw_set_color(make_color_rgb(68, 58, 42));
draw_rectangle(cx, hz, cx + vw, hz + 5, false);
// Wheel ruts
draw_set_alpha(0.45);
draw_set_color(make_color_rgb(60, 52, 38));
draw_rectangle(cx, hz + 14, cx + vw, hz + 20, false);
draw_rectangle(cx, hz + 28, cx + vw, hz + 34, false);
draw_set_alpha(1);
// Roadside grass strips
draw_set_alpha(0.6);
draw_set_color(make_color_rgb(68, 92, 44));
for (var g = 0; g < 18; g++) {
    var gx = cx + (g * 140 - (cx * 0.85) mod 140);
    draw_rectangle(gx, hz - 12, gx + 55, hz + 3, false);
    draw_rectangle(gx + 10, hz + 36, gx + 65, hz + 50, false);
}
draw_set_alpha(1);

// === EXTRACTION ZONE (world x=7400–7700) ===
if (7400 < cx + vw && 7700 > cx) {
    // Yellow landing zone panel
    draw_set_color(make_color_rgb(240, 210, 40));
    draw_rectangle(7400, hz - 70, 7700, hz, false);
    // Alternating black diagonal stripes
    draw_set_color(make_color_rgb(20, 16, 8));
    for (var st = 0; st < 8; st++) {
        var sx = 7400 + st * 40;
        draw_triangle(sx, hz - 70, sx + 20, hz - 70, sx, hz, false);
    }
    // LZ text
    draw_set_color(make_color_rgb(20, 16, 8));
    draw_set_halign(fa_center);
    draw_text_transformed(7550, hz - 62, "EXTRACTION", 1.4, 1.4, 0);
    draw_set_halign(fa_left);
    // Arrow markers
    draw_set_color(make_color_rgb(240, 210, 40));
    for (var ar = 0; ar < 3; ar++) {
        var arx = 7420 + ar * 90;
        draw_triangle(arx, hz - 8, arx + 20, hz - 8, arx + 10, hz - 22, false);
    }
}

// === WAR HAZE / FOG ===
draw_set_alpha(0.06);
draw_set_color(make_color_rgb(165, 150, 122));
draw_rectangle(cx, cy, cx + vw, cy + vh, false);
draw_set_alpha(1);
