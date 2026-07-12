// === BODY ARMOR — brief invulnerability after each fresh hit ===
if (hp < prev_hp && i_frames == 0) i_frames = 3;
prev_hp = hp;

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
        // Aggressive advance — closes distance, holds at ledge edge
        var chase_dir = sign(p.x - x);
        if (grounded && chase_dir != 0 && !place_meeting(x + chase_dir * 16, y + 2, obj_platform)) {
            chase_dir = 0;
        }
        hspd   = chase_dir * move_spd;
        facing = (chase_dir != 0) ? chase_dir : facing;

        // === FAN FIRE (boss-style spread) ===
        if (shoot_timer > 0) shoot_timer--;
        if (shoot_timer <= 0 && dist < shoot_range) {
            var base_dir    = point_direction(x, y - 18, p.x, p.y - 10);
            var angle_step  = 15;
            var start_angle = base_dir - ((fan_count - 1) * 0.5 * angle_step);
            for (var i = 0; i < fan_count; i++) {
                var b = instance_create_layer(x, y - 18, "Instances", obj_enemy_bullet);
                b.direction   = start_angle + i * angle_step;
                b.speed       = 7;
                b.image_angle = b.direction;
            }
            shoot_timer = shoot_cd + irandom(20);
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
} else {
    hspd = 0;
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
