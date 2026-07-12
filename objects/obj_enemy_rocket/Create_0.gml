var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                Easy  Normal  Hard  Brutal
var _hp_tab   = [80,   110,    140,  175];
var _cd_tab   = [150,  130,    115,  100];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 250;

move_spd     = 1.2;
vspd         = 0;
hspd         = 0;
aggro_range  = 560;
shoot_range  = 500;
hold_range   = 320;     // stops advancing here, plants and fires
shoot_cd     = _cd_tab[_d];
shoot_timer  = shoot_cd + irandom(40);
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
fire_anim    = 0;       // backblast flash frames after launching
