x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (place_meeting(x, y, obj_platform)) {
    instance_destroy();
    exit;
}

var p = instance_place(x, y, obj_dan);
if (p != noone && p.i_frames == 0) {
    p.hp         -= 10;
    p.ptsd_meter  = min(p.ptsd_meter + 18, p.ptsd_max);
    p.i_frames    = 40;
    global.shake_mag = max(global.shake_mag, 7.0);
    audio_play_sound(snd_player_hurt, 10, false);
    instance_destroy();
}
