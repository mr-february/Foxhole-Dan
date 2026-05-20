if (hp <= 0) {
    instance_destroy();
    exit;
}

var _house = instance_find(obj_td_house, 0);
if (_house == noone) exit;

var _dir = point_direction(x, y, _house.x, _house.y);

// Reyes bulldozes through barricades
var _nt = instance_number(obj_td_tower);
for (var _i = _nt - 1; _i >= 0; _i--) {
    var _t = instance_find(obj_td_tower, _i);
    if (_t != noone && _t.tower_type == 2) {
        if (point_distance(x, y, _t.x, _t.y) < 32) {
            with (_t) { instance_destroy(); }
        }
    }
}

x += lengthdir_x(spd, _dir);
y += lengthdir_y(spd, _dir);

// Reached house — deals heavy damage and retreats to bottom edge
if (point_distance(x, y, _house.x, _house.y) < 60) {
    _house.hp = max(_house.hp - 120, 0);
    // Retreat: snap to south edge so he has to march again
    x = 960 + random_range(-80, 80);
    y = 820;
}
