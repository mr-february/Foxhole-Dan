var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step via image_xscale

// Cover — crouched silhouette, exits early
if (cover_timer > 0) {
    draw_set_color(make_color_rgb(20, 15, 10));
    draw_rectangle(bx - 7, by - 5, bx + 7, by, false);
    draw_set_color(make_color_rgb(42, 50, 35));
    draw_rectangle(bx - 8, by - 14, bx + 8, by - 5, false);
    draw_set_color(make_color_rgb(28, 30, 28));
    draw_rectangle(bx - 6, by - 20, bx + 6, by - 14, false);
    draw_set_color(make_color_rgb(180, 20, 20));
    draw_rectangle(bx - 2, by - 20, bx + 2, by - 16, false);
    if (hit_flash > 0) {
        draw_set_alpha(0.65);
        draw_set_color(c_white);
        draw_rectangle(bx - 9, by - 22, bx + 9, by, false);
        draw_set_alpha(1);
    }
    draw_set_color(c_white);
    exit;
}

// Health bleed — redder at low HP
var hurt = 1 - (hp / 100);

// Walk animation
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.016;
var leg_swing = sin(wp) * 6 * spd_ratio;
var leg_lift  = abs(sin(wp)) * 3 * spd_ratio;
var body_bob  = abs(sin(wp)) * 1.5 * spd_ratio;
var arm_swing = sin(wp + pi) * 5 * spd_ratio;

// === BOOTS ===
var bl_y = -leg_swing * 0.4 + leg_lift * 0.3;
var br_y =  leg_swing * 0.4 - leg_lift * 0.3;
draw_set_color(make_color_rgb(20, 15, 10));
draw_rectangle(bx - 7 - f * leg_swing * 0.15, by - 5 + bl_y,
               bx + 1 - f * leg_swing * 0.15, by     + bl_y, false);
draw_rectangle(bx + 1 + f * leg_swing * 0.15, by - 5 + br_y,
               bx + 7 + f * leg_swing * 0.15, by     + br_y, false);

// === PANTS ===
draw_set_color(make_color_rgb(round(40 + hurt*60), round(42 + hurt*5), round(48 - hurt*15)));
draw_rectangle(bx - 6 - f * leg_swing * 0.12, by - 15 + bl_y,
               bx + 1 - f * leg_swing * 0.12, by - 5  + bl_y, false);
draw_rectangle(bx + 1 + f * leg_swing * 0.12, by - 15 + br_y,
               bx + 6 + f * leg_swing * 0.12, by - 5  + br_y, false);

// === JACKET ===
var bob_off = body_bob;
draw_set_color(make_color_rgb(round(42 + hurt*80), round(50 + hurt*10), round(35 - hurt*20)));
draw_rectangle(bx - 8, by - 26 + bob_off, bx + 8, by - 14 + bob_off, false);

// Belt
draw_set_color(make_color_rgb(25, 28, 20));
draw_rectangle(bx - 8, by - 16 + bob_off, bx + 8, by - 14 + bob_off, false);
// Chest strap
draw_set_color(make_color_rgb(30, 36, 24));
draw_line(bx - 3, by - 25 + bob_off, bx + 3, by - 15 + bob_off);

// === FREE ARM (swings) ===
var fa_x = bx - f * 6;
var fa_y = by - 20 + bob_off + arm_swing;
draw_set_color(make_color_rgb(round(42 + hurt*60), round(50 + hurt*10), round(35 - hurt*15)));
draw_rectangle(fa_x - 3, fa_y - 2, fa_x + 3, fa_y + 6, false);

// === GUN ARM ===
draw_set_color(make_color_rgb(42, 50, 35));
draw_rectangle(bx + f * 4, by - 22 + bob_off, bx + f * 12, by - 18 + bob_off, false);
draw_set_color(make_color_rgb(25, 22, 18));
draw_line_width(bx + f * 6, by - 20 + bob_off, bx + f * 18, by - 20 + bob_off, 3);
// Barrel flash highlight
draw_set_color(make_color_rgb(45, 42, 35));
draw_line_width(bx + f * 7, by - 19 + bob_off, bx + f * 18, by - 19 + bob_off, 1);

// === NECK ===
draw_set_color(make_color_rgb(160, 112, 75));
draw_rectangle(bx - 3, by - 28 + bob_off, bx + 3, by - 26 + bob_off, false);

// === HEAD (slight sway) ===
var head_sway = sin(wp) * 1.0 * spd_ratio;
var hx = bx + head_sway;
var hy = by - 30 + bob_off;

draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
// Narrow menacing eyes
var ex_off = (f > 0) ? 1 : -1;
draw_set_color(make_color_rgb(25, 18, 14));
draw_rectangle(hx - 4 + ex_off, hy + 2, hx - 1 + ex_off, hy + 4, false);
// Scowl scar mark
draw_set_color(make_color_rgb(110, 70, 55));
draw_line(hx - 1, hy + 2, hx + 2, hy + 5);

// === HELMET ===
draw_set_color(make_color_rgb(28, 30, 28));
draw_rectangle(hx - 6, hy - 4, hx + 6, hy + 2, false);
draw_rectangle(hx - 5, hy - 6, hx + 5, hy - 2, false);
// Helmet brim shadow
draw_set_color(make_color_rgb(15, 16, 14));
draw_rectangle(hx - 7, hy + 1, hx + 7, hy + 2, false);
// Red star insignia
draw_set_color(make_color_rgb(180, 20, 20));
draw_rectangle(hx - 2, hy - 4, hx + 2, hy - 1, false);
draw_rectangle(hx - 1, hy - 5, hx + 1, hy,     false);

// === HIT FLASH ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 9, by - 35, bx + 9, by, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
