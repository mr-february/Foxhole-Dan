var cx  = camera_get_view_x(view_camera[0]);
var cy  = camera_get_view_y(view_camera[0]);
var vw  = camera_get_view_width(view_camera[0]);
var vh  = camera_get_view_height(view_camera[0]);
var hz  = 500;   // road/platform y
var tt  = current_time * 0.001;

// =========================================================
// SKY — heavy overcast, storm-lit from artillery below
// =========================================================
// Base gradient: near-black at top to dirty orange-grey at horizon
for (var si = 0; si < 16; si++) {
    var sf = si / 16.0;
    draw_set_color(make_color_rgb(
        round(lerp(18,  90, sf)),
        round(lerp(16,  68, sf)),
        round(lerp(18,  48, sf))
    ));
    draw_rectangle(cx, cy + sf * (hz - cy), cx + vw, cy + (sf + 1/16.0) * (hz - cy), false);
}

// Storm cloud layers — rolling dark masses (parallax 0.08, 0.18)
var cloud_cols = [
    make_color_rgb(32, 28, 26),
    make_color_rgb(42, 36, 30),
    make_color_rgb(26, 22, 20),
];
for (var cl = 0; cl < 2; cl++) {
    var cp = cx * (0.08 + cl * 0.10);
    var cw = 320 + cl * 80;
    var cy_base = cy + (cl == 0 ? 30 : 80);
    for (var ci = 0; ci < 14; ci++) {
        var cbx = cx + ci * cw - (cp mod cw);
        var ch  = 60 + (ci * 53 + cl * 37) mod 70;
        draw_set_color(cloud_cols[cl mod 3]);
        draw_ellipse(cbx - 20, cy_base, cbx + cw * 0.55, cy_base + ch, false);
        draw_ellipse(cbx + cw * 0.3, cy_base + 15, cbx + cw * 0.9, cy_base + ch * 0.8, false);
        // Cloud highlight (artillery glow from below)
        draw_set_alpha(0.12 + 0.10 * abs(sin(tt * 0.7 + ci * 1.3)));
        draw_set_color(make_color_rgb(200, 120, 40));
        draw_ellipse(cbx + cw * 0.1, cy_base + ch * 0.6, cbx + cw * 0.8, cy_base + ch, false);
        draw_set_alpha(1);
    }
}

// Artillery horizon glow — wide orange band under clouds
var hglow = 0.5 + 0.5 * abs(sin(tt * 0.9)) * abs(sin(tt * 0.63));
draw_set_alpha(hglow * 0.65);
draw_set_color(make_color_rgb(220, 90, 15));
draw_rectangle(cx, hz - 100, cx + vw, hz, false);
draw_set_alpha(hglow * 0.45);
draw_set_color(make_color_rgb(255, 170, 40));
draw_rectangle(cx, hz - 50, cx + vw, hz, false);
draw_set_alpha(1);

// Random artillery flashes on horizon
if (irandom(80) == 0) {
    var flx = cx + irandom(vw);
    draw_set_alpha(0.6 + random(0.35));
    draw_set_color(make_color_rgb(255, 240, 160));
    draw_ellipse(flx - 70, hz - 80, flx + 70, hz, false);
    draw_set_alpha(1);
}

// =========================================================
// FAR RUINS / BOMBED VILLAGE  (parallax 0.10)
// =========================================================
var p0 = cx * 0.10;
draw_set_color(make_color_rgb(28, 22, 16));
for (var ri = 0; ri < 20; ri++) {
    var rx  = cx + ri * 430 - (p0 mod 430);
    var rh1 = 55 + (ri * 67 + 11) mod 80;
    var rh2 = 40 + (ri * 89 + 33) mod 60;
    var rw  = 50 + (ri * 43 + 17) mod 40;
    // Main ruined wall
    draw_rectangle(rx, hz - rh1, rx + rw, hz, false);
    draw_rectangle(rx + rw + 20, hz - rh2, rx + rw + 20 + rw * 0.7, hz, false);
    // Jagged broken tops
    draw_set_color(make_color_rgb(20, 16, 12));
    draw_triangle(rx + rw - 10, hz - rh1, rx + rw + 8, hz - rh1, rx + rw, hz - rh1 + 18, false);
    draw_triangle(rx + 4, hz - rh1, rx + 22, hz - rh1, rx + 12, hz - rh1 - 14, false);
    // Fire inside ruin
    var rf = 0.5 + 0.4 * abs(sin(tt * 2.8 + ri * 1.9));
    draw_set_alpha(rf * 0.75);
    draw_set_color(make_color_rgb(230, 100, 15));
    draw_rectangle(rx + 8, hz - rh1 + 20, rx + rw - 8, hz, false);
    draw_set_alpha(rf * 0.5);
    draw_set_color(make_color_rgb(255, 200, 60));
    draw_rectangle(rx + 14, hz - rh1 + 28, rx + rw - 14, hz, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(28, 22, 16));
}

