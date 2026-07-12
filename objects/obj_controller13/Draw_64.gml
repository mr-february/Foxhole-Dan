var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === SUMMIT TRANSITION (game_state 1 = Dan reached the top) ===
if (global.game_state == 1) {
    // Fade in dark overlay
    var _fa = clamp(transition_timer / 60.0, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.86 * _fa);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_fa);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(200, 225, 250));
    draw_text_transformed(gw/2, gh/2 - 70, "THE SUMMIT", 2.8, 2.8, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2,      "The wind died. Through the snow — a light in the window.", 1.2, 1.2, 0);
    draw_set_color(make_color_rgb(160, 180, 200));
    draw_text_transformed(gw/2, gh/2 + 50, "Home. After everything, home.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220, 60, 60));
    draw_text_transformed(gw/2, gh/2 + 100, "Headlights were already climbing the road behind him.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    exit;
}

// === DEAD SCREEN ===
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(10, 20, 40));
    draw_set_alpha(0.80);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(190, 215, 240));
    draw_text_transformed(gw/2, gh/2 - 50, "THE MOUNTAIN KEPT HIM", 2.0, 2.0, 0);
    draw_set_color(make_color_rgb(140, 160, 185));
    draw_text_transformed(gw/2, gh/2 + 20, "The snow closed over him, quiet as a held breath.", 1.1, 1.1, 0);
    draw_set_color(make_color_rgb(200, 180, 80));
    draw_text_transformed(gw/2, gh/2 + 48, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(150, 165, 185));
    draw_text_transformed(gw/2, gh/2 + 80, "Press R to climb again", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === PLAYING HUD ===
var p = instance_find(obj_dan, 0);
if (p == noone) exit;

// --- FALLING SNOW (GUI-space, drifts sideways) ---
var _st = current_time * 0.001;
draw_set_color(c_white);
for (var _si = 0; _si < 90; _si++) {
    var _drift = sin(_st * 0.8 + _si) * 30;
    var _sx = ((_si * 331 + _drift) mod (gw + 60)) - 30;
    var _sy = (_st * (60 + (_si mod 7) * 22) + _si * 149) mod (gh + 40) - 20;
    draw_set_alpha(0.12 + (_si mod 5) * 0.05);
    draw_circle(_sx, _sy, 1 + (_si mod 3), false);
}
draw_set_alpha(1);

// --- AVALANCHE WARNING (telegraph phase) ---
var _av_warn = false;
with (obj_avalanche) {
    if (!active) _av_warn = true;
}
if (_av_warn) {
    var _wp = abs(sin(current_time * 0.02));
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_set_alpha(0.25 + _wp * 0.30);
    draw_rectangle(0, 0, gw, 46, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 30, 30));
    draw_set_halign(fa_center);
    draw_text_transformed(gw / 2, 54, "AVALANCHE!  GET UNDER COVER", 1.5, 1.5, 0);
    draw_set_halign(fa_left);
}

