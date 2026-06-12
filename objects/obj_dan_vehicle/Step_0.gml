if (global.game_state != 0) exit;

// Self-heal: controller2 Create calls audio_stop_all() after our Create, killing the engine loop
if (!audio_is_playing(engine_snd)) {
    engine_snd = audio_play_sound(snd_engine, 10, true);
    audio_sound_gain(engine_snd, 0.35, 0);
}

// === ACCELERATION / BRAKE (Up/W = faster, Down/S = slower) ===
var key_accel = keyboard_check(vk_up)   || keyboard_check(ord("W"));
var key_brake = keyboard_check(vk_down) || keyboard_check(ord("S"));
if (gamepad_is_connected(0)) {
    var _axis = gamepad_axis_value(0, gp_axislv);
    key_accel = key_accel || (_axis < -0.3);
    key_brake = key_brake || (_axis >  0.3);
}
var target_spd = 5.0;
if (key_accel) target_spd = 8.5;
if (key_brake) target_spd = 1.5;
move_spd = lerp(move_spd, target_spd, 0.07);

// === ENGINE SOUND ===
var target_pitch = 0.60 + (move_spd / 8.5) * 0.90;  // 0.60 idle -> 1.50 full throttle
eng_pitch = lerp(eng_pitch, target_pitch, 0.06);
audio_sound_pitch(engine_snd, eng_pitch);
var eng_vol = 0.35 + (move_spd / 8.5) * 0.50;       // volume rises with speed
audio_sound_gain(engine_snd, eng_vol, 0);

// === JUMP (Space / gamepad A only — separate from acceleration) ===
var key_jump = keyboard_check_pressed(vk_space);
if (gamepad_is_connected(0)) {
    key_jump = key_jump || gamepad_button_check_pressed(0, gp_face1);
}
if (on_ground && key_jump) {
    vspd      = -16;
    on_ground = false;
}

// === TERRAIN HEIGHT AT CURRENT X ===
var _ts  = clamp(floor(x / 200), 0, 59);
var _gnd = lerp(global.terrain_y[_ts], global.terrain_y[_ts + 1], (x - _ts * 200) / 200.0);

// === GRAVITY ===
var fall_mult = (vspd > 0) ? 1.25 : 1.0;
vspd += grav * fall_mult;
if (vspd > 20) vspd = 20;

// === VERTICAL COLLISION (terrain) ===
y += vspd;
if (y + 15 >= _gnd) {
    y         = _gnd - 15;
    vspd      = 0;
    on_ground = true;
} else {
    on_ground = false;
}

// === OBSTACLE HIT (ground contact only — jumping clears freely) ===
if (i_frames > 0) i_frames--;
if (on_ground && instance_place(x, y, obj_obstacle) != noone && i_frames == 0) {
    hp      -= obs_dmg;
    i_frames = 55;
}

// === ENEMY BULLET HIT ===
var eb = instance_place(x, y, obj_enemy_veh_bullet);
if (eb != noone && i_frames == 0) {
    hp      -= bullet_dmg;
    i_frames = 22;
    instance_destroy(eb);
}

// === MOUSE AIM (MG on pintle, pivot at x-23, y-47) ===
var _raw    = point_direction(x - 23, y - 47, mouse_x, mouse_y);
var _signed = (_raw > 180) ? _raw - 360 : _raw;
aim_dir     = clamp(_signed, -60, 60);
if (aim_dir < 0) aim_dir += 360;

// === SHOOT ===
var key_shoot = keyboard_check(ord("J")) || mouse_check_button(mb_left);
if (gamepad_is_connected(0)) {
    key_shoot = key_shoot
             || gamepad_button_check(0, gp_shoulderrb)
             || gamepad_button_check(0, gp_shoulderlb);
}
if (shoot_timer  > 0) shoot_timer--;
if (ammo <= 0 && reload_timer == 0) reload_timer = 80;
if (reload_timer > 0) {
    reload_timer--;
    if (reload_timer == 0) ammo = max_ammo;
}
if (key_shoot && shoot_timer <= 0 && ammo > 0 && reload_timer == 0) {
    var _bx = x - 23 + lengthdir_x(27, aim_dir);
    var _by = y - 47 + lengthdir_y(27, aim_dir);
    var b       = instance_create_layer(_bx, _by, "Instances", obj_vehicle_bullet);
    b.direction = aim_dir;
    b.speed     = 15;
    instance_create_layer(x - 20, y - 48, "Instances", obj_shell_casing);
    ammo--;
    shoot_timer = shoot_delay;
    shoot_flash = 5;
    audio_play_sound(snd_vehicle_gun, 10, false);
}
if (shoot_flash > 0) shoot_flash--;

// === SECONDARY (bomb drop — K / gamepad LB) ===
var key_bomb = keyboard_check_pressed(ord("K"));
if (gamepad_is_connected(0)) key_bomb = key_bomb || gamepad_button_check_pressed(0, gp_shoulderlb);
if (bomb_cd > 0) bomb_cd--;
if (key_bomb && bomb_count > 0 && bomb_cd == 0) {
    var _b   = instance_create_layer(x + 24, y - 8, "Instances", obj_grenade);
    _b.hvsp  = move_spd * 1.6;
    _b.vvsp  = -7;
    _b.fuse  = 85;
    _b.owner = 1;
    bomb_count--;
    bomb_cd = 55;
    audio_play_sound(snd_gunshot, 6, false);
}

// === DEATH ===
if (hp <= 0) {
    global.game_state = 2;
    audio_stop_all();
    audio_play_sound(snd_music_death, 100, false);
    instance_destroy();
    exit;
}

// === SLOPE — uphill slows, downhill boosts ===
var _ts_f  = clamp(floor((x + move_spd) / 200), 0, 59);
var _gnd_f = lerp(global.terrain_y[_ts_f], global.terrain_y[_ts_f + 1], ((x + move_spd) - _ts_f * 200) / 200.0);
var eff_spd = clamp(move_spd + (_gnd_f - _gnd) * 0.20, 0.6, 14.0);

// === DRIVE + WHEEL SPIN ===
x          += eff_spd;
wheel_spin += eff_spd * 2.5;

// === CAMERA ===
camera_set_view_pos(view_camera[0], x - 280, 0);

// === WIN ===
if (x >= 11600 && global.game_state == 0) {
    global.game_state = 3;
    try { steam_set_achievement("ach_room2"); } catch (_ex) {}
    instance_create_layer(0, 0, "Instances", obj_cutscene2);
}
