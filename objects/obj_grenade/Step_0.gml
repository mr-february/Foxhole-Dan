// Physics
x    += hvsp;
vvsp += 0.55;
y    += vvsp;

// Bounce off platforms
if (place_meeting(x, y + 1, obj_platform) && vvsp > 0) {
    vvsp *= -0.38;
    hvsp *= 0.68;
    if (abs(vvsp) < 1.2) { vvsp = 0; hvsp *= 0.5; }
}

// Despawn out of bounds
if (x < 0 || x > room_width) { instance_destroy(); exit; }

// Fuse countdown
fuse--;
if (fuse <= 0) {
    var _p = instance_find(obj_dan, 0);
    if (_p != noone && point_distance(x, y, _p.x, _p.y) < 110) {
        _p.hp         -= 30;
        _p.ptsd_meter  = min(_p.ptsd_meter + 30, _p.ptsd_max);
        _p.i_frames    = max(_p.i_frames, 45);
    }
    global.shake_mag   = max(global.shake_mag, 8.0);
    global.flash_timer = max(global.flash_timer, 16);
    audio_play_sound(snd_explosion, 10, false);
    var _ex = instance_create_layer(x, y, "Instances", obj_explosion_fx);
    _ex.image_xscale = 1.5;
    _ex.image_yscale = 1.5;
    instance_destroy();
}