// --- WIND INDICATOR (when a gust is pushing Dan) ---
var _wind = 0;
with (obj_wind_zone) {
    if (gusting && gust_pct > 0.3
        && p.x > x && p.x < x + zone_w
        && p.y - 16 > y && p.y - 16 < y + zone_h) {
        _wind = wind_dir;
    }
}
if (_wind != 0) {
    draw_set_color(make_color_rgb(180, 215, 245));
    draw_set_alpha(0.5 + abs(sin(current_time * 0.012)) * 0.4);
    draw_set_halign(fa_center);
    var _arrows = (_wind > 0) ? ">>  WIND  >>" : "<<  WIND  <<";
    draw_text_transformed(gw / 2, gh - 84, _arrows, 1.1, 1.1, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}

// --- HP BAR ---
var bx     = 16;
var by     = 16;
var bw     = 200;
var bh     = 16;
var hp_pct = p.hp / p.max_hp;

draw_set_color(c_dkgray);
draw_rectangle(bx, by, bx + bw, by + bh, false);
draw_set_color(make_color_hsv(hp_pct * 85, 220, 220));
draw_rectangle(bx, by, bx + bw * hp_pct, by + bh, false);
draw_set_color(c_white);
draw_rectangle(bx, by, bx + bw, by + bh, true);
draw_set_color(c_ltgray);
draw_text(bx, by - 14, "HP");
draw_text(bx + bw + 4, by + 1, string(max(0, floor(p.hp))) + "/" + string(p.max_hp));

// --- SCORE ---
var ax = 16;
var ay = by + bh + 12;
draw_set_color(make_color_rgb(220, 220, 80));
draw_text(ax, ay, "SCORE  " + string(global.score));

// --- COMBO ---
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_text(ax, ay + 18, "COMBO  x" + string(global.combo_mult));
    var cb_pct = clamp(global.combo_timer / 150, 0, 1);
    draw_set_color(c_dkgray);
    draw_rectangle(ax, ay + 36, ax + 100, ay + 42, false);
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_rectangle(ax, ay + 36, ax + 100 * cb_pct, ay + 42, false);
    draw_set_color(c_white);
}

// --- CLIMB PROGRESS BAR (top center) ---
var pbw = 360;
var pbh = 18;
var pbx = gw / 2 - pbw / 2;
var pby = 12;

draw_set_color(c_dkgray);
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, false);
draw_set_color(make_color_rgb(150, 200, 245));
draw_rectangle(pbx, pby, pbx + pbw * climb_pct, pby + pbh, false);
draw_set_color(make_color_rgb(80, 130, 190));
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, true);
// Home marker at the end of the bar
draw_set_color(make_color_rgb(255, 220, 120));
draw_rectangle(pbx + pbw - 3, pby - 3, pbx + pbw + 3, pby + pbh + 3, false);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(gw / 2, pby + 2, "THE CLIMB  " + string(floor(climb_pct * 100)) + "%", 0.88, 0.88, 0);
draw_set_color(make_color_rgb(170, 195, 220));
draw_text_transformed(gw / 2, pby + pbh + 6, "LEVEL " + string(level_no) + " — THE MOUNTAIN", 0.78, 0.78, 0);
draw_set_halign(fa_left);

// --- CONTROL LEGEND ---
draw_set_color(make_color_rgb(110, 110, 110));
draw_set_alpha(0.65);
var leg_y = gh - 40;
if (gamepad_is_connected(0)) {
    draw_text(16, leg_y, "L-Stick Move  |  A Jump  |  L3 Roll  |  Shelter under rocks when the snow comes");
} else {
    draw_text(16, leg_y, "WASD Move  |  Space Jump  |  Shift Roll  |  Shelter under rocks when the snow comes");
}
draw_set_alpha(1);

// --- Low HP vignette (frostbite blue) ---
if (p.hp < p.max_hp * 0.35) {
    var _low_r = p.hp / (p.max_hp * 0.35);
    var _low_p = abs(sin(current_time * 0.012)) * (1.0 - _low_r) * 0.55;
    draw_set_color(make_color_rgb(20, 40, 90));
    draw_set_alpha(0.22 + _low_p);
    draw_rectangle(0,       0,  gw,     70, false);
    draw_rectangle(0,  gh-70,  gw,     gh, false);
    draw_rectangle(0,       0,  70,     gh, false);
    draw_rectangle(gw-70,   0,  gw,     gh, false);
    draw_set_alpha(1);
}
// --- Damage flash ---
if (p.i_frames > 25) {
    var _dfa = ((p.i_frames - 25) / 20.0) * 0.30;
    draw_set_color(make_color_rgb(200, 15, 15));
    draw_set_alpha(_dfa);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// --- Explosion flash ---
if (global.flash_timer > 0) {
    draw_set_color(make_color_rgb(230, 240, 255));
    draw_set_alpha((global.flash_timer / 14.0) * 0.35);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
