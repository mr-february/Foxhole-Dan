var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                Easy  Normal  Hard  Brutal
var _hp_tab   = [70,   90,     115,  145];
var _cd_tab   = [7,    6,      5,    4  ];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 200;

move_spd       = 1.6;
vspd           = 0;
hspd           = 0;
aggro_range    = 420;
approach_range = 150;   // closes to this distance before planting
fire_range     = 190;   // emits flame while player is inside this
fire_cd        = _cd_tab[_d];   // frames between flame puffs
fire_timer     = 0;
patrol_dir     = choose(1, -1);
patrol_timer   = irandom(90) + 60;
firing         = false; // true while actively spraying (for draw)
