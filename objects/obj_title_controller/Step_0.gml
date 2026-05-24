var press_start    = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return);
var press_controls = keyboard_check_pressed(ord("C"));
var press_back     = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);
var press_up       = keyboard_check_pressed(vk_up)    || keyboard_check_pressed(ord("W"));
var press_down     = keyboard_check_pressed(vk_down)  || keyboard_check_pressed(ord("S"));

if (gamepad_is_connected(0)) {
    press_start    = press_start    || gamepad_button_check_pressed(0, gp_face1)
                                    || gamepad_button_check_pressed(0, gp_start);
    press_controls = press_controls || gamepad_button_check_pressed(0, gp_face3);
    press_back     = press_back     || gamepad_button_check_pressed(0, gp_face2);
    press_up       = press_up       || gamepad_button_check_pressed(0, gp_padu);
    press_down     = press_down     || gamepad_button_check_pressed(0, gp_padd);
}

if (state == 0) {
    if (press_start)    state = 2;   // go to difficulty select before playing
    if (press_controls) state = 1;
} else if (state == 1) {
    if (press_back || press_start) state = 0;
} else if (state == 2) {
    if (press_up)   diff_sel = (diff_sel - 1 + 4) mod 4;
    if (press_down) diff_sel = (diff_sel + 1) mod 4;
    if (press_start) {
        global.difficulty = diff_sel;
        room_goto(Room1);
    }
    if (press_back) state = 0;
}
