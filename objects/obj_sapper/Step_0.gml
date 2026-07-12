// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === WINDING UP — planted, about to detonate ===
if (winding) {
    hspd = 0;
    wind_timer--;
    if (wind_timer <= 0) {
        // === DETONATE (suicide — no score awarded, it wasn't shot) ===
        if (instance_exists(obj_dan)) {
            var _p = instance_find(obj_dan, 0);
            if (point_distance(x, y, _p.x, _p.y) < blast_radius) {
                _p.hp        -= blast_dmg;
                _p.i_frames   = max(_p.i_frames, 45);
                _p.ptsd_meter = min(_p.ptsd_meter + 25, _p.ptsd_max);
            }
        }
        global.shake_mag   = max(global.shake_mag, 18);
        global.flash_timer = max(global.flash_timer, 14);
        audio_play_sound(snd_explosion, 10, false);
        var _ex = instance_create_layer(x, y - 10, "Instances", obj_explosion_fx);
        _ex.image_xscale = 1.3;
        _ex.image_yscale = 1.3;
        instance_destroy();
        exit;
    }
} else if (instance_exists(obj_dan)) {
    var p    = instance_find(obj_dan, 0);
    var dist = point_distance(x, y, p.x, p.y);

    if (dist < aggro_range) {
        // Rush the player
        var chase_dir = sign(p.x - x);
        hspd   = chase_dir * move_spd;
        facing = (chase_dir != 0) ? chase_dir : facing;

        // Close enough — arm the satchel
        if (dist < trigger_range) {
            winding    = true;
            wind_timer = 30;
            hspd       = 0;
        }
    } else {
        // Patrol
        patrol_timer--;
        if (patrol_timer <= 0) {
            patrol_dir   *= -1;
            patrol_timer  = irandom(90) + 60;
        }
        hspd   = patrol_dir * move_spd * 0.4;
        facing = patrol_dir;
    }
} else {
    hspd = 0;
}

image_xscale = facing;

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
