var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab     = [40,   55,     70,   90];
var _dmg_tab    = [20,   26,     32,   40];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 175;

move_spd     = 3.5;
blast_dmg    = _dmg_tab[_d];
blast_radius = 75;
vspd         = 0;
hspd         = 0;
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
aggro_range  = 440;
trigger_range = 60;
winding      = false;   // armed — about to blow
wind_timer   = 30;      // frames from arming to detonation
