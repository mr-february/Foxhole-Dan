var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step

// Health bleed — redder at low HP
var hurt = 1 - (hp / max_hp);

// Slow stomping walk
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.008;   // slower gait than the soldier
var leg_swing = sin(wp) * 4 * spd_ratio;
var body_bob  = abs(sin(wp)) * 1.0 * spd_ratio;

var bl_y = -leg_swing * 0.4;
var br_y =  leg_swing * 0.4;

// === HEAVY BOOTS (wide) ===
draw_set_color(make_color_rgb(16, 12, 8));
draw_rectangle(bx - 11, by - 6 + bl_y, bx - 1, by + bl_y, false);
draw_rectangle(bx + 1,  by - 6 + br_y, bx + 11, by + br_y, false);

// === ARMORED LEGS ===
draw_set_color(make_color_rgb(round(50 + hurt * 60), round(52 + hurt * 5), round(46 - hurt * 15)));
draw_rectangle(bx - 9, by - 16 + bl_y, bx - 1, by - 6 + bl_y, false);
draw_rectangle(bx + 1, by - 16 + br_y, bx + 9, by - 6 + br_y, false);
// Knee plates
draw_set_color(make_color_rgb(70, 74, 70));
draw_rectangle(bx - 9, by - 12 + bl_y, bx - 1, by - 9 + bl_y, false);
draw_rectangle(bx + 1, by - 12 + br_y, bx + 9, by - 9 + br_y, false);

var bob_off = body_bob;

// === MASSIVE ARMORED TORSO (wide silhouette) ===
draw_set_color(make_color_rgb(round(44 + hurt * 80), round(52 + hurt * 10), round(40 - hurt * 20)));
draw_rectangle(bx - 13, by - 32 + bob_off, bx + 13, by - 16 + bob_off, false);
// Chest plate slabs
draw_set_color(make_color_rgb(78, 82, 78));
draw_rectangle(bx - 11, by - 30 + bob_off, bx + 11, by - 24 + bob_off, false);
draw_set_color(make_color_rgb(62, 66, 62));
draw_rectangle(bx - 11, by - 23 + bob_off, bx + 11, by - 18 + bob_off, false);
// Plate rivets
draw_set_color(make_color_rgb(110, 112, 108));
draw_rectangle(bx - 10, by - 29 + bob_off, bx - 8, by - 27 + bob_off, false);
draw_rectangle(bx + 8,  by - 29 + bob_off, bx + 10, by - 27 + bob_off, false);
// Belt
draw_set_color(make_color_rgb(22, 24, 18));
draw_rectangle(bx - 13, by - 18 + bob_off, bx + 13, by - 16 + bob_off, false);

// === PAULDRONS (huge shoulders) ===
draw_set_color(make_color_rgb(58, 62, 58));
draw_rectangle(bx - 17, by - 33 + bob_off, bx - 10, by - 25 + bob_off, false);
draw_rectangle(bx + 10, by - 33 + bob_off, bx + 17, by - 25 + bob_off, false);

// === REAR ARM ===
draw_set_color(make_color_rgb(round(46 + hurt * 60), round(52 + hurt * 8), round(40 - hurt * 15)));
draw_rectangle(bx - f * 14, by - 26 + bob_off, bx - f * 9, by - 16 + bob_off, false);

// === CANNON ARM (thick barrel) ===
draw_set_color(make_color_rgb(46, 52, 40));
draw_rectangle(bx + f * 6, by - 27 + bob_off, bx + f * 15, by - 21 + bob_off, false);
draw_set_color(make_color_rgb(22, 20, 16));
draw_line_width(bx + f * 10, by - 24 + bob_off, bx + f * 24, by - 24 + bob_off, 6);
// Muzzle ring
draw_set_color(make_color_rgb(60, 58, 50));
draw_rectangle(bx + f * 21, by - 27 + bob_off, bx + f * 24, by - 21 + bob_off, false);

// === HEAD — squat, buried in armor ===
var hy = by - 38 + bob_off;
draw_set_color(make_color_rgb(150, 104, 70));
draw_rectangle(bx - 4, hy + 2, bx + 4, hy + 7, false);
// Full-face armored helmet with visor slit
draw_set_color(make_color_rgb(34, 36, 34));
draw_rectangle(bx - 7, hy - 3, bx + 7, hy + 4, false);
draw_rectangle(bx - 6, hy - 5, bx + 6, hy - 1, false);
draw_set_color(make_color_rgb(12, 12, 12));
draw_rectangle(bx - 4 + f, hy, bx + 4 + f, hy + 2, false);
// Red star insignia
draw_set_color(make_color_rgb(180, 20, 20));
draw_rectangle(bx - 2, hy - 4, bx + 2, hy - 1, false);

// === HIT FLASH — redraw silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 11, by - 6 + bl_y, bx - 1, by + bl_y, false);
    draw_rectangle(bx + 1,  by - 6 + br_y, bx + 11, by + br_y, false);
    draw_rectangle(bx - 9, by - 16 + bl_y, bx - 1, by - 6 + bl_y, false);
    draw_rectangle(bx + 1, by - 16 + br_y, bx + 9, by - 6 + br_y, false);
    draw_rectangle(bx - 13, by - 32 + bob_off, bx + 13, by - 16 + bob_off, false);
    draw_rectangle(bx - 17, by - 33 + bob_off, bx - 10, by - 25 + bob_off, false);
    draw_rectangle(bx + 10, by - 33 + bob_off, bx + 17, by - 25 + bob_off, false);
    draw_rectangle(bx - f * 14, by - 26 + bob_off, bx - f * 9, by - 16 + bob_off, false);
    draw_rectangle(bx + f * 6, by - 27 + bob_off, bx + f * 15, by - 21 + bob_off, false);
    draw_rectangle(bx - 7, hy - 3, bx + 7, hy + 4, false);
    draw_rectangle(bx - 6, hy - 5, bx + 6, hy - 1, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
