// === obj_street_enemy — advances across the street toward the sniper's nest ===
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);
var _hp_tab = [40, 55, 70, 90];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;                 // they move left toward the nest
score_value = 120;

move_spd    = [0.9, 1.2, 1.5, 1.9][_d];
cover_x     = 380;                // once past this x, they're in cover and suppress
suppress_cd = [70, 58, 46, 36][_d];
suppress_timer = suppress_cd;
in_cover    = false;
bob         = random(6.28);
