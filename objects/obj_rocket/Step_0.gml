// Slight homing toward Dan
if (instance_exists(obj_dan)) {
    var _want = point_direction(x, y, obj_dan.x, obj_dan.y - 12);
    direction += clamp(angle_difference(_want, direction), -1.2, 1.2);
}
image_angle = direction;

x += lengthdir_x(spd, direction);
y += lengthdir_y(spd, direction);

// Detonate on terrain or proximity to Dan
var _boom = place_meeting(x, y, obj_platform);
if (!_boom && instance_exists(obj_dan) && point_distance(x, y, obj_dan.x, obj_dan.y) < 40) {
    _boom = true;
}

if (_boom) {
    var _ex = instance_create_layer(x, y, "Instances", obj_explosion_fx);
    _ex.image_xscale = 1.3;
    _ex.image_yscale = 1.3;
    global.shake_mag   = max(global.shake_mag, 16);
    global.flash_timer = max(global.flash_timer, 18);
    audio_play_sound(snd_explosion, 10, false);

    // AoE damage to Dan (mirrors obj_enemy_bullet's damage block)
    if (instance_exists(obj_dan)
    &&  point_distance(x, y, obj_dan.x, obj_dan.y) < 90
    &&  obj_dan.i_frames == 0) {
        obj_dan.hp        -= dmg;
        obj_dan.ptsd_meter = min(obj_dan.ptsd_meter + 25, obj_dan.ptsd_max);
        obj_dan.i_frames   = 45;
        audio_play_sound(snd_player_hurt, 10, false);
    }

    instance_destroy();
    exit;
}
