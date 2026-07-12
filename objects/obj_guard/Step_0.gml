// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;
var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

sees_dan = false;

if (instance_exists(obj_dan)) {
    var p    = instance_find(obj_dan, 0);
    var dist = point_distance(x, y, p.x, p.y);

    // Is Dan hidden? Crouching or standing in a shadow zone breaks line of sight.
    var hidden = false;
    if (variable_instance_exists(p, "crouching") && p.crouching) hidden = true;
    with (obj_shadow_zone) {
        if (p.x > x - zw && p.x < x + zw && p.y > y - zh && p.y < y + 8) hidden = true;
    }

    // Vision cone: within range, roughly in front, and not hidden (point-blank still sees).
    if (dist < view_dist) {
        var ang    = point_direction(x, y - 20, p.x, p.y - 20);
        var facing_ang = (facing > 0) ? 0 : 180;
        var in_cone = abs(angle_difference(ang, facing_ang)) < view_cone;
        if ((in_cone && !hidden) || dist < 70) sees_dan = true;
    }

    if (sees_dan) {
        // Raise the shared alarm and turn to face Dan.
        global.stealth_alert = min(global.stealth_alert + 1.6, 100);
        facing = sign(p.x - x);
        if (facing == 0) facing = 1;
        alert_state = (global.stealth_alert >= 60) ? 2 : 1;

        // Once the base is hot, guards shoot.
        if (global.stealth_alert >= 40) {
            hspd = 0;
            shoot_timer--;
            if (shoot_timer <= 0 && dist < view_dist) {
                var b = instance_create_layer(x + facing * 22, y - 18, "Instances", obj_enemy_bullet);
                b.direction  = point_direction(x, y - 18, p.x, p.y - 16);
                b.speed      = 9;
                b.image_angle = b.direction;
                shoot_timer  = shoot_cd;
            }
        } else {
            // Suspicious but not yet shooting — advance a little toward Dan.
            hspd = sign(p.x - x) * move_spd;
        }
    } else {
        alert_state = (global.stealth_alert >= 40) ? 1 : 0;
        // Patrol
        hspd = facing * move_spd;
        if (x <= patrol_left)  { facing =  1; }
        if (x >= patrol_right) { facing = -1; }
    }
} else {
    hspd = 0;
}

image_xscale = facing;

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd = 0;
    facing *= -1;
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
