// === CIVILIAN FLICKER === (mirrors obj_enemy_soldier)
if (flicker_cd > 0) {
    flicker_cd--;
} else if (flicker_timer <= 0 && global.clarity_timer <= 0) {
    flicker_timer = 3;
    flicker_cd    = irandom_range(600, 1500);
    global.ptsd_flicker_count++;
    if (global.ptsd_flicker_count == 10) steam_set_achievement("ach_flicker");
}
if (flicker_timer > 0) {
    flicker_timer--;
    // Draw civilian (unarmed, hands up) instead of medic
    var bx = x;
    var by = y;
    var f  = image_xscale;
    draw_set_color(make_color_rgb(108, 116, 132));
    draw_rectangle(bx - 6, by - 24, bx + 6, by, false);
    draw_rectangle(bx - 14 * f, by - 24, bx - 6 * f, by - 18, false);
    draw_rectangle(bx + 6 * f,  by - 24, bx + 14 * f, by - 18, false);
    draw_rectangle(bx - 16 * f, by - 34, bx - 12 * f, by - 24, false);
    draw_rectangle(bx + 12 * f, by - 34, bx + 16 * f, by - 24, false);
    draw_set_color(make_color_rgb(196, 154, 104));
    draw_rectangle(bx - 5, by - 34, bx + 5, by - 24, false);
    draw_set_color(make_color_rgb(60, 46, 32));
    draw_rectangle(bx - 5, by - 36, bx + 5, by - 32, false);
    draw_set_color(c_white);
    exit;
}

var bx = x;
var by = y;
var f  = image_xscale;

// === HEAL PULSE FX — expanding green ring + cross above head ===
if (heal_fx > 0) {
    var _t = 1 - heal_fx / 22;
    draw_set_alpha(0.5 * (1 - _t));
    draw_set_color(make_color_rgb(80, 220, 120));
    draw_circle(bx, by - 14, 16 + _t * heal_radius, true);
    // Rising cross
    draw_set_alpha(0.8 * (1 - _t));
    var _cy = by - 42 - _t * 10;
    draw_rectangle(bx - 1, _cy - 4, bx + 1, _cy + 4, false);
    draw_rectangle(bx - 4, _cy - 1, bx + 4, _cy + 1, false);
    draw_set_alpha(1);
}

// Walk animation
var spd_ratio = (move_spd > 0) ? clamp(abs(hspd) / (move_spd * 1.4), 0, 1) : 0;
var wp        = current_time * 0.016;
var leg_swing = sin(wp) * 6 * spd_ratio;
var leg_lift  = abs(sin(wp)) * 3 * spd_ratio;
var bl_y = -leg_swing * 0.4 + leg_lift * 0.3;
var br_y =  leg_swing * 0.4 - leg_lift * 0.3;

// === MEDIC SILHOUETTE — lighter uniform, no gun, red-cross kit ===
// Boots
draw_set_color(make_color_rgb(30, 24, 18));
draw_rectangle(bx - 7, by - 5 + bl_y, bx, by + bl_y, false);
draw_rectangle(bx, by - 5 + br_y, bx + 7, by + br_y, false);
// Pants
draw_set_color(make_color_rgb(74, 78, 66));
draw_rectangle(bx - 6, by - 15 + bl_y, bx, by - 5 + bl_y, false);
draw_rectangle(bx, by - 15 + br_y, bx + 6, by - 5 + br_y, false);
// Jacket — pale field-grey
draw_set_color(make_color_rgb(96, 102, 88));
draw_rectangle(bx - 8, by - 26, bx + 8, by - 14, false);
// Medical satchel on the back
draw_set_color(make_color_rgb(78, 70, 54));
draw_rectangle(bx - f * 12, by - 24, bx - f * 8, by - 16, false);
draw_set_color(c_white);
draw_rectangle(bx - f * 11, by - 22, bx - f * 9, by - 18, false);
draw_set_color(make_color_rgb(200, 30, 30));
draw_rectangle(bx - f * 10.5, by - 21.5, bx - f * 9.5, by - 18.5, false);
// Arm forward, empty-handed (carrying dressings, not a rifle)
draw_set_color(make_color_rgb(96, 102, 88));
draw_rectangle(bx + f * 5, by - 23, bx + f * 11, by - 18, false);
// RED CROSS ARMBAND — the signature
draw_set_color(c_white);
draw_rectangle(bx + f * 5, by - 25, bx + f * 10, by - 20, false);
draw_set_color(make_color_rgb(200, 30, 30));
draw_rectangle(bx + f * 7, by - 25, bx + f * 8, by - 20, false);
draw_rectangle(bx + f * 5, by - 23, bx + f * 10, by - 22, false);
// Neck + head
draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(bx - 3, by - 28, bx + 3, by - 26, false);
draw_rectangle(bx - 5, by - 35, bx + 5, by - 27, false);
// Helmet with white circle + red cross
draw_set_color(make_color_rgb(70, 76, 64));
draw_rectangle(bx - 6, by - 39, bx + 6, by - 33, false);
draw_set_color(c_white);
draw_circle(bx, by - 36, 3, false);
draw_set_color(make_color_rgb(200, 30, 30));
draw_rectangle(bx - 1, by - 38, bx + 1, by - 34, false);
draw_rectangle(bx - 3, by - 37, bx + 3, by - 35, false);

// === HIT FLASH — redraw silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 7, by - 5 + bl_y, bx, by + bl_y, false);
    draw_rectangle(bx, by - 5 + br_y, bx + 7, by + br_y, false);
    draw_rectangle(bx - 6, by - 15 + bl_y, bx, by - 5 + bl_y, false);
    draw_rectangle(bx, by - 15 + br_y, bx + 6, by - 5 + br_y, false);
    draw_rectangle(bx - 8, by - 26, bx + 8, by - 14, false);
    draw_rectangle(bx - f * 12, by - 24, bx - f * 8, by - 16, false);
    draw_rectangle(bx + f * 5, by - 23, bx + f * 11, by - 18, false);
    draw_rectangle(bx - 5, by - 35, bx + 5, by - 27, false);
    draw_rectangle(bx - 6, by - 39, bx + 6, by - 33, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
