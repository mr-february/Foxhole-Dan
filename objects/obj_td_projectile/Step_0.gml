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
                    global.score += (_e.enemy_type == 1) ? 150 : 100;
                    global.kill_flash_timer = 5;
                    with (_e) { instance_destroy(); }
                } else {
                    _e.hit_flash = 8;
                }
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
            if (target.object_index == obj_td_reyes) target.hit_flash = 10;
            if (target.hp <= 0) {
                if (target.object_index == obj_td_enemy) {
                    var _ctrl2 = instance_find(obj_controller5, 0);
                    if (_ctrl2 != noone) _ctrl2.currency += target.reward;
                    global.score += (target.enemy_type == 1) ? 150 : 100;
                    global.kill_flash_timer = 5;
                }
                with (target) { instance_destroy(); }
            }
        }
    }
    instance_destroy();
}
