var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.hp = min(p.hp + 40, p.max_hp);
    var _mems = [
        "He can still hear the mortar rounds.",
        "Left flank never made it out.",
        "The smell of smoke won't leave him.",
        "He can't remember their names anymore.",
        "His hands won't stop shaking.",
        "Some nights he still hears them screaming.",
        "The medic couldn't save everyone.",
        "He should have gone left."
    ];
    global.memory_text  = _mems[irandom(array_length(_mems) - 1)];
    global.memory_timer = 210;
    instance_destroy();
}
