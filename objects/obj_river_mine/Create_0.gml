// === obj_river_mine — moored naval mine (Downriver) ===
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);
moor_y = y;                       // tethered — sways around this point
sway   = random(6.28);
dmg    = [30, 38, 46, 56][_d];
trigger_range = 42;
