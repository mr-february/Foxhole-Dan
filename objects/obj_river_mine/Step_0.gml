sway += 0.03;
y = moor_y + sin(sway) * 14;

if (instance_exists(obj_dan_swim)) {
    var p = instance_find(obj_dan_swim, 0);
    if (point_distance(x, y, p.x, p.y) < trigger_range) {
        if (p.i_frames == 0) {
            p.hp      -= dmg;
            p.i_frames = 45;
        }
        instance_create_layer(x, y, "Instances", obj_explosion_fx);
        global.shake_mag   = max(global.shake_mag, 14);
        global.flash_timer = max(global.flash_timer, 16);
        audio_play_sound(snd_explosion, 9, false);
        instance_destroy();
    }
}