// =========================================================
// ROLLING HILLS  (parallax 0.18 — behind treeline, in front of ruins)
// =========================================================
var p_hi = cx * 0.18;
for (var hi = 0; hi < 10; hi++) {
    var hx  = cx + hi * 640 - (p_hi mod 640);
    var hh  = 55 + (hi * 67 + 13) mod 55;
    var hw  = 300 + (hi * 53 + 29) mod 140;
    draw_set_color(make_color_rgb(22, 30, 14));
    draw_ellipse(hx - hw/2, hz - hh, hx + hw/2, hz, false);
    // Artillery glow along ridgeline
    var _hg = 0.09 + 0.07 * abs(sin(tt * 0.55 + hi * 0.8));
    draw_set_alpha(_hg);
    draw_set_color(make_color_rgb(200, 70, 12));
    draw_ellipse(hx - hw/3, hz - 14, hx + hw/3, hz + 4, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(22, 30, 14));
}

// =========================================================
// TREELINE — scarred pines  (parallax 0.28)
// =========================================================
var p1 = cx * 0.28;
for (var tr = 0; tr < 30; tr++) {
    var tx  = cx + tr * 200 - (p1 mod 200);
    var th  = 60 + (tr * 47) mod 40;
    var tw  = 10 + (tr * 19) mod 10;
    var damaged = (tr mod 5 == 0);   // some trees are blasted stumps

    if (damaged) {
        // Broken stump — just bottom third
        draw_set_color(make_color_rgb(38, 28, 18));
        draw_rectangle(tx + tw - 4, hz - th * 0.35, tx + tw + 4, hz, false);
        // Splinter top
        draw_triangle(tx + tw - 4, hz - th * 0.35, tx + tw + 4, hz - th * 0.35, tx + tw, hz - th * 0.35 - 14, false);
    } else {
        // Full pine, slightly dead/grey-green
        var tc = make_color_rgb(28 + (tr mod 4)*4, 45 + (tr mod 3)*6, 22);
        draw_set_color(tc);
        draw_triangle(tx + tw, hz - th, tx, hz - th * 0.25, tx + tw * 2, hz - th * 0.25, false);
        draw_triangle(tx + tw, hz - th * 0.82, tx - 3, hz - th * 0.28, tx + tw * 2 + 3, hz - th * 0.28, false);
        // Trunk
        draw_set_color(make_color_rgb(42, 32, 20));
        draw_rectangle(tx + tw - 3, hz - th * 0.26, tx + tw + 3, hz, false);
    }
}

// =========================================================
// SMOKE COLUMNS from burning trees / village
// =========================================================
for (var sc = 0; sc < 10; sc++) {
    var scx = cx + 80 + sc * 185 - (cx * 0.22 mod 185);
    for (var sm = 0; sm < 6; sm++) {
        var smf = ((tt * 0.22 + sm * 0.16 + sc * 0.21) mod 1.0);
        var smy = hz - smf * 320;
        if (smy < cy || smy > hz) continue;
        draw_set_alpha(0.25 * (1 - smf));
        draw_set_color(make_color_rgb(30, 26, 22));
        draw_circle(scx + sin(smf * 6 + sm + sc) * 12, smy, 7 + smf * 24, false);
    }
}
draw_set_alpha(1);

