// === INPUT — keyboard ===
var key_right  = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left   = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var key_up     = keyboard_check(vk_up)    || keyboard_check(ord("W"));
var key_down   = keyboard_check(vk_down)  || keyboard_check(ord("S"));
var key_jump   = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var key_shoot  = keyboard_check(ord("J")) || mouse_check_button(mb_left);
var key_roll   = keyboard_check_pressed(vk_shift);

// === INPUT — gamepad (device 0) ===
var gp = gamepad_is_connected(0);
var dead = 0.2; // stick deadzone

if (gp) {
    var lx = gamepad_axis_value(0, gp_axislh);
    var ly = gamepad_axis_value(0, gp_axislv);
    var rx = gamepad_axis_value(0, gp_axisrh);
    var ry = gamepad_axis_value(0, gp_axisrv);

    if (lx >  dead) key_right = true;
    if (lx < -dead) key_left  = true;
    if (ly < -dead) key_up    = true;
    if (ly >  dead) key_down  = true;

    if (gamepad_button_check_pressed(0, gp_face1)) key_jump  = true;  // A / Cross
    if (gamepad_button_check(0, gp_shoulderr))     key_shoot = true;  // RB / R1
    if (gamepad_button_check(0, gp_shoulderrb))    key_shoot = true;  // RT / R2
    if (gamepad_axis_value(0, gp_axisrtrigger) > 0.3) key_shoot = true; // RT axis fallback
    if (gamepad_button_check_pressed(0, gp_thumbl))   key_roll  = true; // L3
}

// === HORIZONTAL MOVEMENT ===
var move_input = key_right - key_left;
crouching = key_down && on_ground;

if (!crouching) {
    var target_hspd = move_input * move_spd;
    if (move_input != 0) {
        facing = move_input;
        // Accelerate toward target speed
        hspd = lerp(hspd, target_hspd, on_ground ? 0.22 : 0.10);
    } else {
        // Friction — faster on ground than in air
        hspd = lerp(hspd, 0, on_ground ? 0.28 : 0.06);
        if (abs(hspd) < 0.15) hspd = 0;
    }
}

// === DODGE ROLL ===
if (roll_cd > 0) roll_cd--;
if (roll_timer > 0) {
    roll_timer--;
    hspd        = facing * move_spd * 3.2;
    i_frames    = max(i_frames, roll_timer + 1);
    shoot_timer = max(shoot_timer, 2);
    if (roll_timer <= 0) roll_cd = 45;
} else if (key_roll && on_ground && roll_cd <= 0 && !crouching) {
    roll_timer = roll_dur;
    i_frames   = max(i_frames, roll_dur + 2);
    audio_play_sound(snd_roll, 8, false);
}

// === GRAVITY ===
var _swinging = (hook_inst != noone && instance_exists(hook_inst) && hook_inst.lodged && !on_ground);
var fall_mult  = (vspd > 0) ? (_swinging ? 0.7 : 1.3) : 1.0;
var grav_mul   = _swinging ? 0.5 : 1.0;   // half gravity while on the rope
vspd += grav * fall_mult * grav_mul;
if (vspd > 20) vspd = 20;

// === GRAPPLING HOOK ===
// G / Y — fire or cancel.  W/S (or L-stick up/down) — retract / extend rope.
var key_hook = keyboard_check_pressed(ord("G"));
if (gp && gamepad_button_check_pressed(0, gp_face4)) key_hook = true;

if (key_hook) {
    if (hook_inst != noone && instance_exists(hook_inst)) {
        instance_destroy(hook_inst);
        hook_inst = noone;
    } else {
        var _h       = instance_create_layer(x, y - 16, "Instances", obj_hook);
        _h.direction = aim_dir;
        _h.speed     = 28;
        _h.owner     = id;
        hook_inst    = _h;
        rope_len     = 0;
    }
}

if (hook_inst != noone && !instance_exists(hook_inst)) hook_inst = noone;

// Rope length adjustment while swinging (W/S or L-stick vertical)
if (hook_inst != noone && hook_inst.lodged) {
    if (key_up)   rope_len = max(48,  rope_len - 3);
    if (key_down) rope_len = min(680, rope_len + 3);
}

// === GROUND CHECK ===
on_ground = place_meeting(x, y + 1, obj_platform);

// === JUMP ===
if (on_ground && key_jump) {
    vspd = jump_spd;
    on_ground = false;
}

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    while (!place_meeting(x + sign(hspd), y, obj_platform)) x += sign(hspd);
    hspd = 0;
}
x += hspd;

// === COLLISION - VERTICAL ===
if (place_meeting(x, y + vspd, obj_platform)) {
    var _vs = sign(vspd);
    while (!place_meeting(x, y + _vs, obj_platform)) y += _vs;
    if (_vs < 0) y++;   // nudge 1px away from ceiling so Dan doesn't stick
    vspd = 0;
}
y += vspd;

// === ROPE SWING CONSTRAINT ===
// Enforce Dan's distance to the anchor ≤ rope_len (pendulum physics).
// Runs after movement so gravity and input contribute to swing momentum.
if (hook_inst != noone && instance_exists(hook_inst) && hook_inst.lodged && !on_ground) {
    var _ax   = hook_inst.x;
    var _ay   = hook_inst.y;
    var _ddx  = x - _ax;
    var _ddy  = (y - 16) - _ay;
    var _dist = sqrt(_ddx * _ddx + _ddy * _ddy);
    if (rope_len <= 0) rope_len = max(_dist, 48);
    if (_dist > rope_len && _dist > 1) {
        var _nx = _ddx / _dist;
        var _ny = _ddy / _dist;
        // Reposition Dan onto the rope circle
        x = _ax + _nx * rope_len;
        y = (_ay + _ny * rope_len) + 16;
        // Cancel the outward (rope-stretching) velocity component
        var _vr = hspd * _nx + vspd * _ny;
        if (_vr > 0) {
            hspd -= _vr * _nx;
            vspd -= _vr * _ny;
        }
    }
}

