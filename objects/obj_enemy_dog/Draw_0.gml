var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step

// Health bleed — redder at low HP
var hurt = 1 - (hp / max_hp);

// Four-leg gallop — run_phase advanced in Step by speed
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var fl = sin(run_phase)          * 5 * spd_ratio;   // front pair
var hl = sin(run_phase + pi)     * 5 * spd_ratio;   // hind pair
var body_bob = abs(sin(run_phase)) * 1.5 * spd_ratio;

var body_top = by - 14 + body_bob;
var body_bot = by - 5  + body_bob;

// === LEGS (four, thin, animated) ===
draw_set_color(make_color_rgb(round(38 + hurt * 60), round(28 + hurt * 5), 20));
// Hind pair
draw_rectangle(bx - f * 10 + hl, body_bot - 2, bx - f * 7 + hl, by, false);
draw_rectangle(bx - f * 6 - hl,  body_bot - 2, bx - f * 3 - hl, by, false);
// Front pair
draw_rectangle(bx + f * 3 + fl,  body_bot - 2, bx + f * 6 + fl, by, false);
draw_rectangle(bx + f * 7 - fl,  body_bot - 2, bx + f * 10 - fl, by, false);

// === LOW BODY (long, four-legged silhouette) ===
draw_set_color(make_color_rgb(round(48 + hurt * 80), round(36 + hurt * 8), 24));
draw_rectangle(bx - f * 12, body_top, bx + f * 10, body_bot, false);
// Darker back stripe
draw_set_color(make_color_rgb(round(30 + hurt * 60), 22, 16));
draw_rectangle(bx - f * 12, body_top, bx + f * 10, body_top + 3, false);

// === TAIL (raised, flicks with gallop) ===
draw_set_color(make_color_rgb(round(40 + hurt * 60), 30, 20));
draw_line_width(bx - f * 12, body_top + 1, bx - f * 17, body_top - 4 + fl * 0.4, 3);

// === HEAD (thrust forward, low) ===
var hx = bx + f * 13;
var hy = body_top - 2 + body_bob * 0.5;
draw_set_color(make_color_rgb(round(52 + hurt * 80), round(38 + hurt * 8), 26));
draw_rectangle(hx - f * 3, hy, hx + f * 4, hy + 7, false);
// Snout
draw_rectangle(hx + f * 4, hy + 2, hx + f * 9, hy + 6, false);
// Ear (pinned back)
draw_set_color(make_color_rgb(round(34 + hurt * 60), 24, 18));
draw_rectangle(hx - f * 3, hy - 3, hx, hy + 1, false);
// Eye — mean glint
draw_set_color(make_color_rgb(200, 40, 30));
draw_rectangle(hx + f * 1, hy + 1, hx + f * 3, hy + 3, false);
// Bared teeth
draw_set_color(make_color_rgb(220, 214, 196));
draw_rectangle(hx + f * 5, hy + 5, hx + f * 9, hy + 6, false);

// === COLLAR (military K9) ===
draw_set_color(make_color_rgb(120, 16, 16));
draw_rectangle(bx + f * 9, body_top + 1, bx + f * 11, body_bot - 1, false);

// === HIT FLASH — redraw dog silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - f * 10 + hl, body_bot - 2, bx - f * 7 + hl, by, false);
    draw_rectangle(bx - f * 6 - hl,  body_bot - 2, bx - f * 3 - hl, by, false);
    draw_rectangle(bx + f * 3 + fl,  body_bot - 2, bx + f * 6 + fl, by, false);
    draw_rectangle(bx + f * 7 - fl,  body_bot - 2, bx + f * 10 - fl, by, false);
    draw_rectangle(bx - f * 12, body_top, bx + f * 10, body_bot, false);
    draw_rectangle(hx - f * 3, hy, hx + f * 4, hy + 7, false);
    draw_rectangle(hx + f * 4, hy + 2, hx + f * 9, hy + 6, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
