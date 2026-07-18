var gw = display_get_gui_width();
var gh = display_get_gui_height();

// === SCOPE OVERLAY (Commandos-style magnifying lens, when scoped) ===
// The camera no longer zooms (see obj_dan_sniper Step_0) — the whole street stays
// visible at normal scale so the player can still see enemies closing in from
// elsewhere. Only the reticle itself shows a magnified close-up of whatever the
// crosshair is resting on, cropped straight out of this frame's application_surface
// and stretched into a circular lens.
if (instance_exists(obj_dan_sniper)) {
    var s = instance_find(obj_dan_sniper, 0);
    if (s.scoped && global.game_state == 0) {
        var sx = s.aim_x, sy = s.aim_y;   // room coords == screen coords (camera fixed at 0,0, no scaling)
        var r    = 260;                    // reticle radius — larger, easier to read the lens
        var zoom = 3.2;                    // lens magnification

        if (!surface_exists(scope_surf)) scope_surf = surface_create(r * 2, r * 2);

        var _crop = (r * 2) / zoom;
        var _cl = clamp(sx - _crop / 2, 0, room_width  - _crop);
        var _ct = clamp(sy - _crop / 2, 0, room_height - _crop);

        surface_set_target(scope_surf);
        draw_clear_alpha(c_black, 0);
        draw_set_color(c_white);
        draw_circle(r, r, r, false);                 // builds the circular alpha mask
        gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);
        draw_surface_part_ext(application_surface, _cl, _ct, _crop, _crop, 0, 0, zoom, zoom, c_white, 1);
        gpu_set_blendmode(bm_normal);
        surface_reset_target();

        // Faint vignette so the lens edge reads clearly against the un-zoomed street behind it
        draw_set_color(c_black); draw_set_alpha(0.28);
        draw_circle(sx, sy, r + 10, false);
        draw_set_alpha(1);

        draw_surface(scope_surf, sx - r, sy - r);

        // Bezel + crosshair
        draw_set_color(make_color_rgb(30, 30, 30));
        draw_circle(sx, sy, r, true);
        draw_line(sx - r, sy, sx + r, sy);
        draw_line(sx, sy - r, sx, sy + r);
        draw_set_color(make_color_rgb(220, 40, 40));
        draw_line(sx - 20, sy, sx - 6, sy); draw_line(sx + 6, sy, sx + 20, sy);
        draw_line(sx, sy - 20, sx, sy - 6); draw_line(sx, sy + 6, sx, sy + 20);
        // Range ticks
        for (var t = -4; t <= 4; t++) if (t != 0) draw_line(sx + t * 32, sy - 7, sx + t * 32, sy + 7);
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
