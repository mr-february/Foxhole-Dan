var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === CAPTURE TRANSITION (game_state 1 = Dan reached the roof) ===
if (global.game_state == 1) {
    // Fade in dark overlay
    var _fa = clamp(transition_timer / 60.0, 0, 1);
    draw_set_color(c_black);
    draw_set_alpha(0.86 * _fa);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(_fa);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220, 200, 60));
    draw_text_transformed(gw/2, gh/2 - 70, "THE ROOF", 2.8, 2.8, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2,      "He pulled himself over the edge, gasping.", 1.2, 1.2, 0);
    draw_set_color(make_color_rgb(160, 148, 90));
    draw_text_transformed(gw/2, gh/2 + 50, "They were already waiting.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220, 60, 60));
    draw_text_transformed(gw/2, gh/2 + 100, "Everything went black.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
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
    draw_text_transformed(gw/2, gh/2 - 50, "BURIED ALIVE", 2.0, 2.0, 0);
    draw_set_color(make_color_rgb(180, 130, 130));
    draw_text_transformed(gw/2, gh/2 + 20, "The collapse swallowed him whole.", 1.1, 1.1, 0);
    draw_set_color(make_color_rgb(160, 100, 100));
    draw_text_transformed(gw/2, gh/2 + 70, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// === PLAYING HUD ===
var p = instance_find(obj_dan, 0);
if (p == noone) exit;

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

// --- PTSD METER ---
var px      = 16;
var py      = by + bh + 10;
var pw      = 200;
var ph      = 14;
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
var ax = 16;
var ay = py + ph + 10;
if (p.reload_timer > 0) {
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

// --- ALTITUDE PROGRESS BAR (top center) ---
// 0% at ground (y=2920), 100% at exit (y=200)
var climb_pct = clamp(1 - ((p.y - 200) / 2720), 0, 1);
var pbw = 360;
var pbh = 18;
var pbx = gw / 2 - pbw / 2;
var pby = 12;

draw_set_color(c_dkgray);
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, false);
draw_set_color(make_color_rgb(80, 160, 240));
draw_rectangle(pbx, pby, pbx + pbw * climb_pct, pby + pbh, false);
draw_set_color(make_color_rgb(40, 100, 180));
draw_rectangle(pbx, pby, pbx + pbw, pby + pbh, true);
draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text_transformed(gw / 2, pby + 2, "ALTITUDE  " + string(floor(climb_pct * 100)) + "%", 0.88, 0.88, 0);
draw_set_halign(fa_left);

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

// --- CONTROL LEGEND ---
draw_set_color(make_color_rgb(110, 110, 110));
draw_set_alpha(0.65);
var leg_y = gh - 40;
if (gamepad_is_connected(0)) {
    draw_text(16, leg_y, "L-Stick Move/Rope  |  A Jump  |  RT/RB Shoot  |  Y Hook (fire/cancel)");
} else {
    draw_text(16, leg_y, "WASD Move/Rope  |  Space Jump  |  J/LMB Shoot  |  G Hook (fire/cancel)");
}
draw_set_alpha(1);
draw_set_color(c_white);
