if (fade > 0) { fade--; exit; }

var press = keyboard_check_pressed(vk_space)
         || keyboard_check_pressed(vk_return)
         || mouse_check_button_pressed(mb_left);
if (gamepad_is_connected(0)) {
    press = press
         || gamepad_button_check_pressed(0, gp_face1)
         || gamepad_button_check_pressed(0, gp_start);
}

if (press) {
    panel++;
    fade = 28;
    if (panel >= panels) {
        room_goto(Room3);
    }
}
