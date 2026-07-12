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
                _e.hit_flash = 8;
            }
        }
        if (instance_exists(obj_td_reyes)) {
            if (point_distance(x, y, obj_td_reyes.x, obj_td_reyes.y) < aoe_rad) {
                obj_td_reyes.hp -= damage;
                obj_td_reyes.hit_flash = 10;
            }
        }
    } else {
        if (instance_exists(target)) {
            target.hp -= damage;
            target.hit_flash = (target.object_index == obj_td_reyes) ? 10 : 8;
        }
    }
    instance_destroy();
}
