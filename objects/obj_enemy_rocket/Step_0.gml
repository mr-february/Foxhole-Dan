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

if (p != noone && dist < aggro_range) {
    facing = (p.x != x) ? sign(p.x - x) : facing;

    // Advance until at hold range, then plant to fire
    var chase_dir = 0;
    if (dist > hold_range) chase_dir = sign(p.x - x);
    if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
        chase_dir = 0;
    }
    hspd = chase_dir * move_spd;

    // Launch rocket
    if (shoot_timer > 0) shoot_timer--;
    if (shoot_timer <= 0 && dist < shoot_range) {
        var _mx = x + facing * 16;
        var _my = y - 22;
        var r = instance_create_layer(_mx, _my, "Instances", obj_rocket);
        r.direction   = point_direction(_mx, _my, p.x, p.y - 12);
        r.image_angle = r.direction;
        shoot_timer = shoot_cd + irandom(30);
        fire_anim   = 12;
        global.shake_mag = max(global.shake_mag, 3.0);
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

if (fire_anim > 0) fire_anim--;
if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
