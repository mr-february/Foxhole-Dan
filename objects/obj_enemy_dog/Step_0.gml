// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
if (instance_exists(obj_dan)) {
    var p    = instance_find(obj_dan, 0);
    var dist = point_distance(x, y, p.x, p.y);

    if (dist < aggro_range) {
        // Full-speed charge — no ranged attack, no hesitation
        var chase_dir = sign(p.x - x);
        hspd   = chase_dir * move_spd;
        facing = (chase_dir != 0) ? chase_dir : facing;

        // === BITE (melee contact) ===
        if (dist < bite_range && p.i_frames == 0) {
            p.hp        -= bite_dmg;
            p.i_frames   = 40;
            p.ptsd_meter = min(p.ptsd_meter + 15, p.ptsd_max);
            global.shake_mag = max(global.shake_mag, 6.0);
            audio_play_sound(snd_player_hurt, 6, false);
        }
    } else {
        // Prowl
        patrol_timer--;
        if (patrol_timer <= 0) {
            patrol_dir   *= -1;
            patrol_timer  = irandom(90) + 60;
        }
        hspd   = patrol_dir * move_spd * 0.3;
        facing = patrol_dir;
    }
} else {
    hspd = 0;
}

image_xscale = facing;
run_phase   += abs(hspd) * 0.09;

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd = 0;
    patrol_dir *= -1;
}
x += hspd;

// === COLLISION - VERTICAL ===
if (place_meeting(x, y + vspd, obj_platform)) {
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;

if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
