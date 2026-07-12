var gw = display_get_gui_width();
var gh = display_get_gui_height();

// ============================================================
// DEATH / SUBMIT SCREEN
// ============================================================
if (global.game_state == 2) {
    draw_set_color(c_black); draw_set_alpha(0.82); draw_rectangle(0, 0, gw, gh, false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(220, 60, 60));
    draw_text_transformed(gw/2, gh/2 - 200, "YOU WERE OVERRUN", 2.2, 2.2, 0);

    // Run stats
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 - 130, "WAVE  " + string(wave), 1.4, 1.4, 0);
    draw_text_transformed(gw/2, gh/2 - 96,  "SCORE  " + string(global.score), 1.4, 1.4, 0);
    draw_set_color(make_color_rgb(160, 160, 170));
    draw_text_transformed(gw/2, gh/2 - 64,  "KILLS  " + string(global.run_kills), 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(200, 180, 80));
    draw_text_transformed(gw/2, gh/2 - 34,  "BEST  " + string(best_score) + "   ·   WAVE " + string(best_wave), 0.9, 0.9, 0);

    if (submit_state == 1) {
        // Initials entry
        draw_set_color(make_color_rgb(220, 220, 80));
        draw_text_transformed(gw/2, gh/2 + 10, "ENTER YOUR INITIALS", 1.0, 1.0, 0);
        for (var i = 0; i < 3; i++) {
            var cx = gw/2 - 70 + i * 70;
            if (i == init_pos) {
                var pulse = abs(sin(current_time * 0.008));
                draw_set_color(make_color_rgb(255, 200 + 55 * pulse, 60));
            } else {
                draw_set_color(c_white);
            }
            draw_text_transformed(cx, gh/2 + 70, initials[i], 3.0, 3.0, 0);
        }
        draw_set_color(make_color_rgb(150, 150, 160));
        draw_text_transformed(gw/2, gh/2 + 140, "UP/DOWN letter   LEFT/RIGHT move   ENTER/A submit", 0.8, 0.8, 0);
    } else if (submit_state == 2) {
        var mine = initials[0] + initials[1] + initials[2];
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, gh/2 + 20, "SCORE SUBMITTED  —  " + mine, 1.1, 1.1, 0);
        if (variable_global_exists("lb_status")) {
            draw_set_color(make_color_rgb(150, 170, 200));
            draw_text_transformed(gw/2, gh/2 + 54, "GLOBAL LEADERBOARD  ·  " + string(global.lb_status), 0.8, 0.8, 0);
        }
        // Live top-8 (populated by the submit response, offline-safe).
        if (variable_global_exists("lb_list") && is_array(global.lb_list)) {
            var n = min(array_length(global.lb_list), 8);
            for (var li = 0; li < n; li++) {
                var e = global.lb_list[li];
                var nm = (is_struct(e) && variable_struct_exists(e, "initials")) ? e.initials : "AAA";
                var sc = (is_struct(e) && variable_struct_exists(e, "score")) ? e.score : 0;
                var wv = (is_struct(e) && variable_struct_exists(e, "wave")) ? e.wave : 0;
                draw_set_color((nm == mine) ? make_color_rgb(255, 220, 80) : c_white);
                draw_text_transformed(gw/2, gh/2 + 86 + li * 22, string(li + 1) + ".   " + string(nm) + "    " + string(sc) + "   (W" + string(wv) + ")", 0.78, 0.78, 0);
            }
        }
        draw_set_color(make_color_rgb(180, 180, 190));
        draw_text_transformed(gw/2, gh/2 + 286, "R  play again      ESC  main menu", 0.9, 0.9, 0);
    }

    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// ============================================================
// HUD (playing)
// ============================================================
var ax = 24, ay = 20;
if (instance_exists(obj_dan)) {
    var p = instance_find(obj_dan, 0);
    var hpct = clamp(p.hp / p.max_hp, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(ax, ay, ax + 220, ay + 18, false);
    draw_set_color(make_color_rgb(lerp(200,40,hpct), lerp(40,200,hpct), 40));
    draw_rectangle(ax, ay, ax + 220 * hpct, ay + 18, false);
    draw_set_color(c_white); draw_rectangle(ax, ay, ax + 220, ay + 18, true);
    draw_text(ax, ay + 22, "SCORE  " + string(global.score));
}
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240, 160, 60));
    draw_text(ax, ay + 44, "COMBO  x" + string(global.combo_mult));
    var cb = clamp(global.combo_timer / 150, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(ax, ay + 62, ax + 100, ay + 68, false);
    draw_set_color(make_color_rgb(240,160,60)); draw_rectangle(ax, ay + 62, ax + 100 * cb, ay + 68, false);
    draw_set_color(c_white);
}

// Wave counter (top-right)
draw_set_halign(fa_right);
draw_set_color(make_color_rgb(220, 220, 80));
draw_text_transformed(gw - 16, 16, "WAVE  " + string(wave), 1.3, 1.3, 0);
draw_set_color(make_color_rgb(150,150,160));
draw_text_transformed(gw - 16, 48, "ENEMIES  " + string(instance_number(par_enemy) + to_spawn), 0.85, 0.85, 0);
draw_set_halign(fa_left);

// Wave banner
if (banner_timer > 0) {
    var ba = clamp(banner_timer / 30, 0, 1);
    draw_set_halign(fa_center);
    draw_set_alpha(ba);
    if (phase == 1) {
        draw_set_color(make_color_rgb(230, 60, 60));
        draw_text_transformed(gw/2, gh/2 - 120, "WAVE " + string(wave), 2.6, 2.6, 0);
        if (wave mod 5 == 0) {
            draw_set_color(make_color_rgb(255, 200, 60));
            draw_text_transformed(gw/2, gh/2 - 70, "ELITE WAVE", 1.2, 1.2, 0);
        }
    } else {
        draw_set_color(make_color_rgb(80, 220, 80));
        draw_text_transformed(gw/2, gh/2 - 120, "WAVE CLEARED  +" + string(500 * wave), 1.6, 1.6, 0);
    }
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}
draw_set_color(c_white);
