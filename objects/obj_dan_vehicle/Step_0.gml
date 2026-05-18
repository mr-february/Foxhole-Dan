if (global.game_state != 0) exit;

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

// === JUMP (Space / gamepad A only — separate from acceleration) ===
var key_jump = keyboard_check_pressed(vk_space);
if (gamepad_is_connected(0)) {
    key_jump = key_jump || gamepad_button_check_pressed(0, gp_face1);
}
if (on_ground && key_jump) {
    vspd      = -16;
    on_ground = false;
}

// === GRAVITY ===
var fall_mult = (vspd > 0) ? 1.25 : 1.0;
vspd += grav * fall_mult;
if (vspd > 20) vspd = 20;

// === VERTICAL COLLISION ===
if (place_meeting(x, y + vspd, obj_platform)) {
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd      = 0;
    on_ground = true;
} else {
    on_ground = false;
}
y += vspd;

// === OBSTACLE HIT (ground contact only — jumping clears freely) ===
if (i_frames > 0) i_frames--;
if (on_ground && instance_place(x, y, obj_obstacle) != noone && i_frames == 0) {
    hp      -= 25;
    i_frames = 55;
}

// === ENEMY BULLET HIT ===
var eb = instance_place(x, y, obj_enemy_veh_bullet);
if (eb != noone && i_frames == 0) {
    hp      -= 20;
    i_frames = 22;
    instance_destroy(eb);
}

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
    var b       = instance_create_layer(x + 52, y - 14, "Instances", obj_vehicle_bullet);
    b.direction = 0;
    b.speed     = 15;
    ammo--;
    shoot_timer = shoot_delay;
}

// === DEATH ===
if (hp <= 0) {
    global.game_state = 2;
    instance_destroy();
    exit;
}

// === DRIVE + WHEEL SPIN ===
x          += move_spd;
wheel_spin += move_spd * 2.5;

// === CAMERA ===
camera_set_view_pos(view_camera[0], x - 280, 0);

// === WIN ===
if (x >= 7600 && global.game_state == 0) {
    global.game_state = 3;
    instance_create_layer(0, 0, "Instances", obj_cutscene2);
}
