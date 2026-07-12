// === GUST CYCLE ===
cycle = (cycle + 1) mod gust_period;
if (cycle == 0) wind_dir = choose(-1, 1);   // new gust, new direction

gusting = (cycle < gust_len);

// Force envelope — ramp in over 25 frames, out over the last 25
if (gusting) {
    var _in  = clamp(cycle / 25, 0, 1);
    var _out = clamp((gust_len - cycle) / 25, 0, 1);
    gust_pct = min(_in, _out);
} else {
    gust_pct = 0;
}

// === PUSH DAN while he's inside the rect ===
if (gusting && global.game_state == 0) {
    var p = instance_find(obj_dan, 0);
    if (p != noone) {
        if (p.x > x && p.x < x + zone_w && p.y - 16 > y && p.y - 16 < y + zone_h) {
            // Gentle additive force — stronger in the air than on the ground
            var _f = strength * gust_pct * (p.on_ground ? 0.45 : 1.0);
            p.hspd = clamp(p.hspd + wind_dir * _f, -9, 9);
        }
    }
}
