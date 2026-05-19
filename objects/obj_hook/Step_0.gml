if (lodged) exit;

// Latch onto any platform the hook point enters
if (instance_position(x, y, obj_platform) != noone) {
    lodged = true;
    speed  = 0;
    if (owner != noone && instance_exists(owner)) {
        owner.rope_len = max(point_distance(owner.x, owner.y - 16, x, y), 48);
        // Upward impulse if Dan is below the anchor and falling — starts the swing
        if (owner.y - 16 > y && owner.vspd > 0) {
            owner.vspd = max(owner.vspd - 7, -6);
        }
    }
    exit;
}

// Self-destruct if out of range or out of room
if (x < 0 || x > room_width || y < 0 || y > room_height
    || point_distance(x, y, start_x, start_y) > max_dist) {
    if (owner != noone && instance_exists(owner)) owner.hook_inst = noone;
    instance_destroy();
}
