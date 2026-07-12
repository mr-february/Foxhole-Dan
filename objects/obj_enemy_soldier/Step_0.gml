if (global.hitstop_timer > 0) exit;

// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p    = instance_find(obj_dan, 0);
var dist = (p != noone) ? point_distance(x, y, p.x, p.y) : 9999;
var has_los = (p != noone) && (collision_line(x, y - 15, p.x, p.y - 15, obj_platform, true, true) == noone);

if (p != noone && dist < aggro_range && has_los) {

    // ----- ALERT REACTION — brief freeze when first spotting Dan -----
    if (!alerted) {
        alerted     = true;
        alert_timer = 16 + irandom(10);
    }

    if (alert_timer > 0) {
        alert_timer--;
        hspd   = lerp(hspd, 0, 0.4);
        facing = sign(p.x - x);

    // ----- COVER BEHAVIOR -----
    } else if (cover_timer > 0) {
        cover_timer--;
        hspd   = lerp(hspd, 0, 0.3);
        facing = sign(p.x - x);

    } else {
        // Random cover when hurt
        if (hp < 80 && irandom(200) == 0 && grounded) {
            cover_timer = 65 + irandom(55);
        }

        // Chase — hold at ledge edge; back off while firing if Dan is in his face
        var chase_dir = sign(p.x - x);
        var chase_spd = move_spd;
        if (dist < 90) {
            chase_dir = -chase_dir;
            chase_spd = move_spd * 0.55;
        }
        if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
            chase_dir = 0;
        }
        hspd   = chase_dir * chase_spd;
        facing = sign(p.x - x);

        // Shoot — 3-round bursts with slight spread
        if (shoot_timer > 0) shoot_timer--;
        if (shoot_timer <= 0 && burst_left <= 0 && dist < shoot_range) {
            burst_left  = 3;
            burst_gap   = 0;
            shoot_timer = 100 + irandom(70);
        }
        if (burst_left > 0) {
            if (burst_gap > 0) {
                burst_gap--;
            } else {
                var b = instance_create_layer(x, y - 15, "Instances", obj_enemy_bullet);
                b.direction   = point_direction(x, y, p.x, p.y) + random_range(-4, 4);
                b.speed       = 7;
                b.image_angle = b.direction;
                burst_left--;
                burst_gap = 7;
            }
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
    alerted = false;
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
