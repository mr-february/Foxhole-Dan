var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//              Easy  Normal  Hard  Brutal
var _dmg_tab = [22,   28,     34,   40];

spd = 9;                 // manual travel speed along `direction`
dmg = _dmg_tab[_d];      // AoE damage to Dan on detonation

alarm[0] = 300;          // lifetime failsafe
