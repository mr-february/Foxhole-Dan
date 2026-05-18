var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ammo = min(p.ammo + 20, p.max_ammo);
    instance_destroy();
}
