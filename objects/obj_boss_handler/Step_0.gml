// === DEATH ===
if (hp <= 0) {
    scr_award_kill(id, 1500);          // no gore — he's a boss, he just drops
    global.shake_mag   = max(global.shake_mag, 22.0);
    global.flash_timer = 14;
    global.game_state  = 1;            // obj_controller11 handles the room_goto
    audio_play_sound(snd_explosion, 10, false);
    instance_destroy();
    exit;
}

// === PHASE TRANSITION ===
if (hp < max_hp * 0.5 && phase == 1) {
    phase        = 2;
    move_spd     = 3.2;
    shoot_timer  = 0;
    enrage_flash = 90;
    summon_timer = min(summon_timer, 60);   // immediate reinforcement call
    global.shake_mag   = max(global.shake_mag, 18.0);
    global.flash_timer = 14;
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
        if (irandom(220) == 0 && dist < 600) {
            hspd = sign(p.x - x) * 9;
            charge_timer = 32;
        }
    }
}

// === SUMMON ADDS — MK-ECHO reinforcements ===
summon_timer--;
if (summon_timer <= 0 && dist < 1100) {
    var _adds = instance_number(obj_enemy_soldier) + instance_number(obj_enemy_dog);
    if (_adds < summon_max) {
        var _count = (phase == 2) ? 2 : 1;
        repeat (_count) {
            var _type = choose(obj_enemy_soldier, obj_enemy_dog);
            var _sx   = clamp(x + choose(-160, 160) + irandom_range(-30, 30), 64, room_width - 64);
            instance_create_layer(_sx, y - 4, "Instances", _type);
        }
        global.flash_timer = max(global.flash_timer, 8);
        global.shake_mag   = max(global.shake_mag, 6.0);
    }
    summon_timer = (phase == 1) ? 420 : 280;
}

// === SHOOTING — fan spreads ===
shoot_timer--;
if (shoot_timer <= 0 && dist < 1000) {
    var spread = (phase == 1) ? 3 : 5;
    var base_dir = point_direction(x, y - 30, p.x, p.y - 16);
    var angle_step = 16;
    var start_angle = base_dir - ((spread - 1) * 0.5 * angle_step);
    for (var i = 0; i < spread; i++) {
        var b = instance_create_layer(x, y - 30, "Instances", obj_enemy_bullet);
        b.direction  = start_angle + i * angle_step;
        b.speed      = (phase == 1) ? 6 : 8;
        b.image_angle = b.direction;
    }
    shoot_timer = (phase == 1) ? 100 : 60;
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
