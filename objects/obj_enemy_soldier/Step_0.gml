// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p = instance_find(obj_dan, 0);
var dist = (p != noone) ? point_distance(x, y, p.x, p.y) : 9999;

if (p != noone && dist < aggro_range) {
    // Chase — clamp to platform edge so enemy never walks off while pursuing
    var chase_dir = sign(p.x - x);
    if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
        chase_dir = 0;  // hold at edge, keep shooting
    }
    hspd   = chase_dir * move_spd;
    facing = (chase_dir != 0) ? chase_dir : facing;

    // Shoot
    if (shoot_timer > 0) shoot_timer--;
    if (shoot_timer <= 0 && dist < shoot_range) {
        var b = instance_create_layer(x, y - 15, "Instances", obj_enemy_bullet);
        b.direction  = point_direction(x, y, p.x, p.y);
        b.speed      = 7;
        b.image_angle = b.direction;
        shoot_timer  = 90 + irandom(60);
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
// Ledge detection: stop before walking off platform edges
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
