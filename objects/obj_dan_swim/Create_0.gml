// === obj_dan_swim — underwater swim player (Downriver) ===
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

hp        = 100;
max_hp    = 100;
i_frames  = 0;

hspd = 0;
vspd = 0;
accel = 0.55;
drag  = 0.90;
swim_max = 5.0;

facing = 1;

surface_y = 120;                 // water surface — above this you can breathe
air       = 100;
air_max   = 100;
air_drain = [0.12, 0.16, 0.20, 0.26][_d];

fire_cd = 22;
fire_timer = 0;

bub = 0;

if (!variable_global_exists("combo_timer")) scr_init_run();
