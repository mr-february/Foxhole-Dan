// === GRAVITY === (static, but still settles onto the ground)
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

    if (burst_left > 0) {
        // Suppressive burst — rapid fire with slight spread
        if (fire_timer > 0) fire_timer--;
        if (fire_timer <= 0) {
            var _mx = x + facing * 24;
            var _my = y - 16;
            var b = instance_create_layer(_mx, _my, "Instances", obj_enemy_bullet);
            b.direction   = point_direction(_mx, _my, p.x, p.y - 10) + random_range(-5, 5);
            b.speed       = 8;
            b.image_angle = b.direction;
            fire_timer    = fire_cd;
            muzzle_flash  = 3;
            burst_left--;
            if (burst_left <= 0) pause_timer = burst_pause;
        }
    } else {
        // Pause between bursts
        if (pause_timer > 0) pause_timer--;
        if (pause_timer <= 0) {
            burst_left = burst_size;
            fire_timer = 0;
        }
    }
} else {
    // Target lost — stop the burst, cool off
    burst_left  = 0;
    pause_timer = max(pause_timer, 25);
}

image_xscale = facing;

// === COLLISION - VERTICAL === (no horizontal movement, ever)
if (place_meeting(x, y + vspd, obj_platform)) {
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;

if (muzzle_flash > 0) muzzle_flash--;
if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
