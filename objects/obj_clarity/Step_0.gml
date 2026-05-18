var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ptsd_meter = max(p.ptsd_meter - 50, 0);
    instance_destroy();
}
