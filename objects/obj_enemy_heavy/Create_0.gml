var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab     = [200,  280,    360,  460];
var _cd_tab     = [110,  95,     80,   65 ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 300;

move_spd     = 1.2;
vspd         = 0;
hspd         = 0;
shoot_cd     = _cd_tab[_d];
shoot_timer  = shoot_cd + irandom(40);
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
aggro_range  = 420;
shoot_range  = 340;
