var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab     = [60,   80,     100,  130];
var _cd_tab     = [70,   60,     50,   40 ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 200;

move_spd     = 2.2;
vspd         = 0;
hspd         = 0;
shoot_cd     = _cd_tab[_d];
shoot_timer  = 0;
patrol_dir   = choose(1, -1);
patrol_timer = irandom(90) + 60;
reveal_range = 260;   // player this close -> spring the ambush
aggro_range  = 420;
shoot_range  = 300;
state        = 0;     // 0 = hidden in cover, 1 = sprung
spring_timer = 0;     // pop-up animation frames after reveal
