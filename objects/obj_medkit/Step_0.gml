var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.hp = min(p.hp + 40, p.max_hp);
    instance_destroy();
}
