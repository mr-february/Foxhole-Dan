var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step

// Health bleed — redder at low HP
var hurt = 1 - (hp / max_hp);

// Walk animation — measured, confident stride
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.014;
var leg_swing = sin(wp) * 5 * spd_ratio;
var body_bob  = abs(sin(wp)) * 1.2 * spd_ratio;

var bl_y = -leg_swing * 0.4;
var br_y =  leg_swing * 0.4;
var bob_off = body_bob;

// === BOOTS (jet black) ===
draw_set_color(make_color_rgb(10, 10, 12));
draw_rectangle(bx - 7, by - 5 + bl_y, bx + 1, by + bl_y, false);
draw_rectangle(bx + 1, by - 5 + br_y, bx + 7, by + br_y, false);

// === PANTS — darker fatigues ===
draw_set_color(make_color_rgb(round(24 + hurt * 60), round(28 + hurt * 5), round(30 - hurt * 12)));
draw_rectangle(bx - 6, by - 15 + bl_y, bx + 1, by - 5 + bl_y, false);
draw_rectangle(bx + 1, by - 15 + br_y, bx + 6, by - 5 + br_y, false);

// === TORSO — near-black tactical fatigues ===
draw_set_color(make_color_rgb(round(26 + hurt * 80), round(30 + hurt * 10), round(32 - hurt * 15)));
draw_rectangle(bx - 8, by - 26 + bob_off, bx + 8, by - 14 + bob_off, false);

// === BODY ARMOR PLATE (the i_frames read) ===
draw_set_color(make_color_rgb(48, 52, 56));
draw_rectangle(bx - 6, by - 25 + bob_off, bx + 6, by - 17 + bob_off, false);
// Plate seam + shine
draw_set_color(make_color_rgb(70, 76, 82));
draw_rectangle(bx - 6, by - 25 + bob_off, bx + 6, by - 23 + bob_off, false);
draw_set_color(make_color_rgb(30, 32, 36));
draw_line(bx, by - 25 + bob_off, bx, by - 17 + bob_off);
// Armor glints while i_frames are active
if (i_frames > 0) {
    draw_set_alpha(0.7);
    draw_set_color(make_color_rgb(160, 200, 230));
    draw_rectangle(bx - 6, by - 25 + bob_off, bx + 6, by - 17 + bob_off, false);
    draw_set_alpha(1);
}

// === BELT + THIGH RIG ===
draw_set_color(make_color_rgb(14, 14, 16));
draw_rectangle(bx - 8, by - 16 + bob_off, bx + 8, by - 14 + bob_off, false);
draw_rectangle(bx + 2, by - 13 + br_y, bx + 6, by - 9 + br_y, false);

// === REAR ARM ===
draw_set_color(make_color_rgb(round(26 + hurt * 60), 30, 32));
draw_rectangle(bx - f * 8, by - 22 + bob_off, bx - f * 4, by - 15 + bob_off, false);

// === GUN ARM — bullpup rifle, thicker than the grunt's ===
draw_set_color(make_color_rgb(28, 32, 34));
draw_rectangle(bx + f * 4, by - 23 + bob_off, bx + f * 12, by - 18 + bob_off, false);
draw_set_color(make_color_rgb(16, 16, 18));
draw_line_width(bx + f * 6, by - 21 + bob_off, bx + f * 20, by - 21 + bob_off, 4);
// Underslung mag
draw_rectangle(bx + f * 12, by - 18 + bob_off, bx + f * 15, by - 14 + bob_off, false);

// === NECK ===
draw_set_color(make_color_rgb(150, 104, 70));
draw_rectangle(bx - 3, by - 28 + bob_off, bx + 3, by - 26 + bob_off, false);

// === HEAD ===
var hx = bx;
var hy = by - 30 + bob_off;
draw_set_color(make_color_rgb(158, 110, 74));
draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);

// === BERET (tilted) + TACTICAL VISOR ===
draw_set_color(make_color_rgb(60, 14, 16));
draw_rectangle(hx - 6, hy - 4, hx + 4, hy, false);
draw_rectangle(hx - 7, hy - 2, hx - 3, hy + 1, false);
// Beret flash badge
draw_set_color(make_color_rgb(190, 160, 60));
draw_rectangle(hx - 5, hy - 3, hx - 3, hy - 1, false);
// Visor band across the eyes — cold cyan glow
draw_set_color(make_color_rgb(40, 180, 200));
draw_rectangle(hx - 4 + f, hy + 2, hx + 4 + f, hy + 4, false);

// === HIT FLASH — redraw elite silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 7, by - 5 + bl_y, bx + 1, by + bl_y, false);
    draw_rectangle(bx + 1, by - 5 + br_y, bx + 7, by + br_y, false);
    draw_rectangle(bx - 6, by - 15 + bl_y, bx + 1, by - 5 + bl_y, false);
    draw_rectangle(bx + 1, by - 15 + br_y, bx + 6, by - 5 + br_y, false);
    draw_rectangle(bx - 8, by - 26 + bob_off, bx + 8, by - 14 + bob_off, false);
    draw_rectangle(bx - f * 8, by - 22 + bob_off, bx - f * 4, by - 15 + bob_off, false);
    draw_rectangle(bx + f * 4, by - 23 + bob_off, bx + f * 12, by - 18 + bob_off, false);
    draw_rectangle(bx - 3, by - 28 + bob_off, bx + 3, by - 26 + bob_off, false);
    draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
    draw_rectangle(hx - 6, hy - 4, hx + 4, hy, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
