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
    // Draw civilian (unarmed, hands up) instead of sniper
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

// === LASER TELEGRAPH — thin red line to the player while aiming ===
if (aiming && instance_exists(obj_dan)) {
    var _p     = instance_find(obj_dan, 0);
    var _lx    = bx + f * 26;
    var _ly    = by - 8;
    var _pulse = 0.45 + 0.35 * abs(sin(current_time * 0.02));
    draw_set_alpha(_pulse * 0.35);
    draw_set_color(make_color_rgb(255, 30, 30));
    draw_line_width(_lx, _ly, _p.x, _p.y - 12, 3);
    draw_set_alpha(_pulse);
    draw_line_width(_lx, _ly, _p.x, _p.y - 12, 1);
    // Red dot on the muzzle
    draw_circle(_lx, _ly, 2, false);
    draw_set_alpha(1);
}

// === PRONE / SCOPED SILHOUETTE — long and low ===
// Boots (trailing behind)
draw_set_color(make_color_rgb(20, 15, 10));
draw_rectangle(bx - f * 26, by - 4, bx - f * 22, by, false);
// Legs flat on the ground
draw_set_color(make_color_rgb(38, 46, 30));
draw_rectangle(bx - f * 22, by - 5, bx - f * 4, by, false);
// Torso — ghillie hump
draw_set_color(make_color_rgb(46, 58, 34));
draw_rectangle(bx - f * 6, by - 10, bx + f * 10, by, false);
// Ghillie fringe strips
draw_set_color(make_color_rgb(62, 74, 42));
draw_rectangle(bx - f * 8, by - 12, bx + f * 6, by - 8, false);
draw_rectangle(bx - f * 14, by - 7, bx - f * 10, by - 3, false);
// Head low behind the scope
draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(bx + f * 4, by - 15, bx + f * 10, by - 9, false);
// Boonie hat
draw_set_color(make_color_rgb(40, 48, 30));
draw_rectangle(bx + f * 2, by - 17, bx + f * 12, by - 14, false);
// Rifle — long barrel resting forward
draw_set_color(make_color_rgb(25, 22, 18));
draw_line_width(bx + f * 6, by - 8, bx + f * 30, by - 8, 2);
// Scope box
draw_set_color(make_color_rgb(30, 30, 32));
draw_rectangle(bx + f * 12, by - 12, bx + f * 17, by - 9, false);
// Scope glint
draw_set_color(make_color_rgb(140, 180, 200));
draw_rectangle(bx + f * 16, by - 11, bx + f * 17, by - 10, false);
// Bipod legs
draw_set_color(make_color_rgb(35, 35, 35));
draw_line(bx + f * 26, by - 7, bx + f * 24, by);
draw_line(bx + f * 26, by - 7, bx + f * 28, by);

// === HIT FLASH — redraw silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - f * 26, by - 4, bx - f * 22, by, false);
    draw_rectangle(bx - f * 22, by - 5, bx - f * 4, by, false);
    draw_rectangle(bx - f * 6, by - 10, bx + f * 10, by, false);
    draw_rectangle(bx - f * 8, by - 12, bx + f * 6, by - 8, false);
    draw_rectangle(bx + f * 4, by - 15, bx + f * 10, by - 9, false);
    draw_rectangle(bx + f * 2, by - 17, bx + f * 12, by - 14, false);
    draw_line_width(bx + f * 6, by - 8, bx + f * 30, by - 8, 2);
    draw_set_alpha(1);
}

draw_set_color(c_white);
