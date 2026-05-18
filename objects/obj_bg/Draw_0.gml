var cx  = camera_get_view_x(view_camera[0]);
var vw  = camera_get_view_width(view_camera[0]);
var sky = 500;
var tt  = current_time * 0.001;

// =========================================================
// SKY GRADIENT — visible dark blue to warm dusk
// =========================================================
var sky_bands = 14;
for (var i = 0; i < sky_bands; i++) {
    var sf = i / sky_bands;
    draw_set_color(make_color_rgb(round(lerp(30, 75, sf)), round(lerp(35, 60, sf)), round(lerp(70, 70, sf))));
    var by1 = i * (sky / sky_bands);
    var by2 = (i + 1) * (sky / sky_bands);
    draw_rectangle(cx, by1, cx + vw, by2, false);
}

// =========================================================
// ARTILLERY HORIZON GLOW
// =========================================================
var gp = 0.55 + 0.45 * abs(sin(tt * 1.1)) * abs(sin(tt * 0.73));
draw_set_alpha(gp * 0.7);
draw_set_color(make_color_rgb(210, 90, 20));
draw_rectangle(cx, sky - 80, cx + vw, sky, false);
draw_set_alpha(gp * 0.5);
draw_set_color(make_color_rgb(230, 140, 40));
draw_rectangle(cx, sky - 40, cx + vw, sky, false);
draw_set_alpha(1);

// Random artillery flash
if (irandom(90) == 0) {
    var flx = cx + irandom(vw);
    draw_set_alpha(0.5 + random(0.4));
    draw_set_color(make_color_rgb(255, 230, 130));
    draw_ellipse(flx - 90, sky - 90, flx + 90, sky, false);
    draw_set_alpha(1);
}

// =========================================================
// MOON
// =========================================================
var moon_x = cx + 160 - cx * 0.015;
draw_set_color(make_color_rgb(240, 235, 200));
draw_circle(moon_x, 68, 36, false);
draw_set_color(make_color_rgb(30, 35, 70));
draw_circle(moon_x + 18, 54, 34, false);

// =========================================================
// STARS
// =========================================================
for (var s = 0; s < 45; s++) {
    var sx = cx + ((s * 61 + floor(cx * 0.03)) mod vw);
    var sy = 10 + (s * 83) mod 290;
    draw_set_alpha(0.3 + 0.5 * abs(sin(tt * (0.8 + s * 0.07))));
    draw_set_color(make_color_rgb(210 + s mod 40, 215 + s mod 35, 230 + s mod 20));
    draw_point(sx, sy);
    if (s mod 7 == 0) { draw_point(sx + 1, sy); draw_point(sx, sy + 1); }
}
draw_set_alpha(1);

// =========================================================
// FAR RUINS  (parallax 0.12) — visible mid-grey against sky
// =========================================================
var cw1 = 420;
var p1  = cx * 0.12;
var cs1 = floor(p1 / cw1) - 1;
for (var c = cs1; c <= cs1 + ceil(vw / cw1) + 2; c++) {
    var bx = cx + c * cw1 - p1;
    var h1 = 90  + abs(c * 73  + 11) mod 140;
    var h2 = 120 + abs(c * 107 + 43) mod 100;
    var h3 = 80  + abs(c * 89  + 67) mod 130;
    draw_set_color(make_color_rgb(35, 38, 44));
    draw_rectangle(bx,       sky - h1, bx + 68,  sky, false);
    draw_rectangle(bx + 88,  sky - h2, bx + 205, sky, false);
    draw_rectangle(bx + 228, sky - h3, bx + 335, sky, false);
    // Jagged broken tops
    draw_rectangle(bx + 5,   sky - h1 - 16, bx + 25,  sky - h1, false);
    draw_rectangle(bx + 100, sky - h2 - 20, bx + 128, sky - h2, false);
    // Lit windows
    var wf = 0.45 + 0.55 * abs(sin(tt * 2.3 + c * 1.7));
    draw_set_alpha(wf);
    draw_set_color(make_color_rgb(220, 130, 30));
    draw_rectangle(bx + 12, sky - h1 + 22, bx + 27, sky - h1 + 38, false);
    draw_rectangle(bx + 44, sky - h1 + 22, bx + 59, sky - h1 + 38, false);
    draw_rectangle(bx + 95, sky - h2 + 18, bx + 110, sky - h2 + 34, false);
    draw_set_alpha(1);
}

