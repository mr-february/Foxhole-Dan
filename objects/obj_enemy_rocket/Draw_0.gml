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

// === BULKY SHOULDER-TUBE SILHOUETTE ===
// Boots
draw_set_color(make_color_rgb(20, 15, 10));
draw_rectangle(bx - 8, by - 5 + bl_y, bx, by + bl_y, false);
draw_rectangle(bx, by - 5 + br_y, bx + 8, by + br_y, false);
// Pants — wide stance
draw_set_color(make_color_rgb(44, 46, 40));
draw_rectangle(bx - 7, by - 15 + bl_y, bx, by - 5 + bl_y, false);
draw_rectangle(bx, by - 15 + br_y, bx + 7, by - 5 + br_y, false);
// Torso — bulky flak vest
draw_set_color(make_color_rgb(52, 56, 40));
draw_rectangle(bx - 10, by - 27, bx + 10, by - 14, false);
// Vest plates
draw_set_color(make_color_rgb(38, 42, 30));
draw_rectangle(bx - 8, by - 24, bx + 8, by - 20, false);
// Support arm forward under the tube
draw_set_color(make_color_rgb(52, 56, 40));
draw_rectangle(bx + f * 6, by - 26, bx + f * 14, by - 21, false);
// Head — tucked low against the tube
draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(bx - 4, by - 33, bx + 4, by - 26, false);
// Helmet
draw_set_color(make_color_rgb(28, 30, 28));
draw_rectangle(bx - 5, by - 36, bx + 5, by - 31, false);

// === RPG TUBE on the shoulder ===
draw_set_color(make_color_rgb(72, 66, 48));
draw_line_width(bx - f * 10, by - 34, bx + f * 20, by - 34, 6);
// Tube mouth (dark opening at the front)
draw_set_color(make_color_rgb(15, 15, 12));
draw_rectangle(bx + f * 18, by - 37, bx + f * 21, by - 31, false);
// Warhead cone poking out
draw_set_color(make_color_rgb(140, 60, 40));
draw_line_width(bx + f * 20, by - 34, bx + f * 26, by - 34, 3);
// Rear exhaust bell
draw_set_color(make_color_rgb(50, 46, 36));
draw_rectangle(bx - f * 13, by - 37, bx - f * 10, by - 31, false);

// Backblast flash right after launch
if (fire_anim > 0) {
    var _fa = fire_anim / 12;
    draw_set_alpha(0.7 * _fa);
    draw_set_color(make_color_rgb(255, 190, 90));
    draw_circle(bx - f * 16, by - 34, 5 + (1 - _fa) * 6, false);
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
    draw_rectangle(bx - 10, by - 27, bx + 10, by - 14, false);
    draw_rectangle(bx - 4, by - 33, bx + 4, by - 26, false);
    draw_rectangle(bx - 5, by - 36, bx + 5, by - 31, false);
    draw_line_width(bx - f * 10, by - 34, bx + f * 20, by - 34, 6);
    draw_set_alpha(1);
}

draw_set_color(c_white);
