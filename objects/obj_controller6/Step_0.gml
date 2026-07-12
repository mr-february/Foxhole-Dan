phase_timer++;

switch (phase) {
    case 0:
        if (phase_timer >= 120) { phase = 1; phase_timer = 0; }
        break;
    case 1:
        if (!ach_fired) {
            try { steam_set_achievement("ach_ending"); } catch (_ex) {}
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
        // The distant gunfire surges for a heartbeat with the flash...
        if (phase_timer == 1) audio_sound_gain(distant_snd, 0.32, 0);
        if (phase_timer >= 6) {
            phase = 5;
            phase_timer = 0;
            // ...then drains away to almost nothing
            audio_sound_gain(distant_snd, 0.015, 2200);
        }
        break;
    case 5:
        if (phase_timer >= 60) {
            fade_alpha = min((phase_timer - 60) / 80.0, 1.0);
        }
        if (phase_timer == 100) audio_sound_gain(distant_snd, 0, 2500);
        if (phase_timer >= 200) { phase = 6; phase_timer = 0; }
        break;
    case 6:
        if (phase_timer >= 210) {
            audio_stop_all();
            global.pending_score   = global.score;
            global.pending_time    = global.run_time;
            global.pending_kills   = global.run_kills;
            global.pending_deaths  = global.total_deaths;
            global.pending_is_best = false;

            if (os_browser == browser_not_a_browser) {
                ini_open("foxhole_dan.ini");
                var _prev_best = ini_read_real("stats", "best_time", 0);
                global.pending_is_best = (_prev_best <= 0 || global.run_time < _prev_best);
                if (global.pending_is_best) ini_write_real("stats", "best_time", global.run_time);
                ini_write_real("stats", "total_wins", ini_read_real("stats", "total_wins", 0) + 1);
                ini_write_real("stats", "lifetime_kills", ini_read_real("stats", "lifetime_kills", 0) + global.run_kills);
                if (6 > ini_read_real("stats", "deepest_room", 0)) ini_write_real("stats", "deepest_room", 6);
                ini_close();
            }

            global.game_state    = 0;
            room_goto(Room0);
        }
        break;
}
