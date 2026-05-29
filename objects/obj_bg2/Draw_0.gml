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
// GROUND — churned mud battlefield  (y 500 to bottom)
// =========================================================
draw_set_color(make_color_rgb(28, 22, 14));
draw_rectangle(cx, hz, cx + vw, cy + vh, false);

// Mud texture strips
for (var di = 0; di < 22; di++) {
    var dstrip_x = cx + di * 105 - ((cx * 0.88) mod 105);
    draw_set_color(make_color_rgb(36 + di mod 5 * 3, 28 + di mod 4 * 2, 16 + di mod 3));
    draw_rectangle(dstrip_x, hz + 2, dstrip_x + 55 + di mod 5 * 8, hz + 6, false);
}

// Shell craters scattered along road sides
for (var cr = 0; cr < 16; cr++) {
    var crx = cx + 40 + cr * 195 - ((cx * 0.92) mod 195);
    var cry = hz + 4 + (cr mod 3) * 14;
    draw_set_color(make_color_rgb(18, 14, 8));
    draw_ellipse(crx - 24, cry - 6, crx + 24, cry + 12, false);
    draw_set_color(make_color_rgb(44, 35, 22));
    draw_ellipse(crx - 28, cry - 8, crx + 28, cry - 2, false);
}

// Roadside scrub / dead grass tufts
draw_set_alpha(0.55);
draw_set_color(make_color_rgb(55, 58, 30));
for (var g = 0; g < 24; g++) {
    var gx = cx + g * 120 - ((cx * 0.85) mod 120);
    draw_rectangle(gx, hz - 10, gx + 44, hz + 2, false);
    draw_rectangle(gx + 10, hz + 16, gx + 58, hz + 28, false);
}
draw_set_alpha(1);

// Wheel ruts on road surface
draw_set_alpha(0.50);
draw_set_color(make_color_rgb(20, 16, 10));
draw_rectangle(cx, hz + 12, cx + vw, hz + 18, false);
draw_rectangle(cx, hz + 26, cx + vw, hz + 32, false);
draw_set_alpha(1);

// Abandoned equipment — dark silhouettes on road edge
for (var eq = 0; eq < 6; eq++) {
    var eqx = cx + 280 + eq * 1380 - ((cx * 0.96) mod 1380);
    // Abandoned ammo crate
    draw_set_color(make_color_rgb(22, 26, 18));
    draw_rectangle(eqx, hz - 22, eqx + 28, hz, false);
    draw_rectangle(eqx + 2, hz - 24, eqx + 26, hz - 22, false);
    // Wire coil nearby
    draw_set_color(make_color_rgb(45, 42, 35));
    draw_circle(eqx + 44, hz - 8, 8, true);
}

// =========================================================
// BURNED-OUT WRECKS  (road-edge debris, parallax ≈ road)
// =========================================================
var wr_col = make_color_rgb(12, 9, 6);
for (var wk = 0; wk < 9; wk++) {
    var wkx = cx + 180 + wk * 870 - ((cx * 0.97) mod 870);
    // Burned chassis slab
    draw_set_color(wr_col);
    draw_rectangle(wkx - 38, hz - 10, wkx + 44, hz, false);
    // Hood wreckage
    draw_rectangle(wkx + 30, hz - 13, wkx + 56, hz, false);
    // Skeletal cab frame (left post / right post / top bar)
    draw_rectangle(wkx - 4,  hz - 28, wkx,     hz - 10, false);
    draw_rectangle(wkx + 26, hz - 28, wkx + 30, hz - 10, false);
    draw_rectangle(wkx - 4,  hz - 29, wkx + 30, hz - 26, false);
    // Charred wheel stubs
    draw_circle(wkx - 22, hz - 1, 9, false);
    draw_circle(wkx + 26, hz - 1, 9, false);
    // Burning glow under wreck
    var _wf = 0.35 + 0.50 * abs(sin(tt * 1.6 + wk * 2.1));
    draw_set_alpha(_wf * 0.60);
    draw_set_color(make_color_rgb(190, 65, 10));
    draw_rectangle(wkx - 28, hz - 8, wkx + 36, hz, false);
    draw_set_alpha(_wf * 0.35);
    draw_set_color(make_color_rgb(255, 175, 35));
    draw_rectangle(wkx - 18, hz - 5, wkx + 24, hz, false);
    draw_set_alpha(1);
    draw_set_color(wr_col);
}

// =========================================================
// EXTRACTION ZONE  (world x 7400–7700)
// =========================================================
if (11400 < cx + vw && 11700 > cx) {
    draw_set_color(make_color_rgb(220, 190, 30));
    draw_rectangle(11400, hz - 60, 11700, hz, false);
    draw_set_color(make_color_rgb(16, 12, 6));
    for (var st = 0; st < 8; st++) {
        var sx = 11400 + st * 38;
        draw_triangle(sx, hz - 60, sx + 18, hz - 60, sx, hz, false);
    }
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(16, 12, 6));
    draw_text_transformed(11550, hz - 52, "EXTRACTION", 1.35, 1.35, 0);
    draw_set_halign(fa_left);
    draw_set_color(make_color_rgb(220, 190, 30));
    for (var ar = 0; ar < 3; ar++) {
        var arx = 11420 + ar * 86;
        draw_triangle(arx, hz - 6, arx + 18, hz - 6, arx + 9, hz - 20, false);
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
