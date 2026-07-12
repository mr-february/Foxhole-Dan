var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                Easy  Normal  Hard  Brutal
var _hp_tab   = [45,   60,     80,   100];
var _cd_tab   = [150,  130,    110,  90 ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 200;

move_spd    = 0.8;
vspd        = 0;
hspd        = 0;
shoot_range = 720;
shoot_cd    = _cd_tab[_d];
shoot_timer = shoot_cd + irandom(60);
aim_frames  = 32;       // laser telegraph duration
aim_timer   = 0;
aiming      = false;
repos_dir   = 0;        // occasional small reposition
repos_len   = 0;
repos_timer = 120 + irandom(180);

// PTSD civilian flicker (mirrors obj_enemy_soldier)
is_civilian_flicker = true;
flicker_timer = 0;                          // frames remaining in current flicker
flicker_cd    = irandom_range(600, 1500);   // cooldown before next flicker
