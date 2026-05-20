// === VERTICAL CAMERA ===
// Dan's Step_0 hardcodes target_cy=0 for horizontal levels.
// This controller runs at depth=-9999 (last), overriding that with a
// smooth vertical follow each frame.
var p = instance_find(obj_dan, 0);
if (p != noone && global.game_state == 0) {
    var cam_h  = camera_get_view_height(view_camera[0]);
    // Keep Dan 55% down from the top of the view so you can see above him
    var target = clamp(p.y - cam_h * 0.55, 0, room_height - cam_h);
    cam_y = lerp(cam_y, target, 0.10);
    camera_set_view_pos(view_camera[0], 0, cam_y);

    // Dan reaches exit platform — start capture transition
    if (p.y < 280 && transition_timer == 0) {
        global.game_state = 1;  // triggers narrative overlay in Draw_64
        transition_timer  = 1;
    }
}

// Capture transition: show narrative text then load Room4
if (transition_timer > 0) {
    transition_timer++;
    if (transition_timer >= 240) {  // 4 seconds of text
        room_goto(Room4);
        exit;
    }
}

// Restart (only from death, not from capture — Room4 handles its own restart)
if (global.game_state == 2) {
    var restart = keyboard_check_pressed(ord("R"));
    if (!restart && gamepad_is_connected(0)) {
        restart = gamepad_button_check_pressed(0, gp_start)
               || gamepad_button_check_pressed(0, gp_face1);
    }
    if (restart) {
        global.game_state = 0;
        room_restart();
    }
}
