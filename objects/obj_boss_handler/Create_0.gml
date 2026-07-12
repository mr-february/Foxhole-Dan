// === THE HANDLER — Harrington's proxy. Boss of THE FACILITY (Room11). ===
// NOT a par_enemy child: player projectiles special-case bosses, and obj_bullet
// has an explicit obj_boss_handler block (mirrors the obj_boss block).
// spr_boss is used purely as the collision mask; Draw_0 fully overrides visuals.

var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//                 Easy  Normal  Hard  Brutal
var _hp_tab   = [400,   600,    850,  1150];

hp           = _hp_tab[_d];
max_hp       = _hp_tab[_d];
phase        = 1;
move_spd     = 1.6;
vspd         = 0;
hspd         = 0;
facing       = -1;
shoot_timer  = 120;
charge_timer = 0;
i_frames     = 0;
patrol_left  = 4100;
patrol_right = 4440;
enrage_flash = 0;
hit_flash    = 0;
score_value  = 1500;   // base points before combo multiplier

// Summons — the Handler calls in MK-ECHO assets mid-fight
summon_timer = 240;    // frames until the first call
summon_max   = 4;      // never more than this many adds alive at once
