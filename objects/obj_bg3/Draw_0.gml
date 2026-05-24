var cx  = camera_get_view_x(view_camera[0]);
var cy  = camera_get_view_y(view_camera[0]);
var vw  = camera_get_view_width(view_camera[0]);
var vh  = camera_get_view_height(view_camera[0]);
var tt  = current_time * 0.001;

// Room dimensions: 1920 wide, 3500 tall. Dan climbs from y=2920 up to y=200.
// Camera scrolls vertically — cy goes from ~2466 down to ~0.

// =========================================================
// FILL — dark smoky interior wall colour
// =========================================================
draw_set_color(make_color_rgb(14, 12, 10));
draw_rectangle(cx, cy, cx + vw, cy + vh, false);

// =========================================================
// FAR WALL — exposed brick (parallax 0.05 vertical, fixed horizontal)
// =========================================================
var wall_col1 = make_color_rgb(72, 42, 28);
var wall_col2 = make_color_rgb(58, 34, 22);
var wall_col3 = make_color_rgb(85, 50, 32);
var mortar_col = make_color_rgb(28, 24, 20);

// Tile the brick wall across the full room height using camera y with slight parallax
var wy_off = cy * 0.05;
var brick_h = 14;
var brick_w = 38;

// Left wall strip (0 to 120px)
for (var row = 0; row < ceil(vh / brick_h) + 2; row++) {
    var wy = cy + row * brick_h - (wy_off mod brick_h);
    var col_pick = (row mod 3 == 0) ? wall_col1 : (row mod 3 == 1 ? wall_col2 : wall_col3);
    draw_set_color(col_pick);
    var offset = (row mod 2 == 0) ? 0 : brick_w / 2;
    for (var bc = -1; bc < ceil(120 / brick_w) + 1; bc++) {
        var bx = cx + bc * brick_w + offset;
        draw_rectangle(bx + 1, wy + 1, bx + brick_w - 1, wy + brick_h - 1, false);
    }
    draw_set_color(mortar_col);
    draw_rectangle(cx, wy, cx + 120, wy + 1, false);
}

// Right wall strip (vw-120 to vw)
for (var row2 = 0; row2 < ceil(vh / brick_h) + 2; row2++) {
    var wy2 = cy + row2 * brick_h - (wy_off mod brick_h);
    var col_pick2 = (row2 mod 3 == 0) ? wall_col1 : (row2 mod 3 == 1 ? wall_col2 : wall_col3);
    draw_set_color(col_pick2);
    var offset2 = (row2 mod 2 == 0) ? 0 : brick_w / 2;
    for (var bc2 = -1; bc2 < ceil(120 / brick_w) + 1; bc2++) {
        var bx2 = cx + vw - 120 + bc2 * brick_w + offset2;
        draw_rectangle(bx2 + 1, wy2 + 1, bx2 + brick_w - 1, wy2 + brick_h - 1, false);
    }
    draw_set_color(mortar_col);
    draw_rectangle(cx + vw - 120, wy2, cx + vw, wy2 + 1, false);
}

// =========================================================
// WALL DAMAGE MARKS — diagonal cracks, dark staining, holes
// These are clearly NOT platforms: diagonal/irregular, no top surface
// =========================================================
var dmg_par = cy * 0.06;
var dmg_spacing = 180;

for (var dm = 0; dm < 22; dm++) {
    var dmy  = dm * dmg_spacing - (dmg_par mod dmg_spacing) + cy;
    if (dmy < cy - 40 || dmy > cy + vh + 40) continue;
    var dmh  = (dm * 137 + 53) mod 100;

    // Left wall — diagonal crack mark (top-left to bottom-right)
    var cx1l = cx + 122 + (dmh mod 30);
    var cx2l = cx + 122 + 40 + (dmh mod 50);
    draw_set_color(make_color_rgb(22, 18, 14));
    draw_line_width(cx1l, dmy, cx2l, dmy + 55 + dmh mod 30, 3);
    // Shadow beside crack
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(10, 8, 6));
    draw_line_width(cx1l + 2, dmy + 1, cx2l + 2, dmy + 56 + dmh mod 30, 4);
    draw_set_alpha(1);
    // Debris / spall at crack base (dark smear, clearly against wall)
    draw_set_color(make_color_rgb(28, 24, 18));
    draw_ellipse(cx1l - 2, dmy + 50 + dmh mod 20, cx2l + 12, dmy + 65 + dmh mod 20, false);

    // Right wall — similar but angled the other way
    var cx1r = cx + vw - 122 - (dmh mod 30);
    var cx2r = cx + vw - 122 - 40 - (dmh mod 50);
    draw_set_color(make_color_rgb(22, 18, 14));
    draw_line_width(cx1r, dmy + 10 + dmh mod 20, cx2r, dmy + 70 + dmh mod 25, 3);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(10, 8, 6));
    draw_line_width(cx1r - 2, dmy + 11 + dmh mod 20, cx2r - 2, dmy + 71 + dmh mod 25, 4);
    draw_set_alpha(1);

    // Pipe / conduit running diagonally across wall (clearly attached to wall, not a ledge)
    if (dmh mod 3 == 0) {
        var px1 = cx + 118;
        var px2 = cx + 118 + 70 + dmh mod 40;
        draw_set_color(make_color_rgb(50, 48, 42));
        draw_line_width(px1, dmy + 20, px2, dmy - 18, 4);
        draw_set_color(make_color_rgb(65, 62, 54));
        draw_line_width(px1, dmy + 18, px2, dmy - 20, 1);
    }
}

