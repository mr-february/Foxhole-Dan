bub += 0.2;

// === INPUT (8-directional swim) ===
var gp = gamepad_is_connected(0);
var ix = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var iy = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));
if (gp) {
    if (gamepad_axis_value(0, gp_axislh) < -0.2) ix = -1;
    if (gamepad_axis_value(0, gp_axislh) >  0.2) ix =  1;
    if (gamepad_axis_value(0, gp_axislv) < -0.2) iy = -1;
    if (gamepad_axis_value(0, gp_axislv) >  0.2) iy =  1;
}

hspd += ix * accel;
vspd += iy * accel;
// Buoyancy — always a gentle upward pull.
vspd -= 0.10;
// Drag
hspd *= drag;
vspd *= drag;
hspd = clamp(hspd, -swim_max, swim_max);
vspd = clamp(vspd, -swim_max, swim_max);

if (ix != 0) facing = ix;

x += hspd;
y += vspd;
x = clamp(x, 20, room_width - 20);
y = clamp(y, 40, room_height - 20);

// === AIR ===
if (y > surface_y + 10) {
    air -= air_drain;
    if (air <= 0) {
        air = 0;
        if (i_frames == 0) { hp -= 0.5; }   // drowning
    }
} else {
    air = min(air + 1.6, air_max);          // gulp air at the surface
}

// === FIRE (spear/knife — reuse obj_bullet) ===
if (fire_timer > 0) fire_timer--;
var fire = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("J"));
if (gp) fire = fire || gamepad_button_check_pressed(0, gp_shoulderr) || gamepad_button_check_pressed(0, gp_face3);
if (fire && fire_timer <= 0) {
    var b = instance_create_layer(x + facing * 14, y, "Instances", obj_bullet);
    b.direction   = (facing > 0) ? 0 : 180;
    b.speed       = 12;
    b.image_angle = b.direction;
    fire_timer = fire_cd;
}

if (i_frames > 0) i_frames--;

// === DEATH ===
if (hp <= 0 && global.game_state == 0) {
    global.game_state = 2;
    audio_stop_all();
    audio_play_sound(snd_music_death, 100, false);
}
