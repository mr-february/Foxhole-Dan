var f         = image_xscale;   // +1 = facing right, -1 = facing left
var is_flash  = (hit_flash > 0 && (current_time mod 6) < 3);
var wr        = 15;
var wx1       = x - 27;
var wx2       = x + 27;

// =========================================================
// WHEELS — tread, disc, spokes, hub, lug nuts
// =========================================================
draw_set_color(make_color_rgb(18, 14, 8));
draw_circle(wx1, y, wr, false);
draw_circle(wx2, y, wr, false);

// Tread lugs (6 per wheel)
for (var td = 0; td < 6; td++) {
    var ta = wheel_spin + td * 60;
    draw_set_color(make_color_rgb(26, 20, 10));
    draw_line_width(
        wx1 + lengthdir_x(wr - 1, ta), y + lengthdir_y(wr - 1, ta),
        wx1 + lengthdir_x(wr - 5, ta), y + lengthdir_y(wr - 5, ta), 3);
    draw_line_width(
        wx2 + lengthdir_x(wr - 1, ta), y + lengthdir_y(wr - 1, ta),
        wx2 + lengthdir_x(wr - 5, ta), y + lengthdir_y(wr - 5, ta), 3);
}

// Wheel disc
draw_set_color(make_color_rgb(52, 46, 34));
draw_circle(wx1, y, wr - 5, false);
draw_circle(wx2, y, wr - 5, false);

// 3 spokes
draw_set_color(make_color_rgb(68, 60, 46));
for (var sp = 0; sp < 3; sp++) {
    var sa = wheel_spin + sp * 120;
    draw_line_width(
        wx1 + lengthdir_x(3,      sa), y + lengthdir_y(3,      sa),
        wx1 + lengthdir_x(wr - 6, sa), y + lengthdir_y(wr - 6, sa), 2);
    draw_line_width(
        wx2 + lengthdir_x(3,      sa), y + lengthdir_y(3,      sa),
        wx2 + lengthdir_x(wr - 6, sa), y + lengthdir_y(wr - 6, sa), 2);
}

// Hub
draw_set_color(make_color_rgb(86, 78, 60));
draw_circle(wx1, y, 4, false);
draw_circle(wx2, y, 4, false);

// 4 lug nuts
draw_set_color(make_color_rgb(108, 98, 76));
for (var lu = 0; lu < 4; lu++) {
    var la = wheel_spin + lu * 90;
    draw_circle(wx1 + lengthdir_x(7, la), y + lengthdir_y(7, la), 1, false);
    draw_circle(wx2 + lengthdir_x(7, la), y + lengthdir_y(7, la), 1, false);
}

// =========================================================
// FENDERS
// =========================================================
draw_set_color(make_color_rgb(58, 66, 46));
draw_rectangle(wx1 - wr - 2, y - wr - 3, wx1 + wr + 2, y - wr + 4, false);
draw_rectangle(wx2 - wr - 2, y - wr - 3, wx2 + wr + 2, y - wr + 4, false);
draw_set_color(make_color_rgb(42, 48, 32));
draw_line(wx1 - wr - 2, y - wr - 3, wx1 + wr + 2, y - wr - 3);
draw_line(wx2 - wr - 2, y - wr - 3, wx2 + wr + 2, y - wr - 3);

// =========================================================
// CHASSIS — Feldgrau (German field grey-green, more angular)
// =========================================================
// Main body slab (rear half to just before hood)
draw_set_color(make_color_rgb(66, 74, 52));
draw_rectangle(x - f * 40, y - 20, x + f * 28, y - 5, false);
// Lower armor skirt
draw_set_color(make_color_rgb(50, 56, 38));
draw_rectangle(x - f * 40, y - 8,  x + f * 28, y - 5, false);
// Top panel highlight
draw_set_color(make_color_rgb(74, 84, 58));
draw_rectangle(x - f * 40, y - 20, x + f * 28, y - 17, false);
// Vertical body seam (panel division)
draw_set_color(make_color_rgb(48, 54, 36));
draw_line(x - f * 10, y - 20, x - f * 10, y - 5);

// =========================================================
// HOOD / ENGINE (boxy Germanic style, at front)
// =========================================================
draw_set_color(make_color_rgb(62, 70, 50));
draw_rectangle(x + f * 26, y - 18, x + f * 54, y - 5, false);
// Hood panel ridges (3 raised lines along top)
draw_set_color(make_color_rgb(74, 82, 58));
draw_line(x + f * 28, y - 18, x + f * 52, y - 18);
draw_set_color(make_color_rgb(48, 55, 36));
for (var lv = 0; lv < 3; lv++) {
    draw_line(x + f * (30 + lv * 6), y - 17, x + f * (30 + lv * 6), y - 6);
}
// Front grille face (boxy rectangle grid)
draw_set_color(make_color_rgb(24, 28, 16));
draw_rectangle(x + f * 50, y - 17, x + f * 55, y - 6, false);
for (var gs = 0; gs < 3; gs++) {
    draw_set_color(make_color_rgb(16, 20, 10));
    draw_line(x + f * 51, y - 16 + gs * 4, x + f * 54, y - 16 + gs * 4);
}
// Squared German-style headlight (rectangle, not round)
draw_set_color(make_color_rgb(32, 36, 24));
draw_rectangle(x + f * 46, y - 17, x + f * 51, y - 10, false);
draw_set_color(make_color_rgb(185, 175, 110));
draw_rectangle(x + f * 47, y - 16, x + f * 50, y - 11, false);
// Front bumper (heavy steel bar)
draw_set_color(make_color_rgb(36, 32, 22));
draw_rectangle(x + f * 53, y - 13, x + f * 58, y - 3, false);

