audio_stop_all();
global.music_inst = audio_play_sound(snd_music_title, 100, true);
state        = 0;   // 0=main menu  1=controls  2=difficulty select  3=settings
depth        = -9999;
visible      = true;
settings_sel = 0;   // 0=music  1=sfx

global.difficulty = 1;  // default Normal
diff_sel          = 1;  // cursor in difficulty select screen
level_sel         = 0;  // cursor in dev level-select screen (state 6)

// Dev-only level select — jump straight into any room without playing through
// everything before it. Gated behind DEBUG_LEVEL_SELECT; flip that macro off
// before building for the public Vercel push.
level_list = [
    { room: Room1,  name: "1  —  THE BUNKER" },
    { room: Room7,  name: "2  —  COLD SWEAT" },
    { room: Room2,  name: "3  —  THE RIVER" },
    { room: Room8,  name: "4  —  OVERWATCH" },
    { room: Room3,  name: "5  —  THE TOWER" },
    { room: Room9,  name: "6  —  DUST-OFF" },
    { room: Room10, name: "7  —  DOWNRIVER" },
    { room: Room11, name: "8  —  THE FACILITY" },
    { room: Room12, name: "9  —  INTERROGATION" },
    { room: Room4,  name: "10  —  THE CHAIR" },
    { room: Room13, name: "11  —  THE MOUNTAIN" },
    { room: Room5,  name: "12  —  SIEGE" },
    { room: Room6,  name: "13  —  HOME" },
    { room: Room14, name: "14  —  ENDLESS" },
];

global.high_score = 0;
endless_unlocked  = 0;
endless_best      = 0;
if (os_browser == browser_not_a_browser) {
    ini_open("foxhole_dan.ini");
    global.high_score = ini_read_real("saves", "high_score", 0);
    endless_unlocked  = ini_read_real("saves", "endless_unlocked", 0);
    endless_best      = ini_read_real("saves", "endless_best_score", 0);
    ini_close();
}

lb_scores      = [];
lb_error       = false;
lb_request_id  = -1;
lb_name        = "";
lb_needs_fetch = false;

// If returning from a completed run, enter name-entry state immediately
if (global.pending_score > 0) {
    state           = 5;
    keyboard_string = "";
    lb_name         = "";
}
