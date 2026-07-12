// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p    = noone;
var dist = 9999;
if (instance_exists(obj_dan)) {
    p    = instance_find(obj_dan, 0);
    dist = point_distance(x, y, p.x, p.y);
}

firing = false;

if (p != noone && dist < aggro_range) {
    facing = (p.x != x) ? sign(p.x - x) : facing;

    // Advance until close enough to burn
    var chase_dir = 0;
    if (dist > approach_range) chase_dir = sign(p.x - x);
    if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
        chase_dir = 0;
    }
    hspd = chase_dir * move_spd;

    // Spray flame while the player is in range
    if (fire_timer > 0) fire_timer--;
    if (dist < fire_range) {
        firing = true;
        if (fire_timer <= 0) {
            var _mx = x + facing * 20;
            var _my = y - 16;
            var fl = instance_create_layer(_mx, _my, "Instances", obj_flame);
            fl.hspd_drift = facing * 3.0 + random_range(-0.4, 0.4);
            fl.vspd_drift = random_range(-0.6, 0.2);
            fire_timer = fire_cd;
        }
    }

} else {
    // Patrol
    patrol_timer--;
    if (patrol_timer <= 0) {
        patrol_dir   *= -1;
        patrol_timer  = irandom(90) + 60;
    }
    hspd   = patrol_dir * move_spd;
    facing = patrol_dir;
}

image_xscale = facing;

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd = 0;
    patrol_dir *= -1;
}
if (grounded && hspd != 0 && !place_meeting(x + sign(hspd) * 16, y + 2, obj_platform)) {
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
