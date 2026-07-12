var bx = x, by = y, f = image_xscale;

// === VISION CONE — colored by alert state ===
var cone_col = make_color_rgb(120, 200, 120);          // calm = pale green
if (alert_state == 1) cone_col = make_color_rgb(230, 200, 70);   // suspicious = amber
if (alert_state == 2) cone_col = make_color_rgb(230, 60, 60);    // spotted = red
var fa0 = (f > 0) ? -view_cone : 180 - view_cone;
var fa1 = (f > 0) ?  view_cone : 180 + view_cone;
var ex0 = bx + lengthdir_x(view_dist, fa0), ey0 = (by - 20) + lengthdir_y(view_dist, fa0);
var ex1 = bx + lengthdir_x(view_dist, fa1), ey1 = (by - 20) + lengthdir_y(view_dist, fa1);
draw_set_alpha(0.12 + (alert_state * 0.05));
draw_set_color(cone_col);
draw_triangle(bx, by - 20, ex0, ey0, ex1, ey1, false);
draw_set_alpha(1);

// === CIVILIAN FLICKER (guilt bleed) ===
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
    draw_set_color(make_color_rgb(108, 116, 132));
    draw_rectangle(bx - 6, by - 24, bx + 6, by, false);
    draw_rectangle(bx - 5, by - 34, bx + 5, by - 24, false);
    draw_set_color(c_white);
    exit;
}

// === GUARD SILHOUETTE — dark suited sentry ===
draw_set_color(make_color_rgb(28, 30, 38));
draw_rectangle(bx - 9, by - 26, bx + 9, by, false);            // torso/legs
draw_set_color(make_color_rgb(40, 42, 52));
draw_rectangle(bx - 9, by - 26, bx + 9, by - 18, false);       // vest highlight
draw_set_color(make_color_rgb(150, 116, 90));
draw_rectangle(bx - 5, by - 38, bx + 5, by - 26, false);       // head
draw_set_color(make_color_rgb(24, 24, 28));
draw_rectangle(bx - 6, by - 40, bx + 6, by - 34, false);       // cap
// Rifle
draw_set_color(make_color_rgb(20, 18, 16));
draw_line_width(bx + f * 4, by - 20, bx + f * 26, by - 22, 3);

// === HIT FLASH ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 9, by - 26, bx + 9, by, false);
    draw_rectangle(bx - 5, by - 38, bx + 5, by - 26, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