// =========================================================
// TERRAIN — rolling hills (ground fill + surface details)
// =========================================================
var first_seg = max(0,  floor(cx / 200) - 1);
var last_seg  = min(59, ceil((cx + vw) / 200) + 1);
var bot       = cy + vh + 10;

// --- Terrain fill (churned mud) ---
draw_set_color(make_color_rgb(28, 22, 14));
draw_primitive_begin(pr_trianglelist);
for (var _si = first_seg; _si < last_seg; _si++) {
    var _x1 = _si * 200;
    var _y1 = global.terrain_y[_si];
    var _x2 = (_si + 1) * 200;
    var _y2 = global.terrain_y[_si + 1];
    draw_vertex(_x1, _y1);  draw_vertex(_x2, _y2);  draw_vertex(_x1, bot);
    draw_vertex(_x2, _y2);  draw_vertex(_x2, bot);   draw_vertex(_x1, bot);
}
draw_primitive_end();

// --- Surface edge (dark lip along hillsides) ---
draw_set_color(make_color_rgb(18, 13, 7));
draw_set_alpha(0.85);
for (var _si = first_seg; _si < last_seg; _si++) {
    draw_line_width(_si * 200, global.terrain_y[_si],
                    (_si + 1) * 200, global.terrain_y[_si + 1], 5);
}
draw_set_alpha(1);

// --- Mud texture strips (follow terrain) ---
for (var di = 0; di < 22; di++) {
    var _mx  = cx + di * 105 - ((cx * 0.88) mod 105);
    var _ms  = clamp(floor(_mx / 200), 0, 59);
    var _my  = lerp(global.terrain_y[_ms], global.terrain_y[_ms + 1], (_mx - _ms * 200) / 200.0);
    draw_set_color(make_color_rgb(36 + di mod 5 * 3, 28 + di mod 4 * 2, 16 + di mod 3));
    draw_rectangle(_mx, _my + 2, _mx + 55 + di mod 5 * 8, _my + 6, false);
}

// --- Shell craters (follow terrain) ---
for (var cr = 0; cr < 16; cr++) {
    var _crx = cx + 40 + cr * 195 - ((cx * 0.92) mod 195);
    var _crs = clamp(floor(_crx / 200), 0, 59);
    var _cry = lerp(global.terrain_y[_crs], global.terrain_y[_crs + 1], (_crx - _crs * 200) / 200.0) + 4 + (cr mod 3) * 6;
    draw_set_color(make_color_rgb(18, 14, 8));
    draw_ellipse(_crx - 22, _cry - 5, _crx + 22, _cry + 10, false);
    draw_set_color(make_color_rgb(44, 35, 22));
    draw_ellipse(_crx - 26, _cry - 7, _crx + 26, _cry - 1, false);
}

// --- Dead grass tufts on hillsides ---
draw_set_alpha(0.55);
draw_set_color(make_color_rgb(55, 58, 30));
for (var g = 0; g < 24; g++) {
    var _gx = cx + g * 120 - ((cx * 0.85) mod 120);
    var _gs = clamp(floor(_gx / 200), 0, 59);
    var _gy = lerp(global.terrain_y[_gs], global.terrain_y[_gs + 1], (_gx - _gs * 200) / 200.0);
    draw_rectangle(_gx, _gy - 10, _gx + 44, _gy + 2, false);
    draw_rectangle(_gx + 10, _gy + 8, _gx + 58, _gy + 20, false);
}
draw_set_alpha(1);

// --- Wheel ruts (two parallel tracks following terrain slope) ---
draw_set_alpha(0.45);
draw_set_color(make_color_rgb(20, 16, 10));
for (var _si = first_seg; _si < last_seg; _si++) {
    var _rx1 = _si * 200;       var _ry1 = global.terrain_y[_si] + 10;
    var _rx2 = (_si + 1) * 200; var _ry2 = global.terrain_y[_si + 1] + 10;
    draw_line_width(_rx1, _ry1,      _rx2, _ry2,      4);
    draw_line_width(_rx1, _ry1 + 16, _rx2, _ry2 + 16, 4);
}
draw_set_alpha(1);

