var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === CUTSCENE — hand off to obj_cutscene's DrawGUI ===
if (global.game_state == 3) exit;

// === WIN SCREEN ===
if (global.game_state == 1) {
    draw_set_color(make_color_rgb(0, 0, 0));
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(200, 200, 60));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(gw/2, gh/2 - 60, "LEVEL 1 COMPLETE", 2.5, 2.5, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2, "You survived.", 1.2, 1.2, 0);
    draw_text_transformed(gw/2, gh/2 + 40, "The war is over for now.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(160, 160, 100));
    draw_text_transformed(gw/2, gh/2 + 90, "Press R to play again", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === DEAD SCREEN ===
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(80, 0, 0));
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_color(make_color_rgb(220, 50, 50));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(gw/2, gh/2 - 50, "FOXHOLE DAN DIDN'T MAKE IT", 1.8, 1.8, 0);
    draw_set_color(make_color_rgb(180, 130, 130));
    draw_text_transformed(gw/2, gh/2 + 20, "Some battles can't be won.", 1.1, 1.1, 0);
    draw_set_color(make_color_rgb(160, 100, 100));
    draw_text_transformed(gw/2, gh/2 + 70, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === HUD (playing) ===
var p = instance_find(obj_dan, 0);
if (p == noone) exit;

// --- HP BAR ---
var bx  = 16;
var by  = 16;
var bw  = 200;
var bh  = 16;
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

// --- PTSD METER ---
var px  = 16;
var py  = by + bh + 10;
var pw  = 200;
var ph  = 14;
var ptsd_pct = p.ptsd_meter / p.ptsd_max;
var ptsd_col = make_color_rgb(
    80 + 170 * ptsd_pct,
    max(0, 60 - 60 * ptsd_pct),
    max(0, 20 - 20 * ptsd_pct)
);

draw_set_color(c_dkgray);
draw_rectangle(px, py, px + pw, py + ph, false);
draw_set_color(ptsd_col);
draw_rectangle(px, py, px + pw * ptsd_pct, py + ph, false);
// Pulse at high stress
if (ptsd_pct > 0.7) {
    var pulse_a = abs(sin(current_time * 0.01)) * 0.4;
    draw_set_alpha(pulse_a);
    draw_set_color(c_red);
    draw_rectangle(px, py, px + pw * ptsd_pct, py + ph, false);
    draw_set_alpha(1);
}
draw_set_color(make_color_rgb(180, 60, 60));
draw_rectangle(px, py, px + pw, py + ph, true);
draw_set_color(make_color_rgb(220, 100, 100));
draw_text(px, py - 13, "PTSD");

// --- AMMO ---
var ax  = 16;
var ay  = py + ph + 10;
if (p.reload_timer > 0) {
    // Reload bar
    var rl_pct = 1 - (p.reload_timer / 110);
    draw_set_color(c_dkgray);
    draw_rectangle(ax, ay, ax + 200, ay + 14, false);
    draw_set_color(make_color_rgb(220, 180, 40));
    draw_rectangle(ax, ay, ax + 200 * rl_pct, ay + 14, false);
    draw_set_color(c_white);
    draw_rectangle(ax, ay, ax + 200, ay + 14, true);
    draw_set_color(make_color_rgb(255, 200, 60));
    draw_set_halign(fa_center);
    draw_text(ax + 100, ay, "RELOADING...");
    draw_set_halign(fa_left);
} else {
    draw_set_color(make_color_rgb(200, 160, 40));
    draw_text(ax, ay, "AMMO  " + string(p.ammo) + " / " + string(p.max_ammo));
}

// --- BOSS HEALTH BAR (top center) ---
var boss = instance_find(obj_boss, 0);
if (boss != noone) {
    var boss_pct = boss.hp / boss.max_hp;
    var bbw = 400;
    var bbh = 20;
    var bbx = gw / 2 - bbw / 2;
    var bby = 12;

    draw_set_color(c_dkgray);
    draw_rectangle(bbx, bby, bbx + bbw, bby + bbh, false);

    var boss_col = (boss.phase == 2) ? make_color_rgb(200, 30, 30) : make_color_rgb(140, 0, 0);
    if (boss.phase == 2) {
        var rage_pulse = abs(sin(current_time * 0.01)) * 0.4;
        boss_col = make_color_rgb(200 + 55 * rage_pulse, 30, 30);
    }
    draw_set_color(boss_col);
    draw_rectangle(bbx, bby, bbx + bbw * boss_pct, bby + bbh, false);

    draw_set_color(make_color_rgb(180, 0, 0));
    draw_rectangle(bbx, bby, bbx + bbw, bby + bbh, true);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    var boss_label = (boss.phase == 2) ? "THE SERGEANT  [ENRAGED]" : "THE SERGEANT";
    draw_text_transformed(gw / 2, bby + 2, boss_label, 0.9, 0.9, 0);
    draw_set_halign(fa_left);
}

// --- FLASHBACK WARNING ---
if (p.flashback_active) {
    var pulse = abs(sin(current_time * 0.008));
    draw_set_color(c_red);
    draw_set_alpha(0.2 + pulse * 0.25);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(255, 60, 60));
    draw_set_halign(fa_center);
    draw_text_transformed(gw/2, 80, "FLASHBACK", 2, 2, 0);
    draw_set_halign(fa_left);
}

// --- CONTROL LEGEND (bottom-left) ---
draw_set_color(make_color_rgb(110, 110, 110));
draw_set_alpha(0.65);
var leg_y = gh - 52;
if (gamepad_is_connected(0)) {
    draw_text(16, leg_y,      "L-Stick Move/Crouch  |  A Jump  |  RT/RB Shoot  |  R-Stick Aim");
} else {
    draw_text(16, leg_y,      "WASD/Arrows Move  |  Space Jump  |  J/LMB Shoot  |  Move keys Aim (8-way)");
}
draw_set_alpha(1);

// Low HP vignette
if (p.hp < p.max_hp * 0.35) {
    var _low_r = p.hp / (p.max_hp * 0.35);
    var _low_p = abs(sin(current_time * 0.012)) * (1.0 - _low_r) * 0.55;
    draw_set_color(make_color_rgb(140, 0, 0));
    draw_set_alpha(0.22 + _low_p);
    draw_rectangle(0,       0,  gw,     70, false);
    draw_rectangle(0,  gh-70,  gw,     gh, false);
    draw_rectangle(0,       0,  70,     gh, false);
    draw_rectangle(gw-70,   0,  gw,     gh, false);
    draw_set_alpha(1);
}
// Damage flash
if (p.i_frames > 25) {
    var _dfa = ((p.i_frames - 25) / 15.0) * 0.30;
    draw_set_color(make_color_rgb(200, 15, 15));
    draw_set_alpha(_dfa);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// PTSD edge distortion
var _pct = p.ptsd_meter / p.ptsd_max;
if (_pct > 0.55) {
    var _pa = (_pct - 0.55) * 0.65;
    var _pp = abs(sin(current_time * 0.006)) * _pa;
    draw_set_color(make_color_rgb(35, 0, 55));
    draw_set_alpha(_pp);
    draw_rectangle(0,       0,  gw,     90, false);
    draw_rectangle(0,  gh-90,  gw,     gh, false);
    draw_rectangle(0,       0,  90,     gh, false);
    draw_rectangle(gw-90,   0,  gw,     gh, false);
    draw_set_alpha(1);
}
// Chromatic aberration
if (_pct > 0.70) {
    var _ca  = (_pct - 0.70) * 3.33 * abs(sin(current_time * 0.003));
    var _off = ceil(_ca * 5);
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.06 * _ca);
    draw_set_color(make_color_rgb(255, 0, 0));
    draw_rectangle(-_off, 0, gw - _off, gh, false);
    draw_set_color(make_color_rgb(0, 0, 255));
    draw_rectangle(_off, 0, gw + _off, gh, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}
// Explosion flash
if (global.flash_timer > 0) {
    draw_set_color(make_color_rgb(255, 165, 30));
    draw_set_alpha((global.flash_timer / 14.0) * 0.45);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
