var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ptsd_meter        = max(p.ptsd_meter - 50, 0);
    global.clarity_timer = 1800;   // 30 seconds suppression
    global.total_clarity++;
    if (global.total_clarity >= 4) { try { steam_set_achievement("ach_clarity"); } catch (_ex) {} }
    global.pickup_flash_timer = 26;
    global.pickup_flash_col   = make_color_rgb(150, 205, 255);
    global.memory_text  = "breathe.  just breathe.";
    global.memory_timer = 160;
    instance_destroy();
}
