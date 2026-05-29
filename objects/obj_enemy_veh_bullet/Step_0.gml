x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (x > room_width + 100 || x < -100) { instance_destroy(); exit; }

if (place_meeting(x, y, obj_platform)) { instance_destroy(); exit; }

var hit = instance_place(x, y, obj_dan_vehicle);
if (hit != noone && hit.i_frames == 0) {
    hit.hp           -= 20;
    hit.i_frames      = 25;
    global.shake_mag  = max(global.shake_mag, 4.0);
    audio_play_sound(snd_bullet_impact, 8, false);
    instance_destroy();
}
