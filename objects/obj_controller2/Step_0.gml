var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start)
           || gamepad_button_check_pressed(0, gp_face1);
}
if ((global.game_state == 1 || global.game_state == 2) && restart) {
    global.game_state = 0;
    room_restart();
}
