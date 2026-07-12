var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === SCOPE OVERLAY (when scoped) ===
if (instance_exists(obj_dan_sniper)) {
    var s = instance_find(obj_dan_sniper, 0);
    if (s.scoped && global.game_state == 0) {
        // Convert aim world-pos to GUI space (view starts at 0,0 for this fixed room)
        var sx = s.aim_x, sy = s.aim_y;
        // Dim everything outside the scope circle
        draw_set_color(c_black); draw_set_alpha(0.72);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);
        // Scope glass (a clear-ish disc)
        var r = 170;
        draw_set_color(make_color_rgb(20, 26, 22)); draw_set_alpha(0.25);
        draw_circle(sx, sy, r, false);
        draw_set_alpha(1);
        // Crosshair
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_circle(sx, sy, r, true);
        draw_line(sx - r, sy, sx + r, sy);
        draw_line(sx, sy - r, sx, sy + r);
        draw_set_color(make_color_rgb(220, 40, 40));
        draw_line(sx - 14, sy, sx - 4, sy); draw_line(sx + 4, sy, sx + 14, sy);
        draw_line(sx, sy - 14, sx, sy - 4); draw_line(sx, sy + 4, sx, sy + 14);
        // Range ticks
        for (var t = -3; t <= 3; t++) if (t != 0) draw_line(sx + t * 22, sy - 5, sx + t * 22, sy + 5);
    }
}

// === WIN / DEAD ===
if (global.game_state == 1) {
    draw_set_color(c_black); draw_set_alpha(0.7); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(200,200,60));
    draw_text_transformed(gw/2, gh/2 - 50, "STREET HELD", 2.4, 2.4, 0);
    draw_set_color(c_white);
    draw_text_transformed(gw/2, gh/2 + 20, "Nothing moving down there now.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(220,220,80));
    draw_text_transformed(gw/2, gh/2 + 58, "SCORE  " + string(global.score), 1.0, 1.0, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}
if (global.game_state == 2) {
    draw_set_color(make_color_rgb(80,0,0)); draw_set_alpha(0.75); draw_rectangle(0,0,gw,gh,false); draw_set_alpha(1);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(220,50,50));
    draw_text_transformed(gw/2, gh/2 - 40, "THEY OVERRAN THE NEST", 1.6, 1.6, 0);
    draw_set_color(make_color_rgb(200,180,80));
    draw_text_transformed(gw/2, gh/2 + 30, "SCORE  " + string(global.score), 0.95, 0.95, 0);
    draw_set_color(make_color_rgb(160,100,100));
    draw_text_transformed(gw/2, gh/2 + 62, "Press R to try again", 0.85, 0.85, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top); draw_set_color(c_white);
    exit;
}

// === HUD ===
var ax = 24, ay = 20;
if (instance_exists(obj_dan_sniper)) {
    var sn = instance_find(obj_dan_sniper, 0);
    var hpct = clamp(sn.hp / sn.max_hp, 0, 1);
    draw_set_color(c_dkgray); draw_rectangle(ax, ay, ax + 220, ay + 18, false);
    draw_set_color(make_color_rgb(lerp(200,40,hpct), lerp(40,200,hpct), 40));
    draw_rectangle(ax, ay, ax + 220 * hpct, ay + 18, false);
    draw_set_color(c_white); draw_rectangle(ax, ay, ax + 220, ay + 18, true);
    draw_text(ax, ay + 22, "SCORE  " + string(global.score));
    // Ammo
    var astr = (sn.reloading > 0) ? "RELOADING..." : ("AMMO  " + string(sn.ammo) + "/" + string(sn.max_ammo));
    draw_text(ax, ay + 44, astr);
}
// Wave counter
draw_set_halign(fa_right);
draw_set_color(make_color_rgb(220,220,80));
draw_text_transformed(gw - 16, 16, "WAVE  " + string(min(wave_index + 1, total_waves)) + " / " + string(total_waves), 1.0, 1.0, 0);
draw_set_halign(fa_left);
// Combo
if (global.combo_mult > 1) {
    draw_set_color(make_color_rgb(240,160,60));
    draw_text(ax, ay + 66, "COMBO  x" + string(global.combo_mult));
}
draw_set_color(c_white);
