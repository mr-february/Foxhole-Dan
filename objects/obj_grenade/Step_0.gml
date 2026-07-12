// Physics
x    += hvsp;
vvsp += 0.55;
y    += vvsp;

// Bounce off platforms
if (place_meeting(x, y + 1, obj_platform) && vvsp > 0) {
    vvsp *= -0.38;
    hvsp *= 0.68;
    if (abs(vvsp) < 1.2) { vvsp = 0; hvsp *= 0.5; }
}

// Despawn out of bounds
if (x < 0 || x > room_width) { instance_destroy(); exit; }

// Fuse countdown
fuse--;
if (fuse <= 0) {
    var _rad = 115;
    if (owner == 0) {
        // Enemy grenade — damages Dan
        var _p = instance_find(obj_dan, 0);
        if (_p != noone && point_distance(x, y, _p.x, _p.y) < _rad) {
            _p.hp         -= 30;
            _p.ptsd_meter  = min(_p.ptsd_meter + 30, _p.ptsd_max);
            _p.i_frames    = max(_p.i_frames, 45);
        }
    } else {
        // Player grenade — damages all enemy types
        // All damageable enemies via par_enemy (soldier, vehicle, and the new roster).
        // Boss is immune to grenade splash (handled only by direct fire).
        with (par_enemy) {
            if (object_index == obj_boss) continue;
            var _is_veh = (object_index == obj_enemy_vehicle);
            var _gr = _is_veh ? (_rad * 1.25) : _rad;
            if (point_distance(x, y, other.x, other.y) < _gr) {
                hp      -= 40;
                i_frames = max(i_frames, _is_veh ? 30 : 35);
                if (hp <= 0) {
                    scr_award_kill(id, score_value);
                    // Vehicles use their Destroy event for the explosion; humanoids get gore.
                    if (!_is_veh) scr_spawn_gore(x, y, facing);
                    instance_destroy();
                }
            }
        }
        // Friendly fire — light self-damage if Dan is very close
        var _self = instance_find(obj_dan, 0);
        if (_self == noone) _self = instance_find(obj_dan_vehicle, 0);
        if (_self != noone && point_distance(x, y, _self.x, _self.y) < 44) {
            _self.hp     -= 12;
            _self.i_frames = max(_self.i_frames, 22);
        }
    }
    global.shake_mag   = max(global.shake_mag, 8.0);
    global.flash_timer = max(global.flash_timer, 18);
    audio_play_sound(snd_explosion, 10, false);
    var _ex = instance_create_layer(x, y, "Instances", obj_explosion_fx);
    _ex.image_xscale = 1.5;
    _ex.image_yscale = 1.5;
    instance_destroy();
}