// =========================================================
// STRUCTURAL BEAMS — semi-transparent so they read as background
// Vertical orientation so they don't look like walkable ledges
// =========================================================
var beam_par = cy * 0.10;
draw_set_alpha(0.45);
for (var bm = 0; bm < 10; bm++) {
    // Vertical column beams (clearly not platforms — they go up/down)
    var bmx   = cx + 130 + (bm * 193 + 41) mod (vw - 260);
    var bm_y1 = cy;
    var bm_y2 = cy + vh;
    draw_set_color(make_color_rgb(30, 27, 22));
    draw_rectangle(bmx,     bm_y1, bmx + 5,  bm_y2, false);
    draw_rectangle(bmx + 5, bm_y1, bmx + 10, bm_y2, false);
    draw_set_color(make_color_rgb(48, 44, 36));
    draw_line(bmx, bm_y1, bmx, bm_y2);
    // Cross-brace diagonal (X pattern between adjacent columns — clearly not walkable)
    if (bm mod 2 == 0 && bm < 9) {
        var bmx2 = cx + 130 + ((bm + 1) * 193 + 41) mod (vw - 260);
        draw_set_color(make_color_rgb(28, 25, 20));
        draw_line_width(bmx + 5, bm_y1 + 40, bmx2, bm_y2 - 40, 2);
        draw_line_width(bmx + 5, bm_y2 - 40, bmx2, bm_y1 + 40, 2);
    }
}
draw_set_alpha(1);

// =========================================================
// FIRE & GLOW through floor holes (fixed world positions)
// =========================================================
var fire_positions = [
    [300,  2760], [1650, 2600], [250,  2440], [1500, 2280],
    [400,  2120], [1600, 1960], [350,  1800], [1550, 1640],
    [300,  1480], [1600, 1320], [450,  1160], [1450, 1000],
    [380,  840],  [1520, 680],  [420,  520],
];
for (var fi = 0; fi < array_length(fire_positions); fi++) {
    var fx   = fire_positions[fi][0];
    var fy   = fire_positions[fi][1];
    if (fy < cy - 40 || fy > cy + vh + 40) continue;

    // Glow
    var glow = 0.3 + 0.25 * sin(tt * 2.1 + fi * 1.7);
    draw_set_alpha(glow * 0.55);
    draw_set_color(make_color_rgb(255, 120, 20));
    draw_ellipse(fx - 40, fy - 10, fx + 40, fy + 10, false);
    // Flame core
    var ff2 = 0.7 + 0.3 * sin(tt * 3.4 + fi * 2.3);
    draw_set_alpha(ff2 * 0.9);
    draw_set_color(make_color_rgb(240, 90, 10));
    draw_ellipse(fx - 18, fy - 22, fx + 18, fy + 4, false);
    draw_set_alpha(ff2 * 0.8);
    draw_set_color(make_color_rgb(255, 210, 60));
    draw_ellipse(fx - 8, fy - 14, fx + 8, fy + 2, false);
    draw_set_alpha(1);

    // Smoke rising from this fire upward
    for (var sm = 0; sm < 5; sm++) {
        var smf = ((tt * 0.3 + sm * 0.2 + fi * 0.13) mod 1.0);
        var smy = fy - smf * 120;
        if (smy < cy || smy > cy + vh) continue;
        draw_set_alpha(0.18 * (1 - smf));
        draw_set_color(make_color_rgb(45, 40, 35));
        draw_circle(fx + sin(smf * 7 + sm + fi) * 10, smy, 5 + smf * 18, false);
    }
    draw_set_alpha(1);
}

// =========================================================
// SKY THROUGH BOMBED-OUT SECTIONS (top of room, y < 600)
// =========================================================
if (cy < 600) {
    var sky_alpha = clamp((600 - cy) / 400.0, 0, 1) * 0.85;
    draw_set_alpha(sky_alpha);
    // Night sky patch in centre-upper region
    draw_set_color(make_color_rgb(12, 16, 32));
    draw_rectangle(cx + 200, cy, cx + vw - 200, cy + 120, false);
    // Stars visible through the hole
    for (var s = 0; s < 20; s++) {
        var sx = cx + 220 + (s * 71) mod (vw - 440);
        var sy = cy + 10 + (s * 53) mod 100;
        draw_set_alpha(sky_alpha * (0.4 + 0.5 * abs(sin(tt * (0.7 + s * 0.11)))));
        draw_set_color(c_white);
        draw_point(sx, sy);
    }
    draw_set_alpha(1);
}

// =========================================================
// DUST & HAZE OVERLAY
// =========================================================
draw_set_alpha(0.10);
draw_set_color(make_color_rgb(60, 50, 35));
draw_rectangle(cx, cy, cx + vw, cy + vh, false);
draw_set_alpha(1);

draw_set_color(c_white);
