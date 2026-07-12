bob += 0.12;

if (instance_exists(obj_dan_swim)) {
    var p = instance_find(obj_dan_swim, 0);
    var dir = point_direction(x, y, p.x, p.y);
    x += lengthdir_x(move_spd, dir);
    y += lengthdir_y(move_spd, dir) + sin(bob) * 0.6;
    facing = sign(p.x - x);
    if (facing == 0) facing = -1;

    if (point_distance(x, y, p.x, p.y) < bite_range && p.i_frames == 0) {
        p.hp      -= bite_dmg;
        p.i_frames = 40;
        global.shake_mag = max(global.shake_mag, 5.0);
        audio_play_sound(snd_player_hurt, 6, false);
    }
}

if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
