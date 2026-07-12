var gw = display_get_gui_width();
var gh = display_get_gui_height();

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
        draw_text_transformed(_mid, gh * 0.32, "AUDIO SETTINGS", 1.45, 1.45, 0);
        draw_set_color(make_color_rgb(70, 56, 18));
        draw_rectangle(_mid - 250, gh * 0.355, _mid + 250, gh * 0.358, false);

        var _sw     = 320;
        var _sh     = 20;
        var _labels = ["MUSIC", "SFX"];
        var _vals   = [global.vol_music, global.vol_sfx];

        for (var _si = 0; _si < 2; _si++) {
            var _sy   = gh * (0.44 + _si * 0.17);
            var _ssel = (_si == pause_settings_sel);
            var _sx   = _mid - _sw * 0.5;

            draw_set_alpha(_ssel ? 1.0 : 0.48);
            draw_set_color(_ssel ? make_color_rgb(230, 208, 88) : make_color_rgb(155, 138, 72));
            draw_text_transformed(_sx - 108, _sy + 2, _labels[_si], _ssel ? 1.15 : 1.0, _ssel ? 1.15 : 1.0, 0);

            draw_set_color(make_color_rgb(24, 20, 12));
            draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
            draw_set_color(_ssel ? make_color_rgb(218, 176, 38) : make_color_rgb(110, 92, 24));
            draw_rectangle(_sx, _sy, _sx + _sw * _vals[_si], _sy + _sh, false);
            draw_set_color(_ssel ? make_color_rgb(220, 198, 72) : make_color_rgb(80, 68, 22));
            draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, true);

            draw_set_halign(fa_left);
            draw_set_color(_ssel ? c_white : make_color_rgb(162, 148, 108));
            draw_text_transformed(_sx + _sw + 16, _sy, string(floor(_vals[_si] * 100)) + "%", 0.92, 0.92, 0);
            draw_set_halign(fa_center);

            if (_ssel) {
                draw_set_alpha(0.88);
                draw_set_color(make_color_rgb(230, 208, 88));
                draw_text_transformed(_sx - 22, _sy + 9, "<", 1.3, 1.3, 0);
                draw_text_transformed(_sx + _sw + 66, _sy + 9, ">", 1.3, 1.3, 0);
            }
            draw_set_alpha(1);
        }
        draw_set_alpha(0.45);
        draw_set_color(make_color_rgb(165, 148, 75));
        draw_text_transformed(_mid, gh * 0.83, "W/S  Switch    A/D  Adjust    ESC  Back", 0.88, 0.88, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    exit;
}

// === WIN SCREEN ===
if (global.game_state == 1) {
    draw_set_color(make_color_rgb(10, 18, 8));
    draw_set_alpha(0.8);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 200, 60));
    draw_text_transformed(gw/2, gh/2 - 60, "EXTRACTION COMPLETE", 2.5, 2.5, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2, "Dan made it out alive.", 1.2, 1.2, 0);
    draw_set_color(make_color_rgb(160, 148, 90));
    draw_text_transformed(gw/2, gh/2 + 45, "But the war followed him home.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220, 220, 80));
    draw_text_transformed(gw/2, gh/2 + 72, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(200, 185, 90));
    draw_text_transformed(gw/2, gh/2 + 105, "PRESS R TO CONTINUE", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === DEAD SCREEN ===
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(80, 0, 0));
    draw_set_alpha(0.78);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 50, 50));
    draw_text_transformed(gw/2, gh/2 - 50, "VEHICLE DESTROYED", 2.0, 2.0, 0);
    draw_set_color(make_color_rgb(180, 130, 130));
    draw_text_transformed(gw/2, gh/2 + 20, "The road out doesn't forgive mistakes.", 1.1, 1.1, 0);
    draw_set_color(make_color_rgb(200, 180, 80));
    draw_text_transformed(gw/2, gh/2 + 48, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(210, 130, 130));
    draw_text_transformed(gw/2, gh/2 + 80, "PRESS R TO RETRY", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === PLAYING HUD ===
var p = instance_find(obj_dan_vehicle, 0);
if (p == noone) exit;

// Rain
var _rt = current_time * 0.001;
draw_set_color(make_color_rgb(155, 190, 225));
for (var _ri = 0; _ri < 110; _ri++) {
    var _rx = (_ri * 313) mod (gw + 80);
    var _rl = 14 + (_ri mod 12);
    var _ry = (_rt * 340 + _ri * 139) mod (gh + 80) - 20;
    draw_set_alpha(0.10 + (_ri mod 5) * 0.05);
    draw_line_width(_rx, _ry, _rx - 4, _ry + _rl, 1);
}
draw_set_alpha(1);

// --- VEHICLE HP BAR ---
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
draw_text(bx, by - 14, "VEHICLE HP");
draw_text(bx + bw + 4, by + 1, string(max(0, floor(p.hp))) + "/" + string(p.max_hp));

// --- AMMO ---
var ax = 16;
var ay = by + bh + 10;
if (p.reload_timer > 0) {
    var rl_pct = 1 - (p.reload_timer / 80);
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

// --- BOMBS ---
draw_set_color(make_color_rgb(220, 160, 60));
draw_text(ax, ay + 18, "BOMBS  " + string(p.bomb_count));

// --- SCORE ---
draw_set_color(make_color_rgb(220, 220, 80));
draw_text(ax, ay + 36, "SCORE  " + string(global.score));

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
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

// --- EXTRACTION PROGRESS BAR (top center) ---
var prog     = clamp(p.x / 11600, 0, 1);
var pbw      = 360;
var pbh      = 18;
var pbx      = gw / 2 - pbw / 2;
var pby      = 12;

draw_set_color(c_dkgray);
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, false);
draw_set_color(make_color_rgb(60, 180, 80));
draw_rectangle(pbx, pby, pbx + pbw * prog, pby + pbh, false);
draw_set_color(make_color_rgb(40, 140, 60));
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, true);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(gw / 2, pby + 2, "EXTRACTION  " + string(floor(prog * 100)) + "%", 0.88, 0.88, 0);
draw_set_halign(fa_left);

// --- CONTROL LEGEND ---
draw_set_color(make_color_rgb(110, 110, 110));
draw_set_alpha(0.6);
var leg_y = gh - 40;
if (gamepad_is_connected(0)) {
    draw_text(16, leg_y, "L-Stick Up/Down  Speed  |  A  Jump  |  R-Stick  Aim  |  RT/RB  Shoot  |  LB  Bomb");
} else {
    draw_text(16, leg_y, "W/Up  Accelerate  |  S/Down  Brake  |  Space  Jump  |  Left/Right  Aim  |  J/LMB  Shoot  |  K  Bomb");
}
draw_set_alpha(1);
// Explosion flash
if (global.flash_timer > 0) {
    draw_set_color(make_color_rgb(255, 165, 30));
    draw_set_alpha((global.flash_timer / 14.0) * 0.45);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
// Kill flash
if (global.kill_flash_timer > 0) {
    global.kill_flash_timer--;
    draw_set_color(c_white);
    draw_set_alpha((global.kill_flash_timer + 1) / 5.0 * 0.28);
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

// === LEVEL TITLE CARD + ROOM FADE-IN ===
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
    draw_text_transformed(gw / 2, gh * 0.385, "N O   S T O P P I N G", 0.85, 0.85, 0);
    draw_set_color(make_color_rgb(235, 220, 170));
    draw_text_transformed(gw / 2, gh * 0.445, "T H E   R O A D   O U T", 2.1, 2.1, 0);
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

draw_set_color(c_white);
