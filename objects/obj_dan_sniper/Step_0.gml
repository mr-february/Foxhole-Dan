// === AIM (mouse or right-stick) ===
var gp = gamepad_is_connected(0);
if (gp && (abs(gamepad_axis_value(0, gp_axisrh)) > 0.2 || abs(gamepad_axis_value(0, gp_axisrv)) > 0.2)) {
    aim_x += gamepad_axis_value(0, gp_axisrh) * 22;
    aim_y += gamepad_axis_value(0, gp_axisrv) * 22;
} else {
    aim_x = mouse_x;
    aim_y = mouse_y;
}
aim_x = clamp(aim_x, 0, room_width);
aim_y = clamp(aim_y, 0, room_height);

// === SCOPE toggle ===
scoped = mouse_check_button(mb_right);
if (gp && gamepad_button_check(0, gp_shoulderl)) scoped = true;

// === RELOAD ===
if (reloading > 0) {
    reloading--;
    if (reloading <= 0) ammo = max_ammo;
} else if (ammo <= 0) {
    reloading = 90;
}

// === FIRE ===
if (fire_timer > 0) fire_timer--;
var fire = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(ord("J"));
if (gp) fire = fire || gamepad_button_check_pressed(0, gp_shoulderr) || gamepad_button_check_pressed(0, gp_face3);
if (fire && fire_timer <= 0 && reloading <= 0 && ammo > 0) {
    var muzx = nest_x + 10, muzy = nest_y - 20;
    var b = instance_create_layer(muzx, muzy, "Instances", obj_bullet);
    b.direction   = point_direction(muzx, muzy, aim_x, aim_y);
    b.speed       = 28;                 // sniper round — fast
    b.image_angle = b.direction;
    fire_timer = fire_cd;
    ammo--;
    global.shake_mag = max(global.shake_mag, 3.0);
    audio_play_sound(snd_gunshot, 8, false);
}

if (i_frames > 0) i_frames--;

// === DEATH ===
if (hp <= 0 && global.game_state == 0) {
    global.game_state = 2;
    audio_stop_all();
    audio_play_sound(snd_music_death, 100, false);
}
