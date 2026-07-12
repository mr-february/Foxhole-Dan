// Dead?
if (hp <= 0) {
    var _ctrl = instance_find(obj_controller5, 0);
    if (_ctrl != noone) _ctrl.currency += reward;
    global.score += (enemy_type == 1) ? 150 : 100;
    global.kill_flash_timer = 5;
    repeat (irandom_range(5, 8)) {
        instance_create_layer(x, y, "Instances", obj_blood_particle);
    }
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

// Separation — push away from nearby enemies so they don't single-file
var _sep_x = 0;
var _sep_y = 0;
var _sep_r = 30;
var _ne    = instance_number(obj_td_enemy);
for (var _si = 0; _si < _ne; _si++) {
    var _other = instance_find(obj_td_enemy, _si);
    if (_other == id) continue;
    var _dist = point_distance(x, y, _other.x, _other.y);
    if (_dist > 0 && _dist < _sep_r) {
        var _strength = (_sep_r - _dist) / _sep_r;
        var _away     = point_direction(_other.x, _other.y, x, y);
        _sep_x += lengthdir_x(_strength, _away);
        _sep_y += lengthdir_y(_strength, _away);
    }
}

x += lengthdir_x(_move, _dir) + _sep_x * 0.45;
y += lengthdir_y(_move, _dir) + _sep_y * 0.45;

// Reached house?
if (point_distance(x, y, _house.x, _house.y) < 56) {
    _house.hp = max(_house.hp - damage, 0);
    instance_destroy();
}
