var _prev_dist = point_distance(x, y, target_x, target_y);
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);
life--;

var _dist = point_distance(x, y, target_x, target_y);
if (_dist < speed || _dist > _prev_dist || life <= 0) {
    if (instance_exists(obj_dan_chopper)) {
        var c = instance_find(obj_dan_chopper, 0);
        if (c.i_frames == 0) {
            c.chopper_hp -= dmg;
            c.i_frames    = 14;
            global.shake_mag   = max(global.shake_mag, 5.0);
            global.flash_timer = max(global.flash_timer, 8);
            audio_play_sound(snd_bullet_impact, 6, false);
        }
    }
    instance_destroy();
}
