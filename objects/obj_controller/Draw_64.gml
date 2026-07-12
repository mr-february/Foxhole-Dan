var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === CUTSCENE — hand off to obj_cutscene's DrawGUI ===
if (global.game_state == 3) exit;

// === PAUSE OVERLAY ===
if (global.game_state == 4) {
    var _mid = gw * 0.5;
    draw_set_alpha(0.80);
    draw_set_color(make_color_rgb(4, 5, 14));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(165, 135, 38));
    draw_rectangle(_mid - 360, gh * 0.12, _mid + 360, gh * 0.88, true);
    draw_set_color(make_color_rgb(80, 60, 14));
    draw_rectangle(_mid - 356, gh * 0.124, _mid + 356, gh * 0.876, true);

    draw_set_color(make_color_rgb(225, 198, 82));
    draw_text_transformed(_mid, gh * 0.21, "PAUSED", 3.0, 3.0, 0);
    draw_set_color(make_color_rgb(90, 72, 22));
    draw_rectangle(_mid - 290, gh * 0.295, _mid + 290, gh * 0.298, false);

    if (!pause_settings) {
        var _items = ["RESUME",  "SETTINGS",  "QUIT TO MENU"];
        var _cols  = [
            make_color_rgb(220, 215, 100),
            make_color_rgb(155, 195, 240),
            make_color_rgb(210, 95, 75)
        ];
        for (var _pi = 0; _pi < 3; _pi++) {
            var _py  = gh * (0.38 + _pi * 0.155);
            var _sel = (_pi == pause_sel);
            var _sc  = _sel ? 1.50 : 1.05;
            draw_set_alpha(_sel ? 1.0 : 0.42);
            draw_set_color(_cols[_pi]);
            draw_text_transformed(_mid, _py, _items[_pi], _sc, _sc, 0);
            if (_sel) {
                draw_set_alpha(0.85);
                draw_text_transformed(_mid - 210, _py, ">", _sc, _sc, 0);
                draw_text_transformed(_mid + 210, _py, "<", _sc, _sc, 0);
            }
        }
        draw_set_alpha(0.45);
        draw_set_color(make_color_rgb(165, 148, 75));
        draw_text_transformed(_mid, gh * 0.83, "W/S  Navigate    Space  Confirm    ESC  Resume", 0.88, 0.88, 0);
    } else {
        draw_set_color(make_color_rgb(190, 172, 95));
        draw_text_transformed(_mid, gh * 0.30, "SETTINGS", 1.45, 1.45, 0);
        draw_set_color(make_color_rgb(70, 56, 18));
        draw_rectangle(_mid - 250, gh * 0.335, _mid + 250, gh * 0.338, false);

        var _sw     = 260;
        var _sh     = 18;
        var _labels = ["MUSIC", "SFX", "SCREEN SHAKE"];
        var _vals   = [global.vol_music, global.vol_sfx, global.shake_intensity];

        for (var _si = 0; _si < 3; _si++) {
            var _sy   = gh * (0.38 + _si * 0.085);
            var _ssel = (_si == pause_settings_sel);
            var _sx   = _mid - _sw * 0.5;

            draw_set_alpha(_ssel ? 1.0 : 0.48);
            draw_set_color(_ssel ? make_color_rgb(230, 208, 88) : make_color_rgb(155, 138, 72));
            draw_text_transformed(_sx - 118, _sy + 1, _labels[_si], _ssel ? 1.0 : 0.88, _ssel ? 1.0 : 0.88, 0);

            draw_set_color(make_color_rgb(24, 20, 12));
            draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
            draw_set_color(_ssel ? make_color_rgb(218, 176, 38) : make_color_rgb(110, 92, 24));
            draw_rectangle(_sx, _sy, _sx + _sw * _vals[_si], _sy + _sh, false);
            draw_set_color(_ssel ? make_color_rgb(220, 198, 72) : make_color_rgb(80, 68, 22));
            draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, true);

            draw_set_halign(fa_left);
            draw_set_color(_ssel ? c_white : make_color_rgb(162, 148, 108));
            draw_text_transformed(_sx + _sw + 14, _sy - 1, string(floor(_vals[_si] * 100)) + "%", 0.85, 0.85, 0);
            draw_set_halign(fa_center);

            if (_ssel) {
                draw_set_alpha(0.88);
                draw_set_color(make_color_rgb(230, 208, 88));
                draw_text_transformed(_sx - 18, _sy + 8, "<", 1.1, 1.1, 0);
                draw_text_transformed(_sx + _sw + 60, _sy + 8, ">", 1.1, 1.1, 0);
            }
            draw_set_alpha(1);
        }

        // === KEY REMAP ROWS ===
        var _rlabels = ["JUMP", "SHOOT", "GRENADE", "ROLL"];
        var _rkeys   = [global.key_jump, global.key_shoot, global.key_grenade, global.key_roll];
        for (var _ri = 0; _ri < 4; _ri++) {
            var _rsel = (pause_settings_sel == 3 + _ri);
            var _ry   = gh * (0.38 + 3 * 0.085 + 0.02 + _ri * 0.072);

            var _kc = _rkeys[_ri];
            var _kname;
            if (_kc == vk_space)        _kname = "SPACE";
            else if (_kc == vk_shift)   _kname = "SHIFT";
            else if (_kc == vk_control) _kname = "CTRL";
            else if (_kc == vk_return)  _kname = "ENTER";
            else if (_kc == vk_tab)     _kname = "TAB";
            else if (_kc == vk_up)      _kname = "UP";
            else if (_kc == vk_down)    _kname = "DOWN";
            else if (_kc == vk_left)    _kname = "LEFT";
            else if (_kc == vk_right)   _kname = "RIGHT";
            else if (_kc >= 48 && _kc <= 90) _kname = chr(_kc);
            else _kname = "KEY" + string(_kc);

            draw_set_alpha(_rsel ? 1.0 : 0.48);
            draw_set_color(_rsel ? make_color_rgb(230, 208, 88) : make_color_rgb(155, 138, 72));
            draw_text_transformed(_mid - 118, _ry, _rlabels[_ri], _rsel ? 1.0 : 0.88, _rsel ? 1.0 : 0.88, 0);

            draw_set_color(make_color_rgb(24, 20, 12));
            draw_rectangle(_mid + 20, _ry - 10, _mid + 120, _ry + 10, false);
            draw_set_color(_rsel ? make_color_rgb(220, 198, 72) : make_color_rgb(80, 68, 22));
            draw_rectangle(_mid + 20, _ry - 10, _mid + 120, _ry + 10, true);
            draw_set_color(_rsel ? c_white : make_color_rgb(162, 148, 108));
            draw_text_transformed(_mid + 70, _ry, (_rsel && remap_waiting) ? "..." : _kname, 0.95, 0.95, 0);
            draw_set_alpha(1);
        }

        if (remap_waiting) {
            var _bp = 0.6 + abs(sin(current_time * 0.012)) * 0.4;
            draw_set_alpha(_bp);
            draw_set_color(make_color_rgb(230, 208, 88));
            draw_text_transformed(_mid, gh * 0.79, "PRESS A KEY  (ESC to cancel)", 0.9, 0.9, 0);
            draw_set_alpha(1);
        } else {
            draw_set_alpha(0.45);
            draw_set_color(make_color_rgb(165, 148, 75));
            draw_text_transformed(_mid, gh * 0.83, "W/S  Switch    A/D  Adjust    Space  Rebind    ESC  Back", 0.82, 0.82, 0);
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

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
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_text_transformed(gw/2, gh/2 + 68, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(200, 190, 100));
    draw_text_transformed(gw/2, gh/2 + 100, "PRESS R TO CONTINUE", 0.85, 0.85, 0);
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
    draw_set_color(make_color_rgb(200, 180, 80));
    draw_text_transformed(gw/2, gh/2 + 48, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(210, 130, 130));
    draw_text_transformed(gw/2, gh/2 + 80, "PRESS R TO RETRY", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === PTSD TEXT FRAGMENT ===
if (ptsd_text_active > 0) {
    var _fade = min(ptsd_text_active / 25.0, 1.0);
    if (ptsd_text_active < 35) _fade = ptsd_text_active / 35.0;
    draw_set_alpha(_fade * 0.52);
    draw_set_color(make_color_rgb(220, 210, 185));
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_font(-1);
    draw_text_transformed(44, gh - 24, ptsd_text_msg, 0.88, 0.88, 0);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
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
draw_set_color(make_color_rgb(18, 18, 14));
for (var _tk = 1; _tk < 4; _tk++) {
    draw_line(bx + bw * _tk / 4, by + 1, bx + bw * _tk / 4, by + bh - 1);
}
draw_set_color(c_white);
draw_rectangle(bx, by, bx + bw, by + bh, true);
draw_set_color(make_color_rgb(130, 145, 110));
draw_line(bx - 4, by - 3, bx - 4, by + bh + 3);
draw_line(bx + bw + 4, by - 3, bx + bw + 4, by + bh + 3);
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
draw_set_color(make_color_rgb(18, 14, 14));
for (var _tk2 = 1; _tk2 < 4; _tk2++) {
    draw_line(px + pw * _tk2 / 4, py + 1, px + pw * _tk2 / 4, py + ph - 1);
}
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

// --- GRENADES ---
draw_set_color(make_color_rgb(160, 200, 80));
draw_text(ax, ay + 18, "GRENADES  " + string(p.grenade_count));

// --- SCORE ---
draw_set_color(make_color_rgb(220, 220, 80));
draw_text(ax, ay + 36, "SCORE  " + string(global.score));

// --- COMBO ---
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_text(ax, ay + 54, "COMBO  x" + string(global.combo_mult));
    var cb_pct = clamp(global.combo_timer / 150, 0, 1);
    draw_set_color(c_dkgray);
    draw_rectangle(ax, ay + 72, ax + 100, ay + 78, false);
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_rectangle(ax, ay + 72, ax + 100 * cb_pct, ay + 78, false);
    draw_set_color(c_white);
}

// --- KILL STREAK ---
if (global.streak >= 2 && global.streak_timer > 0) {
    var _ka = min(global.streak_timer / 60.0, 1.0);
    var _ks = 1.15 + min(global.streak, 12) * 0.05;
    var _kg = max(0, 200 - global.streak * 18);
    draw_set_halign(fa_right);
    draw_set_alpha(_ka);
    draw_set_color(make_color_rgb(10, 10, 10));
    draw_text_transformed(gw - 18, 78, "x" + string(global.streak) + "  STREAK", _ks, _ks, 0);
    draw_set_color(make_color_rgb(255, _kg + 40, 40));
    draw_text_transformed(gw - 20, 76, "x" + string(global.streak) + "  STREAK", _ks, _ks, 0);
    if (global.streak >= 5) {
        draw_set_alpha(_ka * (0.55 + abs(sin(current_time * 0.01)) * 0.45));
        draw_set_color(make_color_rgb(255, 70, 30));
        draw_text_transformed(gw - 20, 76 + 26 * _ks, "RELENTLESS", 0.85, 0.85, 0);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

// --- RAGE MODE DISPLAY ---
if (global.rage_timer > 0) {
    var _rp   = abs(sin(current_time * 0.018));
    var _rcol = make_color_rgb(255, 60 + floor(_rp * 80), 0);
    draw_set_halign(fa_right);
    draw_set_alpha(0.8 + _rp * 0.2);
    draw_set_color(make_color_rgb(40, 0, 0));
    draw_text_transformed(gw - 18, 26, "!! RAGE MODE !!", 1.8, 1.8, 0);
    draw_set_color(_rcol);
    draw_text_transformed(gw - 20, 24, "!! RAGE MODE !!", 1.8, 1.8, 0);
    var _rbw = 200;
    var _rbx = gw - 20 - _rbw;
    var _rby = 58;
    var _rpct = global.rage_timer / 360.0;
    draw_set_color(make_color_rgb(40, 0, 0));
    draw_rectangle(_rbx, _rby, _rbx + _rbw, _rby + 10, false);
    draw_set_color(_rcol);
    draw_rectangle(_rbx, _rby, _rbx + _rbw * _rpct, _rby + 10, false);
    draw_set_color(make_color_rgb(180, 40, 0));
    draw_rectangle(_rbx, _rby, _rbx + _rbw, _rby + 10, true);
    draw_set_alpha(0.12 + _rp * 0.10);
    draw_set_color(make_color_rgb(200, 30, 0));
    draw_rectangle(0,      0,  gw,    60, false);
    draw_rectangle(0, gh-60,  gw,    gh, false);
    draw_rectangle(0,      0,  60,    gh, false);
    draw_rectangle(gw-60,  0,  gw,    gh, false);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
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

    var boss_col = (boss.phase >= 2) ? make_color_rgb(200, 30, 30) : make_color_rgb(140, 0, 0);
    if (boss.phase >= 2) {
        var rage_pulse = abs(sin(current_time * 0.01)) * 0.4;
        boss_col = make_color_rgb(200 + 55 * rage_pulse, 30, 30);
    }
    draw_set_color(boss_col);
    draw_rectangle(bbx, bby, bbx + bbw * boss_pct, bby + bbh, false);

    draw_set_color(make_color_rgb(180, 0, 0));
    draw_rectangle(bbx, bby, bbx + bbw, bby + bbh, true);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    var boss_label = "THE SERGEANT";
    if (boss.phase == 2) boss_label = "THE SERGEANT  [ENRAGED]";
    if (boss.phase == 3) boss_label = "THE SERGEANT  [NOTHING LEFT TO LOSE]";
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
    draw_text(16, leg_y,      "WASD/Arrows Move  |  Space Jump  |  J/LMB Shoot  |  Move keys Aim  |  K Grenade  |  G Hook");
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
// PTSD color drain — the world washes out as stress rises
var _pct = p.ptsd_meter / p.ptsd_max;
if (_pct > 0.60) {
    draw_set_color(make_color_rgb(112, 112, 118));
    draw_set_alpha((_pct - 0.60) * 0.50);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// PTSD edge distortion
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
// Kill flash — brief white/orange punch on every kill
if (global.kill_flash_timer > 0) {
    global.kill_flash_timer--;
    var _kfa = (global.kill_flash_timer + 1) / 5.0;
    draw_set_color(global.rage_timer > 0 ? make_color_rgb(255, 140, 0) : c_white);
    draw_set_alpha(_kfa * (global.rage_timer > 0 ? 0.45 : 0.28));
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// Pickup flash — colored bloom when collecting medkit / ammo / clarity
if (global.pickup_flash_timer > 0) {
    global.pickup_flash_timer--;
    draw_set_color(global.pickup_flash_col);
    draw_set_alpha((global.pickup_flash_timer / 26.0) * 0.32);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// Memory fragment / checkpoint text
if (global.memory_timer > 0) {
    global.memory_timer--;
    var _mf   = min(global.memory_timer / 40.0, 1.0) * min((210 - global.memory_timer) / 40.0, 1.0);
    var _ckpt = (string_char_at(global.memory_text, 1) == "-");
    draw_set_alpha(clamp(_mf, 0, 1) * 0.92);
    draw_set_color(_ckpt ? make_color_rgb(80, 230, 100) : make_color_rgb(220, 200, 130));
    draw_set_halign(fa_center);
    draw_text_transformed(gw / 2, _ckpt ? gh * 0.50 : gh * 0.72,
        global.memory_text, _ckpt ? 1.4 : 1.05, _ckpt ? 1.4 : 1.05, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}

// === LEVEL TITLE CARD + ROOM FADE-IN (Room1 only) ===
if (room == Room1) {
    if (card_timer > 0) {
        card_timer--;
        var _card_a = min(card_timer / 50.0, 1.0) * min((190 - card_timer) / 30.0, 1.0);
        draw_set_alpha(0.62 * _card_a);
        draw_set_color(c_black);
        draw_rectangle(0, gh * 0.34, gw, gh * 0.52, false);
        draw_set_alpha(_card_a);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(150, 130, 70));
        draw_text_transformed(gw / 2, gh * 0.385, "V I E T N A M   ·   1  9  6  8", 0.85, 0.85, 0);
        draw_set_color(make_color_rgb(235, 220, 170));
        draw_text_transformed(gw / 2, gh * 0.445, "T H E   B U N K E R", 2.1, 2.1, 0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_alpha(1);
    }
    if (room_fade > 0) {
        room_fade--;
        draw_set_color(c_black);
        draw_set_alpha(room_fade / 45.0);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);
    }
}

draw_set_color(c_white);
