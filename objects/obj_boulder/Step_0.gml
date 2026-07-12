// === BOULDER PHYSICS — gravity + obj_platform bounce/roll ===
life--;
if (life <= 0) { instance_destroy(); exit; }

// Gravity
vspd += grav;
if (vspd > 18) vspd = 18;

// --- Horizontal collision: bounce off ledge walls ---
if (place_meeting(x + hspd, y, obj_platform)) {
    while (!place_meeting(x + sign(hspd), y, obj_platform)) x += sign(hspd);
    hspd = -hspd * 0.55;
}
x += hspd;

// Bounce off room edges
if (x < 0)               { x = 0;               hspd =  abs(hspd); }
if (x > room_width - 32) { x = room_width - 32; hspd = -abs(hspd); }

// --- Vertical collision: bounce hard, then roll ---
if (place_meeting(x, y + vspd, obj_platform)) {
    var _vs = sign(vspd);
    while (!place_meeting(x, y + _vs, obj_platform)) y += _vs;
    if (vspd > 3.5) {
        // Hard landing — bounce and kick sideways
        vspd = -vspd * 0.45;
        if (abs(hspd) < 1.0) hspd = choose(-1, 1) * random_range(1.2, 2.2);
        hspd *= 1.06;
        // Thud — only if near the camera
        var _cy = camera_get_view_y(view_camera[0]);
        var _ch = camera_get_view_height(view_camera[0]);
        if (y > _cy - 100 && y < _cy + _ch + 100) {
            audio_play_sound(snd_bullet_impact, 5, false);
            global.shake_mag = max(global.shake_mag, 2.0);
        }
    } else {
        vspd = 0;   // rolling along the surface
    }
}
y += vspd;

// Rolling friction + visual spin
if (vspd == 0) hspd *= 0.996;
rot += hspd * 4;

// Track rest (a boulder wedged in a corner)
if (abs(hspd) < 0.3 && abs(vspd) < 0.3) rest_timer++; else rest_timer = 0;

// --- CONTACT DAMAGE to Dan (heavy hit, respects i-frames) ---
if (global.game_state == 0) {
    var p = instance_find(obj_dan, 0);
    if (p != noone && p.i_frames == 0) {
        if (point_distance(x + 16, y + 16, p.x, p.y - 16) < radius + 18) {
            p.hp      -= dmg;
            p.i_frames = 45;
            // Knock Dan away from the rock
            var _kx = p.x - (x + 16);
            p.hspd = (_kx >= 0) ? 6 : -6;
            p.vspd = -4;
            global.shake_mag = max(global.shake_mag, 7.0);
            audio_play_sound(snd_player_hurt, 9, false);
            var _s = audio_play_sound(snd_explosion, 4, false);
            audio_sound_gain(_s, 0.35, 0);
        }
    }
}

// --- CLEANUP: fell below the view, or rested offscreen ---
var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);
if (y > _cam_y + _cam_h + 300) { instance_destroy(); exit; }
if (rest_timer > 90 && (y < _cam_y - 200 || y > _cam_y + _cam_h + 200)) {
    instance_destroy(); exit;
}
