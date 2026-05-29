engine_snd   = audio_play_sound(snd_engine, 10, true);
audio_sound_gain(engine_snd, 0.35, 0);
eng_pitch    = 1.0;
brake_snd_cd = 0;
shoot_flash  = 0;
move_spd     = 5;
vspd         = 0;
on_ground    = false;
grav         = 0.6;
jump_spd     = -13;
facing       = 1;

hp           = 100;
max_hp       = 100;
i_frames     = 0;

ammo         = 40;
max_ammo     = 40;
shoot_timer  = 0;
shoot_delay  = 14;
reload_timer = 0;

wheel_spin   = 0;
depth        = -100;
