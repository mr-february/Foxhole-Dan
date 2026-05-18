var f = image_xscale;  // 1=right, -1=left

// Hit flash overlay (drawn at end, but set up blend color now)
var is_flash = (hit_flash > 0 && (current_time mod 6) < 3);

// === WHEELS ===
draw_set_color(make_color_rgb(24, 20, 14));
draw_circle(x - 24, y, 13, false);
draw_circle(x + 24, y, 13, false);
draw_set_color(make_color_rgb(55, 48, 38));
draw_circle(x - 24, y, 13, true);
draw_circle(x + 24, y, 13, true);
draw_set_color(make_color_rgb(70, 62, 48));
draw_circle(x - 24, y, 6, false);
draw_circle(x + 24, y, 6, false);

// === CHASSIS (Kübelwagen grey-green) ===
draw_set_color(make_color_rgb(72, 80, 58));
draw_rectangle(x - 40, y - 22, x + 40, y - 4, false);
draw_set_color(make_color_rgb(58, 65, 44));
draw_rectangle(x - 38, y - 6, x + 38, y - 4, false);

// === HOOD (front = facing direction) ===
var hx1 = min(x + f * 26, x + f * 50);
var hx2 = max(x + f * 26, x + f * 50);
draw_set_color(make_color_rgb(62, 70, 50));
draw_rectangle(hx1, y - 18, hx2, y - 6, false);
// Grille slats
draw_set_color(make_color_rgb(40, 46, 30));
for (var sl = 0; sl < 3; sl++) {
    var gx1 = min(x + f * 44, x + f * 49);
    var gx2 = max(x + f * 44, x + f * 49);
    draw_rectangle(gx1, y - 17 + sl * 4, gx2, y - 14 + sl * 4, false);
}

// === CAB ===
var cx1 = min(x + f * (-2), x - f * 26);
var cx2 = max(x + f * (-2), x - f * 26);
draw_set_color(make_color_rgb(55, 62, 44));
draw_rectangle(cx1, y - 36, cx2, y - 22, false);
// Windshield
draw_set_alpha(0.4);
draw_set_color(make_color_rgb(110, 140, 155));
draw_rectangle(cx1 + 2, y - 34, cx2 - 2, y - 24, false);
draw_set_alpha(1);

// === DRIVER (enemy soldier silhouette) ===
draw_set_color(make_color_rgb(60, 68, 46));
draw_rectangle(x - f * 12, y - 36, x - f * 2, y - 22, false);
// Head
draw_set_color(make_color_rgb(165, 120, 72));
draw_rectangle(x - f * 11, y - 44, x - f * 3, y - 36, false);
// Helmet (German - squared)
draw_set_color(make_color_rgb(48, 54, 36));
draw_rectangle(x - f * 13, y - 50, x - f * 1, y - 42, false);
draw_rectangle(x - f * 14, y - 43, x - f * 0, y - 42, false);

// === MG42 MOUNTED (on top rear) ===
var mgx = x - f * 20;
draw_set_color(make_color_rgb(38, 34, 26));
draw_rectangle(mgx - 4, y - 42, mgx + 4, y - 36, false);
draw_line_width(mgx, y - 40, mgx - f * 28, y - 40, 3);

// === HP BAR (above vehicle) ===
if (hp < max_hp) {
    var bar_w = 60;
    var bx    = x - bar_w * 0.5;
    draw_set_color(c_dkgray);
    draw_rectangle(bx, y - 55, bx + bar_w, y - 49, false);
    draw_set_color(make_color_rgb(200, 50, 50));
    draw_rectangle(bx, y - 55, bx + bar_w * (hp / max_hp), y - 49, false);
}

// === HIT FLASH ===
if (is_flash) {
    draw_set_alpha(0.5);
    draw_set_color(c_white);
    draw_rectangle(x - 40, y - 50, x + 40, y, false);
    draw_set_alpha(1);
}

draw_set_alpha(1);
draw_set_color(c_white);
