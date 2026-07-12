var _d = variable_global_exists("difficulty") ? global.difficulty : 1;

//                  Easy  Normal  Hard  Brutal
var _hp_tab    = [220,   300,    380,   460];
var _spd_tab   = [1.6,   2.1,    2.6,   3.1];
var _shoot_tab = [60,    40,     28,    20 ];
var _shoot_rng = [100,   70,     50,    35 ];
var _gren_tab  = [260,   170,    120,   90 ];
var _gren_rng  = [340,   220,    160,   110];

hp           = _hp_tab[_d];
max_hp       = hp;
move_spd     = _spd_tab[_d];
vspd         = 0;
hspd         = 0;
facing       = -1;
shoot_timer  = irandom(_shoot_rng[_d]) + _shoot_tab[_d];
aggro_range  = 460;
shoot_range  = 340;
hit_flash    = 0;
score_value  = 300;
grenade_timer = irandom(_gren_rng[_d]) + _gren_tab[_d];
cover_timer   = 0;
enraged       = false;

alerted     = false;
alert_timer = 0;
burst_left  = 0;
burst_gap   = 0;

intro_played = false;
