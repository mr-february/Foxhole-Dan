var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === WIN SCREEN ===
if (global.game_state == 1) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0, 0, gw, gh, false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(200, 200, 60));
    draw_text_transformed(gw/2, gh/2 - 50, "SLIPPED THE NET", 2.4, 2.4, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 + 20, "Out the fire escape before they cleared the hall.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_text_transformed(gw/2, gh/2 + 58, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// === DEAD SCREEN ===
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(80, 0, 0)); draw_set_alpha(0.75); draw_rectangle(0, 0, gw, gh, false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 50, 50));
    draw_text_transformed(gw/2, gh/2 - 40, "FOXHOLE DAN DIDN'T MAKE IT", 1.7, 1.7, 0);
    draw_set_color(make_color_rgb(200, 180, 80));
    draw_text_transformed(gw/2, gh/2 + 30, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(160, 100, 100));
    draw_text_transformed(gw/2, gh/2 + 62, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// === HP BAR ===
var ax = 24, ay = 20;
if (instance_exists(obj_dan)) {
    var p = instance_find(obj_dan, 0);
    var hpct = clamp(p.hp / p.max_hp, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(ax, ay, ax + 220, ay + 18, false);
    draw_set_color(make_color_rgb(lerp(200, 40, hpct), lerp(40, 200, hpct), 40));
    draw_rectangle(ax, ay, ax + 220 * hpct, ay + 18, false);
    draw_set_color(c_white); draw_rectangle(ax, ay, ax + 220, ay + 18, true);
    draw_text(ax, ay + 22, "SCORE  " + string(global.score));
}

// === COMBO ===
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_text(ax, ay + 44, "COMBO  x" + string(global.combo_mult));
    var cb = clamp(global.combo_timer / 150, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(ax, ay + 62, ax + 100, ay + 68, false);
    draw_set_color(make_color_rgb(240, 160, 60)); draw_rectangle(ax, ay + 62, ax + 100 * cb, ay + 68, false);
    draw_set_color(c_white);
}

// === ALERT METER (top center) ===
var aw = 300, ah = 18, apx = gw/2 - aw/2, apy = 16;
var apct = clamp(global.stealth_alert / 100, 0, 1);
draw_set_color(c_dkgray); draw_rectangle(apx, apy, apx + aw, apy + ah, false);
draw_set_color(make_color_rgb(lerp(60, 230, apct), lerp(200, 40, apct), 40));
draw_rectangle(apx, apy, apx + aw * apct, apy + ah, false);
draw_set_color(c_white); draw_rectangle(apx, apy, apx + aw, apy + ah, true);
draw_set_halign(fa_center);
if (global.stealth_alert >= 100) {
    var pulse = abs(sin(current_time * 0.01));
    draw_set_color(make_color_rgb(255, 40 + 60 * pulse, 40 + 60 * pulse));
    draw_text_transformed(gw/2, apy + ah + 4, "DETECTED", 1.1, 1.1, 0);
} else {
    draw_set_color(make_color_rgb(200, 200, 200));
    draw_text_transformed(gw/2, apy + ah + 4, "ALERT", 0.8, 0.8, 0);
}
draw_set_halign(fa_left);

// === Objective hint ===
draw_set_color(make_color_rgb(150, 150, 160));
draw_text_transformed(gw - 360, gh - 34, "STAY IN SHADOW / CROUCH  —  reach the fire escape", 0.85, 0.85, 0);
draw_set_color(c_white);
