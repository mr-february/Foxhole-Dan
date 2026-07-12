bob += 0.15;

if (x > cover_x) {
    // Advance toward the nest
    x -= move_spd;
    in_cover = false;
} else {
    // Reached cover — hunker and suppress the sniper
    in_cover = true;
    suppress_timer--;
    if (suppress_timer <= 0) {
        suppress_timer = suppress_cd;
        if (instance_exists(obj_dan_sniper)) {
            var s = instance_find(obj_dan_sniper, 0);
            // Muzzle flash toward the nest; direct suppression damage (respects i-frames)
            if (s.i_frames == 0) {
                s.hp      -= [6, 8, 11, 14][clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3)];
                s.i_frames = 18;
                global.shake_mag = max(global.shake_mag, 4.0);
                audio_play_sound(snd_player_hurt, 5, false);
            }
        }
    }
}

if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
