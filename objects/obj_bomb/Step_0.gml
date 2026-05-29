if (exploding) {
    exp_timer--;
    // Damage player at peak of blast
    if (exp_timer == 12) {
        var p = instance_find(obj_dan, 0);
        if (p == noone) p = instance_find(obj_dan_vehicle, 0);
        if (p != noone && point_distance(x, y, p.x, p.y) < 55 && p.i_frames == 0) {
            p.hp -= 20;
            if (p.object_index == obj_dan) p.ptsd_meter = min(p.ptsd_meter + 28, p.ptsd_max);
            p.i_frames = 45;
            var d = instance_create_layer(p.x, p.y - 20, "Instances", obj_damage_number);
            d.amount = 20;
        }
    }
    if (exp_timer <= 0) instance_destroy();
    exit;
}

// Fall
vspd += drop_spd * 0.12;
if (vspd > 14) vspd = 14;
y += vspd;

// Hit platform (point check — no sprite needed)
if (collision_point(x, y + 5, obj_platform, false, true) != noone) {
    exploding = true;
    exp_timer = 22;
    audio_play_sound(snd_explosion, 10, false);
    global.shake_mag   = max(global.shake_mag, 10.0);
    global.flash_timer = max(global.flash_timer, 20);
    var _bex = instance_create_layer(x, y, "Instances", obj_explosion_fx);
    _bex.image_xscale = 2.5;
    _bex.image_yscale = 2.5;
    exit;
}

// Direct hit on player
var p = instance_find(obj_dan, 0);
if (p == noone) p = instance_find(obj_dan_vehicle, 0);
if (p != noone && point_distance(x, y, p.x, p.y) < 22 && p.i_frames == 0) {
    p.hp -= 20;
    if (p.object_index == obj_dan) p.ptsd_meter = min(p.ptsd_meter + 28, p.ptsd_max);
    p.i_frames = 45;
    exploding = true;
    exp_timer = 22;
    exit;
}

// Off room
if (y > room_height + 60) instance_destroy();
