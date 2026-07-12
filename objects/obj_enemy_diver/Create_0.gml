// === obj_enemy_diver — enemy frogman (Downriver), par_enemy child ===
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);
var _hp_tab = [40, 55, 70, 90];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 175;

move_spd    = [1.4, 1.8, 2.2, 2.6][_d];
bite_dmg    = [8, 11, 14, 18][_d];
bite_range  = 42;
bob         = random(6.28);
