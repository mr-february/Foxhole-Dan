var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === PARALLAX TERRAIN (behind everything) ===
// Sky
draw_set_color(make_color_rgb(150, 120, 78));
draw_rectangle(0, 0, gw, gh, false);
draw_set_color(make_color_rgb(120, 96, 64));
draw_rectangle(0, gh * 0.55, gw, gh, false);
// Far hills (slow parallax)
draw_set_color(make_color_rgb(70, 84, 56));
var off1 = -(scroll * 0.3) mod (gw + 400);
for (var i = -1; i < 3; i++) {
    var hx = off1 + i * (gw * 0.6);
    draw_triangle(hx, gh * 0.62, hx + 260, gh * 0.44, hx + 520, gh * 0.62, false);
}
// Near jungle strip (fast parallax)
draw_set_color(make_color_rgb(34, 54, 30));
draw_rectangle(0, gh * 0.78, gw, gh, false);
draw_set_color(make_color_rgb(44, 66, 36));
var off2 = -(scroll * 0.9) mod 180;
for (var j = -1; j < gw / 90 + 1; j++) {
    var tx = off2 + j * 90;
    draw_triangle(tx, gh * 0.82, tx + 30, gh * 0.66, tx + 60, gh * 0.82, false);
}

// === WIN / DEAD ===
if (global.game_state == 1) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(200,200,60));
    draw_text_transformed(gw/2, gh/2 - 50, "REACHED THE LZ", 2.4, 2.4, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 + 20, "Wheels down. The river's up ahead.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220,220,80));
    draw_text_transformed(gw/2, gh/2 + 58, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(80,0,0)); draw_set_alpha(0.75); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220,50,50));
    draw_text_transformed(gw/2, gh/2 - 40, "THE BIRD WENT DOWN", 1.7, 1.7, 0);
    draw_set_color(make_color_rgb(200,180,80));
    draw_text_transformed(gw/2, gh/2 + 30, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(160,100,100));
    draw_text_transformed(gw/2, gh/2 + 62, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// === CHOPPER HP BAR (top center) ===
if (instance_exists(obj_dan_chopper)) {
    var c = instance_find(obj_dan_chopper, 0);
    var cpct = clamp(c.chopper_hp / c.chopper_max_hp, 0, 1);
    var bw = 360, bx = gw/2 - bw/2, byy = 14;
    draw_set_color(c_dkgray); draw_rectangle(bx, byy, bx + bw, byy + 18, false);
    draw_set_color(make_color_rgb(lerp(200,40,cpct), lerp(60,200,cpct), 40));
    draw_rectangle(bx, byy, bx + bw * cpct, byy + 18, false);
    draw_set_color(c_white); draw_rectangle(bx, byy, bx + bw, byy + 18, true);
    draw_set_halign(fa_center);
    draw_text_transformed(gw/2, byy + 1, "CHOPPER", 0.8, 0.8, 0);
    draw_set_halign(fa_left);
}

// === DISTANCE-TO-LZ + score/combo ===
var dp = clamp(scroll / scroll_target, 0, 1);
draw_set_color(c_dkgray); draw_rectangle(24, gh - 40, 24 + 300, gh - 28, false);
draw_set_color(make_color_rgb(120, 200, 120)); draw_rectangle(24, gh - 40, 24 + 300 * dp, gh - 28, false);
draw_set_color(c_white); draw_rectangle(24, gh - 40, 24 + 300, gh - 28, true);
draw_text(24, gh - 62, "TO LZ  " + string(floor(dp * 100)) + "%");

draw_set_color(make_color_rgb(220,220,80));
draw_text(24, 20, "SCORE  " + string(global.score));
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240,160,60));
    draw_text(24, 44, "COMBO  x" + string(global.combo_mult));
}
draw_set_color(c_white);
