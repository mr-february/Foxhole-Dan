// Freeze while the game isn't playing (win/death overlays)
if (global.game_state != 0) exit;

var _cam_y = camera_get_view_y(view_camera[0]);
var _cam_h = camera_get_view_height(view_camera[0]);

// === PHASE 1 — TELEGRAPH (rumble builds) ===
if (!active) {
    warn_timer--;
    global.shake_mag = max(global.shake_mag, 1.2 + (110 - warn_timer) * 0.02);
    if (warn_timer <= 0) {
        active = true;
        band_y = _cam_y - band_h - 60;   // start just above the view
        var _s = audio_play_sound(snd_explosion, 6, false);
        audio_sound_gain(_s, 0.55, 0);
        global.shake_mag = max(global.shake_mag, 6.0);
    }
    exit;
}

// === PHASE 2 — THE SWEEP ===
band_y += sweep_spd;
global.shake_mag = max(global.shake_mag, 2.5);

// Damage Dan if caught in the band and not sheltered under an outcrop
var p = instance_find(obj_dan, 0);
if (p != noone && p.i_frames == 0) {
    var _in_x = (p.x > band_x && p.x < band_x + band_w);
    var _in_y = (p.y - 16 > band_y && p.y - 16 < band_y + band_h);
    if (_in_x && _in_y) {
        // Sheltered = a platform ceiling directly overhead within ~120px
        // (rock-outcrop shelves hang 96px above their ledge; ordinary rows
        //  are 160px apart, so only real overhangs count).
        var _sheltered = collision_line(p.x, p.y - 20, p.x, p.y - 120,
                                        obj_platform, false, true) != noone;
        if (!_sheltered) {
            p.hp      -= dmg;
            p.i_frames = 30;
            p.vspd     = max(p.vspd, 3);   // snow drags him downward
            p.hspd    *= 0.4;
            global.shake_mag = max(global.shake_mag, 6.5);
            audio_play_sound(snd_player_hurt, 9, false);
        }
    }
}

// Passed below the view — done
if (band_y > _cam_y + _cam_h + 300) instance_destroy();
