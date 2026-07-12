var bx = x;
var by = y;
var f  = image_xscale;

// === SANDBAG EMPLACEMENT SILHOUETTE ===
// Bottom sandbag row
draw_set_color(make_color_rgb(112, 98, 66));
draw_rectangle(bx - 26, by - 7, bx - 10, by, false);
draw_set_color(make_color_rgb(122, 106, 72));
draw_rectangle(bx - 10, by - 7, bx + 8, by, false);
draw_set_color(make_color_rgb(106, 92, 62));
draw_rectangle(bx + 8, by - 7, bx + 26, by, false);
// Middle sandbag row (offset joints)
draw_set_color(make_color_rgb(118, 102, 70));
draw_rectangle(bx - 22, by - 14, bx - 2, by - 7, false);
draw_set_color(make_color_rgb(108, 94, 64));
draw_rectangle(bx - 2, by - 14, bx + 22, by - 7, false);
// Top sandbag row (shorter — firing notch)
draw_set_color(make_color_rgb(114, 100, 68));
draw_rectangle(bx - 18, by - 20, bx - 4, by - 14, false);
draw_set_color(make_color_rgb(104, 90, 60));
draw_rectangle(bx + 4, by - 20, bx + 18, by - 14, false);
// Sandbag seams
draw_set_color(make_color_rgb(80, 68, 46));
draw_line(bx - 26, by - 7, bx + 26, by - 7);
draw_line(bx - 22, by - 14, bx + 22, by - 14);

// === MG barrel poking over the notch ===
draw_set_color(make_color_rgb(25, 22, 18));
draw_line_width(bx, by - 17, bx + f * 30, by - 19, 3);
// Barrel shroud detail
draw_set_color(make_color_rgb(45, 42, 35));
draw_line_width(bx + f * 8, by - 18, bx + f * 20, by - 19, 1);
// Ammo box beside the gun
draw_set_color(make_color_rgb(48, 56, 38));
draw_rectangle(bx - f * 10, by - 19, bx - f * 3, by - 14, false);

// === Gunner helmet peeking above the bags ===
draw_set_color(make_color_rgb(28, 30, 28));
draw_rectangle(bx - f * 8, by - 26, bx + f * 2, by - 19, false);
draw_set_color(make_color_rgb(15, 16, 14));
draw_rectangle(bx - f * 9, by - 20, bx + f * 3, by - 19, false);
// Eyes in the shadow under the helmet
draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(bx - f * 6, by - 19, bx + f * 1, by - 16, false);

// Muzzle flash while firing
if (muzzle_flash > 0) {
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(255, 220, 120));
    draw_circle(bx + f * 31, by - 19, 3 + random(2), false);
    draw_set_color(make_color_rgb(255, 160, 60));
    draw_circle(bx + f * 33, by - 19, 2, false);
    draw_set_alpha(1);
}

// === HIT FLASH — redraw emplacement in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 26, by - 7, bx + 26, by, false);
    draw_rectangle(bx - 22, by - 14, bx + 22, by - 7, false);
    draw_rectangle(bx - 18, by - 20, bx - 4, by - 14, false);
    draw_rectangle(bx + 4, by - 20, bx + 18, by - 14, false);
    draw_rectangle(bx - f * 8, by - 26, bx + f * 2, by - 19, false);
    draw_line_width(bx, by - 17, bx + f * 30, by - 19, 3);
    draw_set_alpha(1);
}

draw_set_color(c_white);
