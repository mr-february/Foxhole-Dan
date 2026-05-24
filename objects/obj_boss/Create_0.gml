var _d = variable_global_exists("difficulty") ? global.difficulty : 1;

//                     Easy  Normal  Hard  Brutal
var _hp_tab = [350,   500,    700,   950];

hp          = _hp_tab[_d];
max_hp      = _hp_tab[_d];
phase       = 1;
move_spd    = 1.5;
vspd        = 0;
hspd        = 0;
facing      = -1;
shoot_timer = 120;
charge_timer = 0;
i_frames    = 0;
patrol_left  = 3300;
patrol_right = 3800;
enrage_flash = 0;
hit_flash    = 0;
