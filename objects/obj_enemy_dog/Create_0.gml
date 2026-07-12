var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab     = [30,   40,     55,   70];
var _dmg_tab    = [10,   14,     18,   22];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 150;

move_spd     = 7;
bite_dmg     = _dmg_tab[_d];
vspd         = 0;
hspd         = 0;
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
aggro_range  = 460;
bite_range   = 40;
run_phase    = 0;    // drives the leg animation in Draw
