// Initialise stats based on tower_type (runs once after spawner sets tower_type)
if (!initialized) {
    initialized = true;
    var _sell_vals = [40, 90, 20];
    sell_value = _sell_vals[tower_type];
    switch (tower_type) {
        case 0:  // MG Nest
            range      = 200;
            fire_rate  = 18;
            damage     = 10;
            aoe_radius = 0;
            proj_spd   = 9;
            break;
        case 1:  // Artillery
            range      = 340;
            fire_rate  = 90;
            damage     = 55;
            aoe_radius = 70;
            proj_spd   = 6;
            break;
        case 2:  // Barricade — no attack logic needed
            break;
    }
}

if (tower_type == 2) exit;

if (fire_timer > 0) { fire_timer--; exit; }

// Find nearest enemy in range
var _target = noone;
var _min_d  = range + 1;
var _ne     = instance_number(obj_td_enemy);
for (var _i = 0; _i < _ne; _i++) {
    var _e = instance_find(obj_td_enemy, _i);
    var _d = point_distance(x, y, _e.x, _e.y);
    if (_d <= range && _d < _min_d) { _min_d = _d; _target = _e; }
}
// Reyes in range?
if (instance_exists(obj_td_reyes)) {
    var _rd = point_distance(x, y, obj_td_reyes.x, obj_td_reyes.y);
    if (_rd <= range && (_target == noone || _rd < _min_d)) {
        _target = obj_td_reyes.id;
    }
}

if (_target != noone) {
    aim_dir = point_direction(x, y, _target.x, _target.y);
    var _p = instance_create_layer(x, y, "Instances", obj_td_projectile);
    _p.target   = _target;
    _p.damage   = damage;
    _p.proj_spd = proj_spd;
    _p.is_aoe   = (tower_type == 1);
    _p.aoe_rad  = aoe_radius;
    fire_timer  = fire_rate;
}
