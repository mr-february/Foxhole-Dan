if (global.game_state != 0) exit;

if (i_frames    > 0) i_frames--;
if (hit_flash   > 0) hit_flash--;
if (shoot_flash > 0) shoot_flash--;

// === TERRAIN HEIGHT ===
var _ts  = clamp(floor(x / 200), 0, 59);
var _gnd = lerp(global.terrain_y[_ts], global.terrain_y[_ts + 1], (x - _ts * 200) / 200.0);

// === GRAVITY ===
var fall_mult = (vspd > 0) ? 1.3 : 1.0;
vspd += grav * fall_mult;
if (vspd > 20) vspd = 20;

y += vspd;
if (y + 15 >= _gnd) {
    y         = _gnd - 15;
    vspd      = 0;
    on_ground = true;
} else {
    on_ground = false;
}

// === FIND PLAYER VEHICLE ===
var p = instance_find(obj_dan_vehicle, 0);
if (p == noone) exit;

var dist      = abs(x - p.x);
var aggressive = (dist < 650);

if (aggressive) {
    facing = sign(p.x - x);
    hspd   = facing * move_spd;

    // Shoot at player
    shoot_timer--;
    if (shoot_timer <= 0 && dist < 600) {
        var b        = instance_create_layer(x + facing * 50, y - 14, "Instances", obj_enemy_veh_bullet);
        b.direction  = (facing == 1) ? 0 : 180;
        b.speed      = 10;
        shoot_timer  = 90 + irandom(70);
        shoot_flash  = 5;
        audio_play_sound(snd_vehicle_gun, 9, false);
    }
} else {
    // Patrol in zone
    if (x <= zone_left)  { facing =  1; }
    if (x >= zone_right) { facing = -1; }
    hspd = facing * (move_spd * 0.6);
}

x += hspd;

image_xscale = facing;
wheel_spin  += abs(hspd) * 2.5;

// === DEATH ===
if (hp <= 0) {
    var d    = instance_create_layer(x, y - 30, "Instances", obj_damage_number);
    d.amount = 60;
    instance_destroy();
    exit;
}
