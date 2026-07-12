var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab     = [130,  170,    220,  280];
var _cd_tab     = [90,   78,     66,   54 ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 350;

move_spd     = 2.8;
vspd         = 0;
hspd         = 0;
shoot_cd     = _cd_tab[_d];
shoot_timer  = shoot_cd;
fan_count    = (_d < 2) ? 3 : 5;   // bullets per fan burst
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
aggro_range  = 460;
shoot_range  = 360;
prev_hp      = hp;   // body armor — detect fresh hits to grant brief i_frames
