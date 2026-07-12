// === obj_dan_sniper — fixed rooftop sniper (Overwatch) ===
hp        = 100;
max_hp    = 100;
i_frames  = 0;

aim_x     = x + 200;
aim_y     = y;
scoped    = false;

fire_cd   = 18;      // frames between shots
fire_timer = 0;
ammo      = 10;
max_ammo  = 10;
reloading = 0;       // reload timer

nest_x = x;          // the parapet the guns rests on
nest_y = y;

// lazy global init for direct-entry dev
if (!variable_global_exists("combo_timer")) scr_init_run();
