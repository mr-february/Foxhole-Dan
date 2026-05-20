// Dead?
if (hp <= 0) {
    var _ctrl = instance_find(obj_controller5, 0);
    if (_ctrl != noone) _ctrl.currency += reward;
    instance_destroy();
    exit;
}

var _house = instance_find(obj_td_house, 0);
if (_house == noone) exit;

// Reset slow modifier, then check barricades
spd_mod = 1.0;
var _nt = instance_number(obj_td_tower);
for (var _i = 0; _i < _nt; _i++) {
    var _t = instance_find(obj_td_tower, _i);
    if (_t != noone && _t.tower_type == 2) {
        if (point_distance(x, y, _t.x, _t.y) < 52) {
            spd_mod = 0.5;
            break;
        }
    }
}

var _dir  = point_direction(x, y, _house.x, _house.y);
var _move = spd * spd_mod;
x += lengthdir_x(_move, _dir);
y += lengthdir_y(_move, _dir);

// Reached house?
if (point_distance(x, y, _house.x, _house.y) < 56) {
    _house.hp = max(_house.hp - damage, 0);
    instance_destroy();
}
