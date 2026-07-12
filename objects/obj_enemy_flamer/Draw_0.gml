var bx = x;
var by = y;
var f  = image_xscale;

// Walk animation
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.016;
var leg_swing = sin(wp) * 6 * spd_ratio;
var leg_lift  = abs(sin(wp)) * 3 * spd_ratio;
var bl_y = -leg_swing * 0.4 + leg_lift * 0.3;
var br_y =  leg_swing * 0.4 - leg_lift * 0.3;

// === TANK-ON-BACK SILHOUETTE — heavy rubberized suit ===
// Boots
draw_set_color(make_color_rgb(18, 16, 14));
draw_rectangle(bx - 8, by - 5 + bl_y, bx, by + bl_y, false);
draw_rectangle(bx, by - 5 + br_y, bx + 8, by + br_y, false);
// Heavy suit legs
draw_set_color(make_color_rgb(46, 40, 34));
draw_rectangle(bx - 7, by - 15 + bl_y, bx, by - 5 + bl_y, false);
draw_rectangle(bx, by - 15 + br_y, bx + 7, by - 5 + br_y, false);
// Torso — thick apron suit
draw_set_color(make_color_rgb(54, 46, 38));
draw_rectangle(bx - 9, by - 27, bx + 9, by - 14, false);
// Chest apron seam
draw_set_color(make_color_rgb(38, 32, 26));
draw_rectangle(bx - 9, by - 21, bx + 9, by - 19, false);

// === FUEL TANKS on the back — the signature ===
draw_set_color(make_color_rgb(88, 42, 24));
draw_rectangle(bx - f * 15, by - 28, bx - f * 10, by - 12, false);
draw_set_color(make_color_rgb(70, 34, 20));
draw_rectangle(bx - f * 19, by - 26, bx - f * 15, by - 12, false);
// Tank caps
draw_set_color(make_color_rgb(110, 100, 80));
draw_rectangle(bx - f * 15, by - 30, bx - f * 10, by - 28, false);
draw_rectangle(bx - f * 19, by - 28, bx - f * 15, by - 26, false);
// Warning stripe
draw_set_color(make_color_rgb(180, 140, 30));
draw_rectangle(bx - f * 19, by - 18, bx - f * 10, by - 16, false);

// Hose from tanks to the wand
draw_set_color(make_color_rgb(30, 26, 22));
draw_line_width(bx - f * 12, by - 13, bx + f * 2, by - 18, 2);
draw_line_width(bx + f * 2, by - 18, bx + f * 10, by - 20, 2);
// Both arms gripping the wand
draw_set_color(make_color_rgb(54, 46, 38));
draw_rectangle(bx + f * 3, by - 24, bx + f * 10, by - 18, false);
// Flame wand
draw_set_color(make_color_rgb(40, 38, 34));
draw_line_width(bx + f * 8, by - 20, bx + f * 20, by - 20, 3);
// Nozzle flare
draw_set_color(make_color_rgb(60, 56, 50));
draw_rectangle(bx + f * 19, by - 22, bx + f * 22, by - 18, false);

// Head — hooded with visor
draw_set_color(make_color_rgb(46, 40, 34));
draw_rectangle(bx - 5, by - 36, bx + 5, by - 27, false);
// Visor slit glowing faintly
draw_set_color(make_color_rgb(200, 120, 50));
draw_rectangle(bx - 3 + f, by - 33, bx + 4 + f, by - 31, false);

// Pilot light / spray glow at the nozzle
if (firing) {
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(255, 200, 90));
    draw_circle(bx + f * 23, by - 20, 3 + random(2), false);
    draw_set_alpha(1);
} else {
    draw_set_alpha(0.6 + 0.3 * abs(sin(current_time * 0.01)));
    draw_set_color(make_color_rgb(255, 160, 60));
    draw_circle(bx + f * 23, by - 20, 1.5, false);
    draw_set_alpha(1);
}

// === HIT FLASH — redraw silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 8, by - 5 + bl_y, bx, by + bl_y, false);
    draw_rectangle(bx, by - 5 + br_y, bx + 8, by + br_y, false);
    draw_rectangle(bx - 7, by - 15 + bl_y, bx, by - 5 + bl_y, false);
    draw_rectangle(bx, by - 15 + br_y, bx + 7, by - 5 + br_y, false);
    draw_rectangle(bx - 9, by - 27, bx + 9, by - 14, false);
    draw_rectangle(bx - f * 15, by - 28, bx - f * 10, by - 12, false);
    draw_rectangle(bx - f * 19, by - 26, bx - f * 15, by - 12, false);
    draw_rectangle(bx + f * 3, by - 24, bx + f * 10, by - 18, false);
    draw_rectangle(bx - 5, by - 36, bx + 5, by - 27, false);
    draw_line_width(bx + f * 8, by - 20, bx + f * 20, by - 20, 3);
    draw_set_alpha(1);
}

draw_set_color(c_white);
