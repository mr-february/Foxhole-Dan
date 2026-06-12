var p = instance_place(x, y, obj_dan);
if (p != noone) {
    p.ptsd_meter        = max(p.ptsd_meter - 50, 0);
    global.clarity_timer = 1800;   // 30 seconds suppression
    global.total_clarity++;
    if (global.total_clarity >= 4) { try { steam_set_achievement("ach_clarity"); } catch (_ex) {} }
    instance_destroy();
}
bob_offset = random(2 * pi);
