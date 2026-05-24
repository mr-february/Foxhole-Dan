var gw = display_get_gui_width();
var gh = display_get_gui_height();

if (global.game_state == 3) exit;

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
    draw_set_color(make_color_rgb(140, 130, 80));
    draw_text_transformed(gw/2, gh/2 + 95, "Press R to play again", 0.85, 0.85, 0);
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
    draw_set_color(make_color_rgb(160, 100, 100));
    draw_text_transformed(gw/2, gh/2 + 70, "Press R to try again", 0.85, 0.85, 0);
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

// --- EXTRACTION PROGRESS BAR (top center) ---
var prog     = clamp(p.x / 7600, 0, 1);
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
    draw_text(16, leg_y, "L-Stick Up/Down  Speed  |  A  Jump  |  RT/RB  Shoot");
} else {
    draw_text(16, leg_y, "Up/W  Accelerate  |  Down/S  Brake  |  Space  Jump  |  J/LMB  Shoot");
}
draw_set_alpha(1);
// Explosion flash
if (global.flash_timer > 0) {
    draw_set_color(make_color_rgb(255, 165, 30));
    draw_set_alpha((global.flash_timer / 14.0) * 0.45);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
