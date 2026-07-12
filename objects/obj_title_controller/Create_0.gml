audio_stop_all();
audio_play_sound(snd_music_title, 100, true);
state   = 0;   // 0=main menu  1=controls  2=difficulty select
depth   = -9999;
visible = true;

global.difficulty = 1;  // default Normal
diff_sel          = 1;  // cursor in difficulty select screen

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
