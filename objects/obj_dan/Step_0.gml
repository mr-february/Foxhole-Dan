if (global.hitstop_timer > 0) exit;

// === INPUT — keyboard ===
var key_right  = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left   = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var key_up     = keyboard_check(vk_up)    || keyboard_check(ord("W"));
var key_down   = keyboard_check(vk_down)  || keyboard_check(ord("S"));
var key_jump   = keyboard_check_pressed(global.key_jump);
var key_shoot  = keyboard_check(global.key_shoot) || mouse_check_button(mb_left);
var key_roll   = keyboard_check_pressed(global.key_roll);

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
    if (gamepad_button_check_pressed(0, gp_stickl))   key_roll  = true; // L3
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
    y    = room_height * 0.5;   // snap to room mid-height so gravity re-lands Dan on the floor
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
    var cam_h = camera_get_view_height(view_camera[0]);
    var look_ahead = facing * 150;
    var target_cx = clamp(x + look_ahead - cam_w / 2, 0, room_width - cam_w);
    var target_cy = clamp(y - cam_h * 0.72, 0, room_height - cam_h);
    var cur_cx = camera_get_view_x(view_camera[0]);
    var cur_cy = camera_get_view_y(view_camera[0]);
    camera_set_view_pos(view_camera[0], lerp(cur_cx, target_cx, 0.09), lerp(cur_cy, target_cy, 0.09));
    if (global.shake_mag > 0.5) {
        var _sm = global.shake_mag * global.shake_intensity;
        camera_set_view_pos(view_camera[0],
            camera_get_view_x(view_camera[0]) + random_range(-_sm, _sm),
            camera_get_view_y(view_camera[0]) + random_range(-_sm, _sm));
    }
}

// === AIM ===
// Priority: gamepad right stick > arrow keys > mouse cursor > facing direction
var aim_x = key_right - key_left;
var aim_y = key_down - key_up;
if (gp) {
    var rx2 = gamepad_axis_value(0, gp_axisrh);
    var ry2 = gamepad_axis_value(0, gp_axisrv);
    if (abs(rx2) > dead || abs(ry2) > dead) {
        aim_dir = point_direction(0, 0, rx2, ry2);
    } else if (aim_x != 0 || aim_y != 0) {
        aim_dir = point_direction(0, 0, aim_x, -aim_y);
    } else {
        aim_dir = (facing == 1) ? 0 : 180;
    }
} else {
    aim_dir = point_direction(x, y - 16, mouse_x, mouse_y);
}

// === SHOOTING ===
// Auto-reload when empty (suppressed during rage — infinite ammo)
if (ammo <= 0 && reload_timer == 0 && global.rage_timer <= 0) reload_timer = 110;
if (reload_timer > 0) {
    reload_timer--;
    if (reload_timer == 0) ammo = max_ammo;
}

if (shoot_timer > 0) shoot_timer--;
if (recoil > 0) recoil--;
if (key_shoot && shoot_timer <= 0 && !crouching && (ammo > 0 || global.rage_timer > 0) && reload_timer == 0) {
    var b = instance_create_layer(x, y - 16, "Instances", obj_bullet);
    b.direction   = aim_dir;
    b.speed       = 14;
    b.image_angle = aim_dir;
    shoot_timer   = (global.rage_timer > 0) ? max(4, shoot_delay / 2) : shoot_delay;
    if (global.rage_timer <= 0) ammo--;
    recoil = 5;
    hspd  -= lengthdir_x(0.55, aim_dir);
    global.shake_mag = max(global.shake_mag, 1.4);
    var _sc  = instance_create_layer(x + facing * 2, y - 18, "Instances", obj_shell_casing);
    _sc.hspd = -facing * random_range(2.5, 5.5);
    audio_play_sound(snd_gunshot, 10, false);
}

// === GRENADE (K / gamepad LB) ===
var key_grenade = keyboard_check_pressed(global.key_grenade);
if (gp && gamepad_button_check_pressed(0, gp_shoulderlb)) key_grenade = true;
if (grenade_cd > 0) grenade_cd--;
if (key_grenade && grenade_count > 0 && grenade_cd == 0 && !crouching) {
    var _g   = instance_create_layer(x + facing * 8, y - 16, "Instances", obj_grenade);
    _g.hvsp  = lengthdir_x(9, aim_dir);
    _g.vvsp  = lengthdir_y(9, aim_dir) - 7;
    _g.fuse  = 110;
    _g.owner = 1;
    grenade_count--;
    grenade_cd = 35;
    audio_play_sound(snd_gunshot, 6, false);
}

// === CHECKPOINTS (Room3) ===
if (instance_exists(obj_controller3)) {
    if (y < 1820 && global.checkpoint3_y == 0) {
        global.checkpoint3_y = 1820;
        global.memory_text   = "—  CHECKPOINT  —";
        global.memory_timer  = 200;
    } else if (y < 920 && global.checkpoint3_y < 920) {
        global.checkpoint3_y = 920;
        global.memory_text   = "—  CHECKPOINT  —";
        global.memory_timer  = 200;
    }
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
    if (global.game_state != 2) {
        global.total_deaths++;
        if (global.total_deaths == 25) { try { steam_set_achievement("ach_deaths"); } catch (_ex) {} }
        if (os_browser == browser_not_a_browser) {
            ini_open("foxhole_dan.ini");
            ini_write_real("stats", "lifetime_deaths", ini_read_real("stats", "lifetime_deaths", 0) + 1);
            ini_close();
        }
        global.pstat_lifetime_deaths += 1;
        global.game_state = 2;
        audio_stop_all();
        audio_play_sound(snd_music_death, 100, false);
    }
    if (hook_inst != noone && instance_exists(hook_inst)) {
        instance_destroy(hook_inst);
        hook_inst = noone;
    }
}
