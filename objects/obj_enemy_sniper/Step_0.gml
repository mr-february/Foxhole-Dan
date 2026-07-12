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

if (p != noone && dist < shoot_range) {
    if (p.x != x) facing = sign(p.x - x);

    if (aiming) {
        // Hold perfectly still while the laser telegraph counts down
        hspd = 0;
        aim_timer--;
        if (aim_timer <= 0) {
            aiming = false;
            var _mx = x + facing * 24;
            var _my = y - 8;
            var b = instance_create_layer(_mx, _my, "Instances", obj_enemy_bullet);
            b.direction   = point_direction(_mx, _my, p.x, p.y - 12);
            b.speed       = 22;
            b.image_angle = b.direction;
            shoot_timer   = shoot_cd + irandom(30);
        }
    } else {
        if (shoot_timer > 0) shoot_timer--;
        if (shoot_timer <= 0) {
            aiming    = true;
            aim_timer = aim_frames;
        }

        // Occasional small reposition (mostly stationary)
        repos_timer--;
        if (repos_timer <= 0) {
            repos_dir   = choose(-1, 1);
            repos_len   = 20 + irandom(20);
            repos_timer = 240 + irandom(240);
        }
        if (repos_len > 0) {
            repos_len--;
            var _rd = repos_dir;
            if (grounded && !place_meeting(x + _rd * 16, y + 2, obj_platform)) _rd = 0;
            hspd = _rd * move_spd;
        } else {
            hspd = 0;
        }
    }
} else {
    // Player gone or out of range — cancel telegraph, hold position
    aiming    = false;
    aim_timer = 0;
    hspd      = 0;
}

image_xscale = facing;

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd      = 0;
    repos_len = 0;
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
