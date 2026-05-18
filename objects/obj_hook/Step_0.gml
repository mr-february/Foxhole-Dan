if (lodged) exit;

// Latch onto any platform the hook point enters
if (instance_position(x, y, obj_platform) != noone) {
    lodged = true;
    speed  = 0;
    exit;
}

// Self-destruct if out of range or out of room
if (x < 0 || x > room_width || y < 0 || y > room_height
    || point_distance(x, y, start_x, start_y) > max_dist) {
    if (owner != noone && instance_exists(owner)) owner.hook_inst = noone;
    instance_destroy();
}
