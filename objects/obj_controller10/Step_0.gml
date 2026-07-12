if (global.shake_mag > 0.05) global.shake_mag *= 0.82; else global.shake_mag = 0;
if (global.flash_timer > 0)  global.flash_timer--;

scr_combo_tick();
if (global.game_state == 0) global.run_time++;

// === CAMERA — follow the swimmer horizontally ===
var vw = camera_get_view_width(view_camera[0]);
var vh = camera_get_view_height(view_camera[0]);
if (instance_exists(obj_dan_swim)) {
    var p = instance_find(obj_dan_swim, 0);
    var target = clamp(p.x - vw * 0.4, 0, max(0, room_width - vw));
    cam_x = lerp(cam_x, target, 0.12);

    // === WIN ===
    if (global.game_state == 0 && p.x > exit_x) {
        global.game_state = 1;
    }
}
var shx = (global.shake_mag > 0.5) ? random_range(-global.shake_mag, global.shake_mag) : 0;
var shy = (global.shake_mag > 0.5) ? random_range(-global.shake_mag, global.shake_mag) : 0;
camera_set_view_pos(view_camera[0], cam_x + shx, shy);

if (global.game_state == 1) {
    win_timer++;
    if (win_timer >= 150) { room_goto(Room11); exit; }
}

// === RESTART ===
var restart = keyboard_check_pressed(ord("R"));
if (!restart && gamepad_is_connected(0)) {
    restart = gamepad_button_check_pressed(0, gp_start) || gamepad_button_check_pressed(0, gp_face1);
}
if ((global.game_state == 1 || global.game_state == 2) && restart) {
    global.game_state = 0;
    room_restart();
}
