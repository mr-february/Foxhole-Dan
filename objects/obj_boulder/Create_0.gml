// === BOULDER — rolls and bounces down the mountain ===
// Collision mask is spr_platform (32x32, origin top-left); the drawn rock is
// centered on (x+16, y+16). Spawned by obj_controller13 above the camera.

vspd   = 2;
hspd   = choose(-1, 1) * random_range(1.2, 2.4);  // controller may override
grav   = 0.5;
rot    = irandom(359);   // visual roll angle
radius = 15;

rest_timer = 0;          // frames spent nearly motionless
life       = 1500;       // absolute safety cutoff

// Contact damage by difficulty:      Easy  Normal  Hard  Brutal
var _d   = variable_global_exists("difficulty") ? global.difficulty : 1;
var _tab = [25, 32, 40, 50];
dmg = _tab[clamp(_d, 0, 3)];

// Never spawn embedded in a ledge — nudge upward until clear
var _tries = 0;
while (place_meeting(x, y, obj_platform) && _tries < 24) {
    y -= 16;
    _tries++;
}
