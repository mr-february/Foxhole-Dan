if (hp > 0) exit;
hp = 0;
var _ctrl = instance_find(obj_controller5, 0);
if (_ctrl != noone && _ctrl.phase == 1) {
    _ctrl.phase     = 4;  // lose
    _ctrl.end_timer = 0;
}