// --- Abandoned equipment (follow terrain) ---
for (var eq = 0; eq < 6; eq++) {
    var _eqx = cx + 280 + eq * 1380 - ((cx * 0.96) mod 1380);
    var _eqs = clamp(floor(_eqx / 200), 0, 59);
    var _eqy = lerp(global.terrain_y[_eqs], global.terrain_y[_eqs + 1], (_eqx - _eqs * 200) / 200.0);
    draw_set_color(make_color_rgb(22, 26, 18));
    draw_rectangle(_eqx,     _eqy - 22, _eqx + 28, _eqy, false);
    draw_rectangle(_eqx + 2, _eqy - 24, _eqx + 26, _eqy - 22, false);
    draw_set_color(make_color_rgb(45, 42, 35));
    draw_circle(_eqx + 44, _eqy - 8, 8, true);
}

// --- Burned-out wrecks (follow terrain) ---
var wr_col = make_color_rgb(12, 9, 6);
for (var wk = 0; wk < 9; wk++) {
    var _wkx = cx + 180 + wk * 870 - ((cx * 0.97) mod 870);
    var _wks = clamp(floor(_wkx / 200), 0, 59);
    var _wky = lerp(global.terrain_y[_wks], global.terrain_y[_wks + 1], (_wkx - _wks * 200) / 200.0);
    draw_set_color(wr_col);
    draw_rectangle(_wkx - 38, _wky - 10, _wkx + 44, _wky, false);
    draw_rectangle(_wkx + 30, _wky - 13, _wkx + 56, _wky, false);
    draw_rectangle(_wkx - 4,  _wky - 28, _wkx,      _wky - 10, false);
    draw_rectangle(_wkx + 26, _wky - 28, _wkx + 30, _wky - 10, false);
    draw_rectangle(_wkx - 4,  _wky - 29, _wkx + 30, _wky - 26, false);
    draw_circle(_wkx - 22, _wky - 1, 9, false);
    draw_circle(_wkx + 26, _wky - 1, 9, false);
    var _wf = 0.35 + 0.50 * abs(sin(tt * 1.6 + wk * 2.1));
    draw_set_alpha(_wf * 0.60);
    draw_set_color(make_color_rgb(190, 65, 10));
    draw_rectangle(_wkx - 28, _wky - 8, _wkx + 36, _wky, false);
    draw_set_alpha(_wf * 0.35);
    draw_set_color(make_color_rgb(255, 175, 35));
    draw_rectangle(_wkx - 18, _wky - 5, _wkx + 24, _wky, false);
    draw_set_alpha(1);
    draw_set_color(wr_col);
}

// --- EXTRACTION ZONE (world x 11400–11700, terrain-relative) ---
if (11400 < cx + vw && 11700 > cx) {
    var _ezs = clamp(floor(11550 / 200), 0, 59);
    var _ezy = lerp(global.terrain_y[_ezs], global.terrain_y[_ezs + 1], (11550 - _ezs * 200) / 200.0);
    draw_set_color(make_color_rgb(220, 190, 30));
    draw_rectangle(11400, _ezy - 60, 11700, _ezy, false);
    draw_set_color(make_color_rgb(16, 12, 6));
    for (var st = 0; st < 8; st++) {
        var sx = 11400 + st * 38;
        draw_triangle(sx, _ezy - 60, sx + 18, _ezy - 60, sx, _ezy, false);
    }
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(16, 12, 6));
    draw_text_transformed(11550, _ezy - 52, "EXTRACTION", 1.35, 1.35, 0);
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(220, 190, 30));
    for (var ar = 0; ar < 3; ar++) {
        var arx = 11420 + ar * 86;
        draw_triangle(arx, _ezy - 6, arx + 18, _ezy - 6, arx + 9, _ezy - 20, false);
    }
}

// =========================================================
// WAR HAZE
// =========================================================
draw_set_alpha(0.09);
draw_set_color(make_color_rgb(90, 65, 30));
draw_rectangle(cx, cy, cx + vw, cy + vh, false);
draw_set_alpha(1);

draw_set_color(c_white);
