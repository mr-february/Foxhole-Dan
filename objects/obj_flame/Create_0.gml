var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//              Easy  Normal  Hard  Brutal
var _dmg_tab = [6,    8,      10,   12];

dmg      = _dmg_tab[_d];   // per-tick burn (applied repeatedly, i_frames kept short)
life     = 26;
life_max = 26;

// Drift — the flamer overrides these at spawn to push the puff forward
hspd_drift = 0;
vspd_drift = random_range(-0.4, 0.1);