// =========================================================
// MID RUINS  (parallax 0.32) — darker but clearly visible
// =========================================================
var cw2 = 340;
var p2  = cx * 0.32;
var cs2 = floor(p2 / cw2) - 1;
for (var c2 = cs2; c2 <= cs2 + ceil(vw / cw2) + 2; c2++) {
    var bx2 = cx + c2 * cw2 - p2;
    var h4 = 65 + abs(c2 * 83  + 29) mod 80;
    var h5 = 55 + abs(c2 * 131 + 53) mod 60;
    draw_set_color(make_color_rgb(28, 32, 26));
    draw_rectangle(bx2,      sky - h4, bx2 + 58,  sky, false);
    draw_rectangle(bx2 + 80, sky - h5, bx2 + 175, sky, false);
    draw_rectangle(bx2 + 16, sky - h4 - 15, bx2 + 40, sky - h4, false);
    // Fire
    var fx  = bx2 + 30;
    var ffy = sky - h4;
    var ff  = 0.55 + 0.45 * abs(sin(tt * 3.1 + c2 * 2.3));
    draw_set_alpha(ff);
    draw_set_color(make_color_rgb(230, 100, 10));
    draw_ellipse(fx - 9, ffy - 14, fx + 9, ffy, false);
    draw_set_alpha(ff * 0.8);
    draw_set_color(make_color_rgb(255, 210, 70));
    draw_ellipse(fx - 5, ffy - 9, fx + 5, ffy, false);
    draw_set_alpha(1);
    // Smoke
    for (var sm = 0; sm < 4; sm++) {
        var smf = ((tt * 0.4 + sm * 0.25 + c2 * 0.17) mod 1.0);
        draw_set_alpha(0.28 * (1 - smf));
        draw_set_color(make_color_rgb(70, 65, 60));
        draw_circle(fx + sin(smf * 8 + sm) * 6, ffy - smf * 90, 4 + smf * 16, false);
    }
    draw_set_alpha(1);
}

// =========================================================
// HORIZON HAZE
// =========================================================
draw_set_alpha(0.35);
draw_set_color(make_color_rgb(80, 80, 35));
draw_rectangle(cx, sky - 50, cx + vw, sky, false);
draw_set_alpha(0.2);
draw_set_color(make_color_rgb(100, 70, 25));
draw_rectangle(cx, sky - 25, cx + vw, sky, false);
draw_set_alpha(1);

// =========================================================
// GROUND — visible dark brown
// =========================================================
draw_set_color(make_color_rgb(35, 26, 16));
draw_rectangle(cx, sky, cx + vw, 768, false);
// Dirt texture
var cw3 = 180;
var p3  = cx * 0.8;
var cs3 = floor(p3 / cw3) - 1;
for (var c3 = cs3; c3 <= cs3 + ceil(vw / cw3) + 2; c3++) {
    var dx = cx + c3 * cw3 - p3;
    draw_set_color(make_color_rgb(45 + (c3 mod 4)*4, 32 + (c3 mod 5)*3, 20));
    draw_rectangle(dx, sky + 3, dx + 90 + (c3 mod 5) * 18, sky + 7 + (c3 mod 4), false);
}

// =========================================================
// FOREGROUND — barbed wire + rubble  (parallax 1.4)
// =========================================================
var cw4 = 500;
var p4  = cx * 1.4;
var cs4 = floor(p4 / cw4) - 1;
draw_set_color(make_color_rgb(15, 12, 9));
for (var c4 = cs4; c4 <= cs4 + ceil(vw / cw4) + 2; c4++) {
    var fx4 = cx + c4 * cw4 - p4;
    // Wire posts
    draw_rectangle(fx4 + 20,  sky + 4, fx4 + 24,  sky + 32, false);
    draw_rectangle(fx4 + 225, sky + 4, fx4 + 229, sky + 32, false);
    draw_rectangle(fx4 + 425, sky + 4, fx4 + 429, sky + 32, false);
    // Wire lines
    draw_line_width(fx4,       sky + 16, fx4 + 245, sky + 12, 1);
    draw_line_width(fx4,       sky + 24, fx4 + 245, sky + 20, 1);
    draw_line_width(fx4 + 205, sky + 12, fx4 + 445, sky + 16, 1);
    draw_line_width(fx4 + 205, sky + 20, fx4 + 445, sky + 24, 1);
    // Rubble
    draw_ellipse(fx4 + 100, sky + 10, fx4 + 160, sky + 34, false);
    draw_ellipse(fx4 + 320, sky + 8,  fx4 + 385, sky + 30, false);
}

draw_set_color(c_white);
