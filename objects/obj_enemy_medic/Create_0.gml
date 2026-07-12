var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                Easy  Normal  Hard  Brutal
var _hp_tab   = [55,   75,     95,   120];
var _heal_tab = [15,   20,     25,   30 ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 175;

move_spd     = 2.0;
vspd         = 0;
hspd         = 0;
heal_amt     = _heal_tab[_d];
heal_cd      = 120;     // frames between heal pulses
heal_timer   = heal_cd;
heal_radius  = 220;
heal_fx      = 0;       // frames of green pulse FX remaining
flee_range   = 200;     // runs when Dan gets this close
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;

// PTSD civilian flicker (mirrors obj_enemy_soldier)
is_civilian_flicker = true;
flicker_timer = 0;                          // frames remaining in current flicker
flicker_cd    = irandom_range(600, 1500);   // cooldown before next flicker
