rotor += 0.9;

// === AIM (mouse / right-stick) ===
var gp = gamepad_is_connected(0);
if (gp && (abs(gamepad_axis_value(0, gp_axisrh)) > 0.2 || abs(gamepad_axis_value(0, gp_axisrv)) > 0.2)) {
    aim_x += gamepad_axis_value(0, gp_axisrh) * 24;
    aim_y += gamepad_axis_value(0, gp_axisrv) * 24;
} else {
    aim_x = mouse_x;
    aim_y = mouse_y;
}
aim_x = clamp(aim_x, 0, room_width);
aim_y = clamp(aim_y, 0, room_height);

// === FIRE (door gun) ===
if (fire_timer > 0) fire_timer--;
var fire = mouse_check_button(mb_left) || keyboard_check(ord("J"));
if (gp) fire = fire || gamepad_button_check(0, gp_shoulderr) || gamepad_button_check(0, gp_face3);
if (fire && fire_timer <= 0) {
    var muzx = x + 18, muzy = y + 30;   // gun hangs out the door
    var b = instance_create_layer(muzx, muzy, "Instances", obj_bullet);
    b.direction   = point_direction(muzx, muzy, aim_x, aim_y) + random_range(-3, 3);
    b.speed       = 20;
    b.image_angle = b.direction;
    fire_timer = fire_cd;
    if (fire_timer == fire_cd) audio_play_sound(snd_gunshot, 6, false);
}

if (i_frames > 0) i_frames--;

// === DEATH ===
if (chopper_hp <= 0 && global.game_state == 0) {
    global.game_state = 2;
    global.shake_mag = max(global.shake_mag, 20);
    audio_stop_all();
    audio_play_sound(snd_explosion, 10, false);
    audio_play_sound(snd_music_death, 100, false);
}
