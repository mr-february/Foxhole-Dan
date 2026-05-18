// === DEATH ===
if (hp <= 0) {
    global.game_state = 3;
    instance_create_layer(x, y, "Instances", obj_cutscene);
    instance_destroy();
    exit;
}

// === PHASE TRANSITION ===
if (hp < max_hp * 0.5 && phase == 1) {
    phase = 2;
    move_spd  = 3;
    shoot_timer = 0;
    enrage_flash = 90;
}
if (enrage_flash > 0) enrage_flash--;

// === INVINCIBILITY ===
if (i_frames > 0) i_frames--;

// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p = instance_find(obj_dan, 0);
if (p == noone) exit;
var dist = point_distance(x, y, p.x, p.y);
facing = sign(p.x - x);

// === MOVEMENT ===
if (phase == 1) {
    // Patrol between arena bounds
    hspd = move_spd * sign((x < (patrol_left + patrol_right) * 0.5) ? 1 : -1);
    if (x < patrol_left)  { hspd =  move_spd; }
    if (x > patrol_right) { hspd = -move_spd; }
} else {
    // Phase 2: actively chase
    if (charge_timer > 0) {
        charge_timer--;
        // charging — keep hspd
    } else {
        hspd = move_spd * sign(p.x - x);
        // Random charge
        if (irandom(240) == 0 && dist < 600) {
            hspd = sign(p.x - x) * 8;
            charge_timer = 30;
        }
    }
}

// === SHOOTING ===
shoot_timer--;
if (shoot_timer <= 0 && dist < 1000) {
    var spread = (phase == 1) ? 3 : 5;
    var base_dir = point_direction(x, y - 28, p.x, p.y - 16);
    var angle_step = 18;
    var start_angle = base_dir - ((spread - 1) * 0.5 * angle_step);
    for (var i = 0; i < spread; i++) {
        var b = instance_create_layer(x, y - 28, "Instances", obj_enemy_bullet);
        b.direction  = start_angle + i * angle_step;
        b.speed      = (phase == 1) ? 6 : 8;
        b.image_angle = b.direction;
    }
    shoot_timer = (phase == 1) ? 90 : 55;
}

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd = 0;
}
x += hspd;

// === COLLISION - VERTICAL ===
if (place_meeting(x, y + vspd, obj_platform)) {
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;

image_xscale = facing;
