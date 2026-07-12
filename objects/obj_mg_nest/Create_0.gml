var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                Easy  Normal  Hard  Brutal
var _hp_tab   = [120,  160,    210,  270];
var _cd_tab   = [6,    5,      4,    3  ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 200;

move_spd     = 0;       // static emplacement — never moves horizontally
vspd         = 0;
hspd         = 0;
shoot_range  = 520;
fire_cd      = _cd_tab[_d];   // frames between rounds inside a burst
fire_timer   = 0;
burst_size   = 6;
burst_left   = 0;
burst_pause  = 50;            // frames between bursts
pause_timer  = irandom(50);
muzzle_flash = 0;
