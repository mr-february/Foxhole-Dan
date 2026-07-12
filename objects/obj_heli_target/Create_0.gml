// === obj_heli_target — ground threat in the on-rails chopper run ===
// target_type: 0 troop, 1 technical, 2 RPG team, 3 enemy chopper. Set by the controller after create.
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);
target_type = 0;

hp          = 30;
max_hp      = 30;
hit_flash   = 0;
i_frames    = 0;
facing      = -1;
score_value = 100;

drift_x   = -1.4;              // world scrolls right-to-left past the chopper
drift_y   = 0;
fire_cd   = [90, 74, 60, 48][_d];
fire_timer = fire_cd + irandom(60);
dmg       = 8;
bob       = random(6.28);
life      = 900;              // failsafe despawn
setup_done = false;          // per-type stats applied on first Step (after controller sets target_type)