// =========================================================
// CAB — boxy, angular (rear half of vehicle)
// =========================================================
draw_set_color(make_color_rgb(56, 64, 44));
draw_rectangle(x - f * 2, y - 36, x - f * 28, y - 20, false);
// Hard angular roofline (no soft curves)
draw_set_color(make_color_rgb(48, 55, 38));
draw_rectangle(x - f * 2, y - 36, x - f * 28, y - 34, false);
// A-pillar (front post of cab)
draw_set_color(make_color_rgb(44, 50, 34));
draw_rectangle(x - f * 2,  y - 36, x - f * 5,  y - 20, false);
// Rear cab post
draw_rectangle(x - f * 25, y - 36, x - f * 28, y - 20, false);

// Windshield glass
draw_set_alpha(0.36);
draw_set_color(make_color_rgb(105, 132, 145));
draw_rectangle(x - f * 5,  y - 34, x - f * 24, y - 22, false);
draw_set_alpha(1);
// Windshield divider bar
draw_set_color(make_color_rgb(42, 48, 32));
draw_line(x - f * 14, y - 34, x - f * 14, y - 22);

// =========================================================
// DRIVER — German soldier (Stahlhelm + Feldgrau uniform)
// =========================================================
// Torso
draw_set_color(make_color_rgb(58, 66, 46));
draw_rectangle(x - f * 8,  y - 36, x - f * 2,  y - 22, false);
// Collar/shoulder detail
draw_set_color(make_color_rgb(70, 78, 55));
draw_line(x - f * 8, y - 34, x - f * 2, y - 34);
// Head
draw_set_color(make_color_rgb(164, 118, 70));
draw_rectangle(x - f * 8,  y - 44, x - f * 2,  y - 36, false);
// Stahlhelm (German helmet — wide flat brim, distinctive silhouette)
draw_set_color(make_color_rgb(44, 50, 32));
draw_rectangle(x - f * 10, y - 50, x - f * 0,  y - 42, false);
// Helmet dome
draw_ellipse(x - f * 10, y - 54, x - f * 0, y - 42, false);
// Wide rim flare (distinctive German helmet)
draw_rectangle(x - f * 12, y - 44, x - f * (-2), y - 42, false);

// =========================================================
// MG42 MOUNT (forward-facing, distinctive perforated barrel)
// =========================================================
var mgx = x + f * 6;    // mount base (front-center area)
// Mount post
draw_set_color(make_color_rgb(34, 30, 22));
draw_rectangle(mgx - 4, y - 46, mgx + 4, y - 36, false);
// Receiver body (boxy)
draw_set_color(make_color_rgb(26, 24, 16));
draw_rectangle(mgx - 6, y - 53, mgx + 6, y - 45, false);
// Barrel (long, forward — MG42 distinctive length)
draw_set_color(make_color_rgb(22, 20, 14));
draw_line_width(mgx + f * 6,  y - 49, mgx + f * 36, y - 49, 3);
// Perforated barrel jacket (holes along shroud)
draw_set_color(make_color_rgb(38, 34, 24));
draw_rectangle(mgx + f * 6, y - 51, mgx + f * 26, y - 47, false);
for (var pg = 0; pg < 5; pg++) {
    draw_set_color(make_color_rgb(20, 18, 12));
    draw_point(mgx + f * (8 + pg * 4), y - 49);
}
// Flash hider at muzzle
draw_set_color(make_color_rgb(30, 27, 18));
draw_circle(mgx + f * 36, y - 49, 2, false);
// Bipod legs (supporting under barrel)
draw_set_color(make_color_rgb(28, 25, 18));
draw_line(mgx + f * 16, y - 47, mgx + f * 12, y - 36);
draw_line(mgx + f * 16, y - 47, mgx + f * 20, y - 36);
// Ammo drum (side-mounted, visible from side)
draw_set_color(make_color_rgb(58, 52, 38));
draw_circle(mgx + f * 2, y - 57, 6, false);
draw_set_color(make_color_rgb(44, 40, 28));
draw_circle(mgx + f * 2, y - 57, 3, false);

// =========================================================
// HP BAR
// =========================================================
if (hp < max_hp) {
    var bar_w = 66;
    var bx    = x - bar_w * 0.5;
    draw_set_color(make_color_rgb(20, 16, 12));
    draw_rectangle(bx - 1, y - 62, bx + bar_w + 1, y - 55, false);
    draw_set_color(make_color_rgb(185, 38, 28));
    draw_rectangle(bx, y - 61, bx + bar_w * (hp / max_hp), y - 56, false);
    draw_set_color(make_color_rgb(80, 16, 12));
    draw_rectangle(bx + bar_w * (hp / max_hp), y - 61, bx + bar_w, y - 56, false);
}

// =========================================================
// HIT FLASH
// =========================================================
if (is_flash) {
    draw_set_alpha(0.52);
    draw_set_color(c_white);
    draw_rectangle(x - 46, y - 58, x + 46, y, false);
    draw_set_alpha(1);
}

draw_set_alpha(1);
draw_set_color(c_white);
