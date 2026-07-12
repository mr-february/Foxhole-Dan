audio_stop_all();
// Very distant gunfire — ambiguous (TV? real?)
distant_snd = audio_play_sound(snd_gunshot, 10, true);
audio_sound_gain(distant_snd, 0.04, 0);
audio_sound_pitch(distant_snd, 0.5);

depth   = -9999;
visible = true;

// Phase sequence:
//  0 = scene visible, silence (120 frames)
//  1 = text1 fading in: "He made it home."  (frames 120-210)
//  2 = text1 holds                           (frames 210-330)
//  3 = text2 fading in: "He always makes it home." (frames 330-420)
//  4 = window flicker                        (frames 420-423)
//  5 = hold, then fade to black              (frames 423-563)
//  6 = black screen, then Room0              (frames 563-683)
phase       = 0;
phase_timer = 0;

// Overlay fade (0=transparent, 1=opaque black)
fade_alpha  = 0.0;

// Window flicker state
window_flicker = false;

// Achievement fires once when entering phase 1
ach_fired = false;

camera_set_view_pos(view_camera[0], 0, 0);

// Beating the story unlocks ENDLESS SURVIVAL on the title screen.
if (os_browser == browser_not_a_browser) {
    ini_open("foxhole_dan.ini");
    ini_write_real("saves", "endless_unlocked", 1);
    ini_close();
}
