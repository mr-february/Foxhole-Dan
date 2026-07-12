rise += 0.1;
if (instance_exists(obj_dan_swim)) {
    var p = instance_find(obj_dan_swim, 0);
    if (point_distance(x, y, p.x, p.y) < 34) {
        p.air = p.air_max;
        instance_destroy();
    }
}
