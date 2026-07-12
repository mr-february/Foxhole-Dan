var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === UNDERWATER TINT + caustics (GUI overlay) ===
draw_set_color(make_color_rgb(20, 60, 90));
draw_set_alpha(0.30);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(0.10);
draw_set_color(make_color_rgb(120, 200, 220));
var ct = current_time * 0.001;
for (var i = 0; i < 6; i++) {
    var lx = ((i * 340 + ct * 40) mod (gw + 200)) - 100;
    draw_line_width(lx, 0, lx + 120, gh, 30);
}
draw_set_alpha(1);
draw_set_color(c_white);

// Surface shimmer at the top
draw_set_color(make_color_rgb(150, 210, 230));
draw_set_alpha(0.35);
draw_rectangle(0, 0, gw, 26, false);
draw_set_alpha(1);

// === WIN / DEAD ===
if (global.game_state == 1) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(200,200,60));
    draw_text_transformed(gw/2, gh/2 - 50, "THE FAR BANK", 2.4, 2.4, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 + 20, "He dragged himself up through the reeds, lungs burning.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220,220,80));
    draw_text_transformed(gw/2, gh/2 + 58, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(0,20,50)); draw_set_alpha(0.8); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(120,180,230));
    draw_text_transformed(gw/2, gh/2 - 40, "THE RIVER TOOK HIM", 1.7, 1.7, 0);
    draw_set_color(make_color_rgb(200,180,80));
    draw_text_transformed(gw/2, gh/2 + 30, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(150,170,200));
    draw_text_transformed(gw/2, gh/2 + 62, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// === AIR METER + HP + progress ===
if (instance_exists(obj_dan_swim)) {
    var p = instance_find(obj_dan_swim, 0);
    // Air
    var apct = clamp(p.air / p.air_max, 0, 1);
    var aw = 260, ax = gw/2 - aw/2, ay = 16;
    draw_set_color(c_dkgray); draw_rectangle(ax, ay, ax + aw, ay + 16, false);
    draw_set_color((apct < 0.25) ? make_color_rgb(230, 60, 60) : make_color_rgb(80, 190, 230));
    draw_rectangle(ax, ay, ax + aw * apct, ay + 16, false);
    draw_set_color(c_white); draw_rectangle(ax, ay, ax + aw, ay + 16, true);
    draw_set_halign(fa_center);
    draw_text_transformed(gw/2, ay + 18, "AIR", 0.75, 0.75, 0);
    draw_set_halign(fa_left);
    // Gasping vignette when low
    if (p.air < 25) {
        var g = abs(sin(current_time * 0.008)) * 0.25;
        draw_set_color(make_color_rgb(0, 10, 30)); draw_set_alpha(g);
        draw_rectangle(0, 0, gw, gh, false); draw_set_alpha(1);
    }
    // HP
    var hpct = clamp(p.hp / p.max_hp, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(24, 20, 24 + 200, 38, false);
    draw_set_color(make_color_rgb(lerp(200,40,hpct), lerp(40,200,hpct), 40));
    draw_rectangle(24, 20, 24 + 200 * hpct, 38, false);
    draw_set_color(c_white); draw_rectangle(24, 20, 24 + 200, 38, true);
    draw_text(24, 42, "SCORE  " + string(global.score));
    if (global.combo_mult > 1) {
        draw_set_color(make_color_rgb(240,160,60));
        draw_text(24, 64, "COMBO  x" + string(global.combo_mult));
    }
    // Progress to bank
    var dp = clamp(p.x / 4600, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(gw - 260, gh - 38, gw - 24, gh - 28, false);
    draw_set_color(make_color_rgb(120, 200, 200)); draw_rectangle(gw - 260, gh - 38, gw - 260 + 236 * dp, gh - 28, false);
    draw_set_color(c_white); draw_rectangle(gw - 260, gh - 38, gw - 24, gh - 28, true);
}
draw_set_color(c_white);
