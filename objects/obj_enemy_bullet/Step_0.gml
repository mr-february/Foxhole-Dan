x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (place_meeting(x, y, obj_platform)) {
    instance_destroy();
    exit;
}

var p = instance_place(x, y, obj_dan);
if (p != noone && p.i_frames == 0) {
    p.hp         -= 10;
    p.ptsd_meter  = min(p.ptsd_meter + 18, p.ptsd_max);
    p.i_frames    = 40;
    instance_destroy();
}
