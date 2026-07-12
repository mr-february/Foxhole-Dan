var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ammo = min(p.ammo + 20, p.max_ammo);
    global.pickup_flash_timer = 16;
    global.pickup_flash_col   = make_color_rgb(255, 220, 90);
    instance_destroy();
}
