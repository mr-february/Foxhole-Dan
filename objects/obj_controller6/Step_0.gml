phase_timer++;

switch (phase) {
    case 0:
        if (phase_timer >= 120) { phase = 1; phase_timer = 0; }
        break;
    case 1:
        if (!ach_fired) {
            steam_set_achievement("ach_ending");
            ach_fired = true;
        }
        if (phase_timer >= 90) { phase = 2; phase_timer = 0; }
        break;
    case 2:
        if (phase_timer >= 120) { phase = 3; phase_timer = 0; }
        break;
    case 3:
        if (phase_timer >= 90) { phase = 4; phase_timer = 0; }
        break;
    case 4:
        window_flicker = (phase_timer <= 3);
        if (phase_timer >= 6) { phase = 5; phase_timer = 0; }
        break;
    case 5:
        if (phase_timer >= 60) {
            fade_alpha = min((phase_timer - 60) / 80.0, 1.0);
        }
        if (phase_timer >= 200) { phase = 6; phase_timer = 0; }
        break;
    case 6:
        if (phase_timer >= 120) {
            audio_stop_all();
            global.game_state = 0;
            room_goto(Room0);
        }
        break;
}
