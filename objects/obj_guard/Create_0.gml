// === obj_guard — MK-ECHO sentry for the stealth level (Cold Sweat) ===
// A par_enemy child: killable by the player's gun (a "takedown"), scored via score_value.
var _d = clamp(variable_global_exists("difficulty") ? global.difficulty : 1, 0, 3);

//               Easy Normal Hard Brutal
var _hp_tab   = [60,  80,   100, 130];

hp          = _hp_tab[_d];
max_hp      = hp;
hit_flash   = 0;
i_frames    = 0;
facing      = choose(1, -1);
score_value = 150;

move_spd     = 1.6;
vspd         = 0;
hspd         = 0;

// Patrol
patrol_left  = x - 220;
patrol_right = x + 220;

// Vision
view_dist   = 380;                 // how far the guard can see
view_cone   = 46;                  // half-angle of the vision cone (degrees)
alert_state = 0;                   // 0 = calm, 1 = suspicious, 2 = spotted-you
sees_dan    = false;

// Shooting once alerted
shoot_cd    = [46, 38, 30, 24][_d];
shoot_timer = shoot_cd;

is_civilian_flicker = true;        // guilt bleed like the soldiers
flicker_timer = 0;
flicker_cd    = irandom_range(600, 1500);
