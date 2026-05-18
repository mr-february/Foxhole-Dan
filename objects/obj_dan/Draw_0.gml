var bx = x;
var by = y;
var f  = facing;

// === ANIMATION PHASE ===
var spd_ratio  = clamp(abs(hspd) / move_spd, 0, 1);
var wp         = current_time * 0.017;                    // walk phase
var leg_swing  = sin(wp) * 7 * spd_ratio;                // leg alternation
var leg_lift   = abs(sin(wp)) * 4 * spd_ratio;           // foot rises each step
var body_bob   = abs(sin(wp)) * 2 * spd_ratio;           // vertical bounce
var arm_back   = sin(wp + pi) * 6 * spd_ratio;           // free arm swings opposite legs
var breathe    = sin(current_time * 0.003) * 0.5;        // idle breathing offset

// Crouching offset
var crouch_y = crouching ? 8 : 0;

// I-frame blink
if (i_frames > 0 && (i_frames mod 6) < 3) {
    draw_set_color(c_white);
    draw_rectangle(bx - 10, by - 36 + crouch_y, bx + 10, by, false);
    draw_set_color(c_white);
} else {

    // === BOOTS ===
    // Left boot (back leg when walking, rises with phase)
    var bl_y = -leg_swing * 0.4 + leg_lift * 0.3;
    draw_set_color(make_color_rgb(48, 32, 18));
    draw_rectangle(bx - 8 - f * leg_swing * 0.2, by - 5 + crouch_y + bl_y,
                   bx + 1  - f * leg_swing * 0.2, by + crouch_y + bl_y, false);
    // Sole
    draw_set_color(make_color_rgb(30, 20, 10));
    draw_rectangle(bx - 9 - f * leg_swing * 0.2, by - 1 + crouch_y + bl_y,
                   bx + 1  - f * leg_swing * 0.2, by     + crouch_y + bl_y, false);

    // Right boot (front leg)
    var br_y = leg_swing * 0.4 - leg_lift * 0.3;
    draw_set_color(make_color_rgb(48, 32, 18));
    draw_rectangle(bx + 1 + f * leg_swing * 0.2, by - 5 + crouch_y + br_y,
                   bx + 8 + f * leg_swing * 0.2, by     + crouch_y + br_y, false);
    draw_set_color(make_color_rgb(30, 20, 10));
    draw_rectangle(bx,     by - 1 + crouch_y + br_y,
                   bx + 9 + f * leg_swing * 0.2, by + crouch_y + br_y, false);

    // === PANTS ===
    var pl_y = bl_y;
    var pr_y = br_y;
    draw_set_color(make_color_rgb(65, 80, 40));
    // Left leg
    draw_rectangle(bx - 7 - f * leg_swing * 0.15, by - 16 + crouch_y + pl_y,
                   bx + 1  - f * leg_swing * 0.15, by - 5  + crouch_y + pl_y, false);
    // Right leg
    draw_rectangle(bx + 1 + f * leg_swing * 0.15, by - 16 + crouch_y + pr_y,
                   bx + 7 + f * leg_swing * 0.15, by - 5  + crouch_y + pr_y, false);
    // Pocket
    draw_set_color(make_color_rgb(50, 62, 32));
    draw_rectangle(bx - 6, by - 13 + crouch_y, bx - 2, by - 9 + crouch_y, false);

    // === BODY / JACKET ===
    var bob_off = body_bob + breathe + crouch_y;
    var jacket_col = flashback_active
        ? make_color_rgb(100, 50, 30)
        : make_color_rgb(74, 100, 50);
    draw_set_color(jacket_col);
    draw_rectangle(bx - 9, by - 29 + bob_off, bx + 9, by - 15 + bob_off, false);

    // Chest webbing
    draw_set_color(make_color_rgb(55, 75, 38));
    draw_line(bx - 4, by - 28 + bob_off, bx + 4, by - 17 + bob_off);
    draw_line(bx + 4, by - 28 + bob_off, bx - 4, by - 17 + bob_off);
    // Ammo pouch
    draw_set_color(make_color_rgb(45, 62, 30));
    draw_rectangle(bx - 8, by - 24 + bob_off, bx - 4, by - 19 + bob_off, false);

    // === FREE ARM (swings opposite to aiming side) ===
    var fa_x = bx - f * 7;
    var fa_y = by - 22 + bob_off + arm_back;
    draw_set_color(make_color_rgb(74, 100, 50));
    draw_rectangle(fa_x - 3, fa_y - 2, fa_x + 3, fa_y + 6, false);
    // Hand
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_rectangle(fa_x - 2, fa_y + 4, fa_x + 2, fa_y + 8, false);

    // === GUN ARM ===
    var gun_arm_x = bx + f * 6;
    var gun_arm_y = by - 20 + bob_off;
    draw_set_color(make_color_rgb(180, 130, 90));
    draw_rectangle(gun_arm_x - 2, gun_arm_y - 2, gun_arm_x + f * 8 + 2, gun_arm_y + 3, false);
    // Rifle
    draw_set_color(make_color_rgb(35, 30, 25));
    var gun_end_x = bx + lengthdir_x(20, aim_dir);
    var gun_end_y = (by - 18 + bob_off) + lengthdir_y(20, aim_dir);
    draw_line_width(bx + f * 4, by - 18 + bob_off, gun_end_x, gun_end_y, 3);
    // Rifle barrel highlight
    draw_set_color(make_color_rgb(60, 58, 50));
    draw_line_width(bx + f * 6, by - 17 + bob_off, gun_end_x, gun_end_y - 1, 1);

    // === NECK ===
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_rectangle(bx - 3, by - 31 + bob_off, bx + 3, by - 29 + bob_off, false);

    // === HEAD ===
    // Head sways slightly during walk
    var head_sway = sin(wp) * 1.2 * spd_ratio;
    var hx = bx + head_sway;
    var hy = by - 32 + bob_off;

    // Skin
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_rectangle(hx - 6, hy, hx + 6, hy + 8, false);
    // Jaw shadow
    draw_set_color(make_color_rgb(155, 108, 65));
    draw_rectangle(hx - 5, hy + 6, hx + 5, hy + 8, false);
    // Eyes
    var ex_off = (f > 0) ? 1 : -1;
    draw_set_color(make_color_rgb(40, 40, 60));
    draw_rectangle(hx - 4 + ex_off, hy + 2, hx - 2 + ex_off, hy + 4, false);
    draw_rectangle(hx + 1 + ex_off, hy + 2, hx + 3 + ex_off, hy + 4, false);
    // Stubble
    draw_set_color(make_color_rgb(145, 100, 72));
    draw_rectangle(hx - 5, hy + 6, hx + 5, hy + 7, false);

    // === HELMET ===
    draw_set_color(make_color_rgb(55, 70, 32));
    draw_rectangle(hx - 7, hy - 7, hx + 7, hy + 1, false);
    draw_rectangle(hx - 6, hy - 9, hx + 6, hy - 5, false);
    // Helmet shadow underside
    draw_set_color(make_color_rgb(38, 50, 22));
    draw_rectangle(hx - 8, hy - 1, hx + 8, hy, false);
    // Helmet strap
    draw_set_color(make_color_rgb(100, 80, 50));
    draw_line(hx - 6, hy + 1, hx - 5, hy + 3);

    draw_set_color(c_white);
}

// === PTSD FLASHBACK OVERLAY ===
if (flashback_active) {
    var alpha = 0.05 + abs(sin(flashback_timer * 0.15)) * 0.08;
    draw_set_alpha(alpha);
    draw_set_color(c_red);
    var vx = camera_get_view_x(view_camera[0]);
    var vy = camera_get_view_y(view_camera[0]);
    draw_rectangle(vx, vy, vx + camera_get_view_width(view_camera[0]),
                   vy + camera_get_view_height(view_camera[0]), false);
    draw_set_alpha(1);
}

// === AIM LINE ===
draw_set_color(make_color_rgb(255, 220, 0));
draw_set_alpha(0.65);
var ax = bx + lengthdir_x(24, aim_dir);
var bob_off2 = abs(sin(current_time * 0.017)) * 2 * spd_ratio + breathe;
var ay = (by - 18 + bob_off2) + lengthdir_y(24, aim_dir);
draw_line_width(bx + f * 4, by - 18 + bob_off2, ax, ay, 1);
draw_set_alpha(1);
draw_set_color(c_white);
