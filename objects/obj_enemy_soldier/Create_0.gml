var _d = variable_global_exists("difficulty") ? global.difficulty : 1;

//                              Easy  Normal  Hard  Brutal
var _hp_tab         = [70,    100,    130,   160];
var _spd_tab        = [1.5,   2.0,    2.5,   3.0];
var _shoot_base_tab = [90,    60,     40,    30 ];
var _shoot_rng_tab  = [180,   120,    80,    50 ];
var _gren_base_tab  = [480,   240,    180,   120];
var _gren_rng_tab   = [600,   360,    240,   180];

hp           = _hp_tab[_d];
move_spd     = _spd_tab[_d];
vspd         = 0;
hspd         = 0;
facing       = -1;
shoot_timer  = irandom(_shoot_rng_tab[_d]) + _shoot_base_tab[_d];
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
aggro_range  = 380;
shoot_range  = 280;
hit_flash    = 0;
grenade_timer = irandom(_gren_rng_tab[_d]) + _gren_base_tab[_d];
cover_timer   = 0;
