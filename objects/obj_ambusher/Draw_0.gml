var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step

// Health bleed — redder at low HP
var hurt = 1 - (hp / max_hp);

// === STATE 0 — HIDDEN: prone under a ghillie mound, half-alpha ===
if (state == 0) {
    draw_set_alpha(0.5);
    // Foliage mound
    draw_set_color(make_color_rgb(34, 44, 26));
    draw_rectangle(bx - 16, by - 8, bx + 16, by, false);
    draw_set_color(make_color_rgb(42, 54, 30));
    draw_rectangle(bx - 11, by - 12, bx + 11, by - 6, false);
    // Prone body hint under the foliage
    draw_set_color(make_color_rgb(30, 34, 24));
    draw_rectangle(bx - 13, by - 5, bx + 13, by, false);
    // Rifle barrel poking out toward the player
    draw_set_color(make_color_rgb(25, 22, 18));
    draw_line_width(bx + f * 10, by - 4, bx + f * 20, by - 4, 2);
    // Faint eye glint in the dark
    draw_set_color(make_color_rgb(200, 190, 120));
    draw_rectangle(bx + f * 3, by - 8, bx + f * 5, by - 7, false);
    draw_set_alpha(1);

    if (hit_flash > 0) {
        draw_set_alpha(0.65);
        draw_set_color(c_white);
        draw_rectangle(bx - 16, by - 8, bx + 16, by, false);
        draw_rectangle(bx - 11, by - 12, bx + 11, by - 6, false);
        draw_set_alpha(1);
    }
    draw_set_color(c_white);
    exit;
}

// === STATE 1 — SPRUNG: rises out of the ground over spring_timer frames ===
var rise = (spring_timer > 0) ? (spring_timer / 12) * 22 : 0;   // sinks the body while popping up
var oy   = rise;

// Walk animation
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.016;
var leg_swing = sin(wp) * 6 * spd_ratio;
var body_bob  = abs(sin(wp)) * 1.5 * spd_ratio;

var bl_y = -leg_swing * 0.4;
var br_y =  leg_swing * 0.4;
var bob_off = body_bob + oy;

// === BOOTS ===
draw_set_color(make_color_rgb(20, 15, 10));
draw_rectangle(bx - 7, by - 5 + bl_y + oy, bx + 1, by + oy, false);
draw_rectangle(bx + 1, by - 5 + br_y + oy, bx + 7, by + oy, false);

// === PANTS (jungle camo tint) ===
draw_set_color(make_color_rgb(round(34 + hurt * 60), round(46 + hurt * 5), round(30 - hurt * 12)));
draw_rectangle(bx - 6, by - 15 + bl_y + oy, bx + 1, by - 5 + bl_y + oy, false);
draw_rectangle(bx + 1, by - 15 + br_y + oy, bx + 6, by - 5 + br_y + oy, false);

// === GHILLIE TORSO — ragged strips, wider than a soldier ===
draw_set_color(make_color_rgb(round(36 + hurt * 80), round(48 + hurt * 10), round(26 - hurt * 12)));
draw_rectangle(bx - 9, by - 26 + bob_off, bx + 9, by - 14 + bob_off, false);
// Hanging foliage strips
draw_set_color(make_color_rgb(30, 40, 22));
draw_rectangle(bx - 10, by - 22 + bob_off, bx - 7, by - 10 + bob_off, false);
draw_rectangle(bx + 7,  by - 22 + bob_off, bx + 10, by - 11 + bob_off, false);
draw_rectangle(bx - 3,  by - 15 + bob_off, bx + 1,  by - 8  + bob_off, false);

// === RIFLE ARM ===
draw_set_color(make_color_rgb(36, 46, 28));
draw_rectangle(bx + f * 4, by - 22 + bob_off, bx + f * 12, by - 18 + bob_off, false);
draw_set_color(make_color_rgb(25, 22, 18));
draw_line_width(bx + f * 6, by - 20 + bob_off, bx + f * 19, by - 20 + bob_off, 3);

// === REAR ARM ===
draw_set_color(make_color_rgb(34, 44, 26));
draw_rectangle(bx - f * 9, by - 21 + bob_off, bx - f * 4, by - 15 + bob_off, false);

// === HEAD — hooded, face darkened with paint ===
var hx = bx;
var hy = by - 30 + bob_off;
draw_set_color(make_color_rgb(96, 76, 54));
draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
// Ghillie hood over the head
draw_set_color(make_color_rgb(32, 42, 24));
draw_rectangle(hx - 7, hy - 4, hx + 7, hy + 3, false);
draw_rectangle(hx - 6, hy - 6, hx + 6, hy - 2, false);
// Pale eyes out of the dark face
draw_set_color(make_color_rgb(210, 200, 150));
draw_rectangle(hx + f * 1, hy + 4, hx + f * 4, hy + 6, false);

// === HIT FLASH — redraw silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 7, by - 5 + bl_y + oy, bx + 1, by + oy, false);
    draw_rectangle(bx + 1, by - 5 + br_y + oy, bx + 7, by + oy, false);
    draw_rectangle(bx - 6, by - 15 + bl_y + oy, bx + 1, by - 5 + bl_y + oy, false);
    draw_rectangle(bx + 1, by - 15 + br_y + oy, bx + 6, by - 5 + br_y + oy, false);
    draw_rectangle(bx - 9, by - 26 + bob_off, bx + 9, by - 14 + bob_off, false);
    draw_rectangle(bx + f * 4, by - 22 + bob_off, bx + f * 12, by - 18 + bob_off, false);
    draw_rectangle(bx - f * 9, by - 21 + bob_off, bx - f * 4, by - 15 + bob_off, false);
    draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
    draw_rectangle(hx - 7, hy - 4, hx + 7, hy + 3, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
