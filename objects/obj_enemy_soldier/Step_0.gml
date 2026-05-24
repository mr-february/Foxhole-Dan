// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p    = instance_find(obj_dan, 0);
var dist = (p != noone) ? point_distance(x, y, p.x, p.y) : 9999;

if (p != noone && dist < aggro_range) {

    // ----- COVER BEHAVIOR -----
    if (cover_timer > 0) {
        cover_timer--;
        hspd   = lerp(hspd, 0, 0.3);
        facing = sign(p.x - x);

    } else {
        // Random cover when hurt
        if (hp < 80 && irandom(200) == 0 && grounded) {
            cover_timer = 65 + irandom(55);
        }

        // Chase — hold at ledge edge
        var chase_dir = sign(p.x - x);
        if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
            chase_dir = 0;
        }
        hspd   = chase_dir * move_spd;
        facing = (chase_dir != 0) ? chase_dir : facing;

        // Shoot
        if (shoot_timer > 0) shoot_timer--;
        if (shoot_timer <= 0 && dist < shoot_range) {
            var b = instance_create_layer(x, y - 15, "Instances", obj_enemy_bullet);
            b.direction   = point_direction(x, y, p.x, p.y);
            b.speed       = 7;
            b.image_angle = b.direction;
            shoot_timer   = 90 + irandom(60);
        }

        // Grenade throw (mid-range only)
        if (grenade_timer > 0) grenade_timer--;
        if (grenade_timer <= 0 && dist > 90 && dist < 280) {
            var _g = instance_create_layer(x, y - 18, "Instances", obj_grenade);
            _g.hvsp = (p.x - x) / 55.0;
            _g.vvsp = -9.0 - abs(p.y - y) * 0.04;
            grenade_timer = 280 + irandom(200);
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
