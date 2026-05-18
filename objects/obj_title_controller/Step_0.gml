var press_start    = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return);
var press_controls = keyboard_check_pressed(ord("C"));
var press_back     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

if (gamepad_is_connected(0)) {
    press_start    = press_start    || gamepad_button_check_pressed(0, gp_face1)
                                    || gamepad_button_check_pressed(0, gp_start);
    press_controls = press_controls || gamepad_button_check_pressed(0, gp_face3);
    press_back     = press_back     || gamepad_button_check_pressed(0, gp_face2);
}

if (state == 0) {
    if (press_start)    room_goto(Room1);
    if (press_controls) state = 1;
} else {
    if (press_back || press_start) state = 0;
}