// Out-of-bounds safety
if (y > room_height + 50) {
    // Snap to just above the ground floor (y=2920) so gravity lands Dan on it
    y    = 2880;
    vspd = 0;
    hspd = 0;
    // Cancel any active hook — it's almost certainly detached
    if (hook_inst != noone && instance_exists(hook_inst)) {
        instance_destroy(hook_inst);
        hook_inst = noone;
    }
}
// Clamp horizontal — no walls in Room3, so prevent walking off the edge
x = clamp(x, 0, room_width);

// === CAMERA FOLLOW with look-ahead ===
// Room3 uses obj_controller3 for vertical camera — Dan must not interfere
if (!instance_exists(obj_controller3)) {
    var cam_w = camera_get_view_width(view_camera[0]);
    var look_ahead = facing * 260;
    var target_cx = clamp(x + look_ahead - cam_w / 2, 0, room_width - cam_w);
    var cur_cx = camera_get_view_x(view_camera[0]);
    var cur_cy = camera_get_view_y(view_camera[0]);
    camera_set_view_pos(view_camera[0], lerp(cur_cx, target_cx, 0.12), lerp(cur_cy, 0, 0.12));
    if (global.shake_mag > 0.5) {
        camera_set_view_pos(view_camera[0],
            camera_get_view_x(view_camera[0]) + random_range(-global.shake_mag, global.shake_mag),
            camera_get_view_y(view_camera[0]) + random_range(-global.shake_mag, global.shake_mag));
    }
}

// === AIM ===
// Right stick takes priority when pushed, otherwise keyboard/facing
var aim_x = key_right - key_left;
var aim_y = key_down - key_up;
if (gp) {
    var rx = gamepad_axis_value(0, gp_axisrh);
    var ry = gamepad_axis_value(0, gp_axisrv);
    if (abs(rx) > dead || abs(ry) > dead) {
        aim_dir = point_direction(0, 0, rx, ry);
        aim_x = 0; aim_y = 0; // suppress keyboard aim override below
    }
}
if (aim_x != 0 || aim_y != 0) {
    aim_dir = point_direction(0, 0, aim_x, -aim_y);
} else if (!gp || (abs(gamepad_axis_value(0, gp_axisrh)) <= dead && abs(gamepad_axis_value(0, gp_axisrv)) <= dead)) {
    aim_dir = (facing == 1) ? 0 : 180;
}

// === SHOOTING ===
// Auto-reload when empty
if (ammo <= 0 && reload_timer == 0) reload_timer = 110;
if (reload_timer > 0) {
    reload_timer--;
    if (reload_timer == 0) ammo = max_ammo;
}

if (shoot_timer > 0) shoot_timer--;
if (key_shoot && shoot_timer <= 0 && !crouching && ammo > 0 && reload_timer == 0) {
    var b = instance_create_layer(x, y - 16, "Instances", obj_bullet);
    b.direction   = aim_dir;
    b.speed       = 14;
    b.image_angle = aim_dir;
    shoot_timer   = shoot_delay;
    ammo--;
    audio_play_sound(snd_gunshot, 10, false);
}

// === PTSD METER ===
// Fills from danger; depletes in safety
var enemy_near = false;
with (obj_enemy_soldier) {
    if (point_distance(x, y, other.x, other.y) < 200) { enemy_near = true; break; }
}
if (!enemy_near) {
    with (obj_boss) {
        if (point_distance(x, y, other.x, other.y) < 300) { enemy_near = true; break; }
    }
}

if (enemy_near) {
    ptsd_meter = min(ptsd_meter + 0.06, ptsd_max);
} else {
    ptsd_meter = max(ptsd_meter - 0.03, 0);
}

// Passive build when in flashback
if (flashback_active) ptsd_meter = min(ptsd_meter + 0.4, ptsd_max);

// Bullet near-miss stress
with (obj_enemy_bullet) {
    if (point_distance(x, y, other.x, other.y) < 80) {
        other.ptsd_meter = min(other.ptsd_meter + 0.5, other.ptsd_max);
    }
}

// Overload — force flashback
if (ptsd_meter >= ptsd_max && !flashback_active && flashback_cooldown == 0) {
    flashback_active = true;
    flashback_timer  = flashback_duration;
    ptsd_meter       = 65;
    global.shake_mag = max(global.shake_mag, 9.0);
}

// === FLASHBACK ===
if (flashback_cooldown > 0) flashback_cooldown--;
if (!flashback_active && flashback_cooldown == 0) {
    if (irandom(3600) == 0) {
        flashback_active = true;
        flashback_timer  = flashback_duration;
    }
}
if (flashback_active) {
    flashback_timer--;
    hp -= 0.05;
    if (flashback_timer <= 0) {
        flashback_active   = false;
        flashback_cooldown = 1800;
    }
}

// === INVINCIBILITY FRAMES ===
if (i_frames > 0) i_frames--;

// === DEATH ===
if (hp <= 0) {
    hp = 0;
    global.game_state = 2;
    if (hook_inst != noone && instance_exists(hook_inst)) {
        instance_destroy(hook_inst);
        hook_inst = noone;
    }
}
