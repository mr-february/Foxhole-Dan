// === DEATH ===
if (hp <= 0) {
    scr_award_kill(id, 1000);
    global.shake_mag        = max(global.shake_mag, 22.0);
    global.flash_timer      = 14;
    global.game_state       = 3;
    instance_create_layer(x, y, "Instances", obj_cutscene);
    instance_destroy();
    exit;
}

// === PHASE TRANSITIONS ===
if (hp < max_hp * 0.5 && phase == 1) {
    phase        = 2;
    move_spd     = 3;
    shoot_timer  = 0;
    enrage_flash = 90;
    global.shake_mag   = max(global.shake_mag, 18.0);
    global.flash_timer = 14;
}
if (hp < max_hp * 0.25 && phase == 2) {
    phase        = 3;
    move_spd     = 3.6;
    shoot_timer  = 0;
    enrage_flash = 70;
    gren_timer   = 90;
    global.shake_mag   = max(global.shake_mag, 20.0);
    global.flash_timer = 14;
    audio_play_sound(snd_ptsd_horn, 8, false);
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
    // Phase 2+: actively chase with telegraphed charges
    if (charge_windup > 0) {
        charge_windup--;
        hspd = 0;
        if (charge_windup == 0) {
            hspd = sign(p.x - x) * ((phase == 3) ? 10 : 8);
            charge_timer = 30;
            global.shake_mag = max(global.shake_mag, 6.0);
        }
    } else if (charge_timer > 0) {
        charge_timer--;
        // charging — keep hspd
    } else {
        hspd = move_spd * sign(p.x - x);
        // Telegraphed charge — windup pause first
        if (irandom((phase == 3) ? 140 : 240) == 0 && dist < 600) {
            charge_windup = 22;
        }
    }
}

// === CONTACT DAMAGE — getting close to The Sergeant is a mistake ===
if (dist < 42 && p.i_frames == 0 && global.game_state == 0) {
    p.hp        -= 12;
    p.ptsd_meter = min(p.ptsd_meter + 20, p.ptsd_max);
    p.i_frames   = 40;
    p.hspd       = sign(p.x - x) * 9;
    p.vspd       = min(p.vspd, -5);
    global.shake_mag = max(global.shake_mag, 9.0);
    audio_play_sound(snd_player_hurt, 10, false);
}

// === PHASE 3: DESPERATION GRENADES ===
if (phase == 3) {
    if (gren_timer > 0) gren_timer--;
    if (gren_timer <= 0 && dist > 80 && dist < 520) {
        var _bg   = instance_create_layer(x, y - 30, "Instances", obj_grenade);
        _bg.hvsp  = (p.x - x) / 48.0;
        _bg.vvsp  = -8.5;
        _bg.owner = 0;
        gren_timer = 130 + irandom(80);
    }
}

// === SHOOTING ===
shoot_timer--;
if (shoot_timer <= 0 && dist < 1000 && charge_windup <= 0) {
    var spread = (phase == 1) ? 3 : ((phase == 2) ? 5 : 7);
    var base_dir = point_direction(x, y - 28, p.x, p.y - 16);
    var angle_step = (phase == 3) ? 13 : 18;
    var start_angle = base_dir - ((spread - 1) * 0.5 * angle_step);
    for (var i = 0; i < spread; i++) {
        var b = instance_create_layer(x, y - 28, "Instances", obj_enemy_bullet);
        b.direction  = start_angle + i * angle_step;
        b.speed      = (phase == 1) ? 6 : ((phase == 2) ? 8 : 9);
        b.image_angle = b.direction;
    }
    shoot_timer = (phase == 1) ? 90 : ((phase == 2) ? 55 : 42);
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
