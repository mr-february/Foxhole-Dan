// Drift forward, slowing; heat rises
x += hspd_drift;
y += vspd_drift;
hspd_drift *= 0.92;
vspd_drift -= 0.04;

// Burn Dan — small repeated ticks with short i_frames
if (instance_exists(obj_dan)) {
    var p = instance_find(obj_dan, 0);
    if (p.i_frames == 0 && point_distance(x, y, p.x, p.y) < 70) {
        p.hp        -= dmg;
        p.ptsd_meter = min(p.ptsd_meter + 6, p.ptsd_max);
        p.i_frames   = 12;
        global.shake_mag = max(global.shake_mag, 3.0);
        if (irandom(2) == 0) audio_play_sound(snd_player_hurt, 10, false);
    }
}

life--;
if (life <= 0) instance_destroy();
