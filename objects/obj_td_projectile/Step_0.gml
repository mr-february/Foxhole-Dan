if (!instance_exists(target)) { instance_destroy(); exit; }

var _dist = point_distance(x, y, target.x, target.y);
var _dir  = point_direction(x, y, target.x, target.y);
x += lengthdir_x(proj_spd, _dir);
y += lengthdir_y(proj_spd, _dir);

if (_dist <= proj_spd + 4) {
    if (is_aoe) {
        // Damage enemies in radius (iterate backwards — safe to destroy)
        var _ne = instance_number(obj_td_enemy);
        for (var _i = _ne - 1; _i >= 0; _i--) {
            var _e = instance_find(obj_td_enemy, _i);
            if (_e == noone) continue;
            if (point_distance(x, y, _e.x, _e.y) < aoe_rad) {
                _e.hp -= damage;
                if (_e.hp <= 0) {
                    var _ctrl = instance_find(obj_controller5, 0);
                    if (_ctrl != noone) _ctrl.currency += _e.reward;
                    with (_e) { instance_destroy(); }
                }
            }
        }
        if (instance_exists(obj_td_reyes)) {
            if (point_distance(x, y, obj_td_reyes.x, obj_td_reyes.y) < aoe_rad) {
                obj_td_reyes.hp -= damage;
            }
        }
    } else {
        if (instance_exists(target)) {
            target.hp -= damage;
            if (target.hp <= 0) {
                if (target.object_index == obj_td_enemy) {
                    var _ctrl2 = instance_find(obj_controller5, 0);
                    if (_ctrl2 != noone) _ctrl2.currency += target.reward;
                }
                with (target) { instance_destroy(); }
            }
        }
    }
    instance_destroy();
}
