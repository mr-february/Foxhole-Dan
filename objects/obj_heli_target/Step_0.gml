// === Per-type setup (first frame, after controller sets target_type) ===
if (!setup_done) {
    setup_done = true;
    switch (target_type) {
        case 0: hp = 24; score_value = 100; dmg = 6;  break;   // troop
        case 1: hp = 60; score_value = 200; dmg = 10; break;   // technical
        case 2: hp = 40; score_value = 250; dmg = 16; break;   // RPG team (hits hard)
        case 3: hp = 70; score_value = 300; dmg = 12; break;   // enemy chopper
    }
    max_hp = hp;
}

bob += 0.1;
life--;
x += drift_x;
y += drift_y + ((target_type == 3) ? sin(bob) * 1.2 : 0);   // choppers weave

// === FIRE at the player's chopper ===
// A muzzle flash marks the shooter and a visible tracer arcs to the cabin —
// damage lands when the tracer arrives (obj_heli_tracer), not invisibly here,
// so the player can always see who's shooting and where the hit came from.
if (instance_exists(obj_dan_chopper)) {
    var c = instance_find(obj_dan_chopper, 0);
    fire_timer--;
    if (fire_timer <= 0) {
        fire_timer = fire_cd;
        muzzle_flash = 6;
        var _mx = x, _my = y - 22;
        var _t = instance_create_layer(_mx, _my, "Instances", obj_heli_tracer);
        _t.target_x   = c.x - 20;
        _t.target_y   = c.y + 10;
        _t.direction  = point_direction(_mx, _my, _t.target_x, _t.target_y);
        _t.speed      = 30;
        _t.dmg        = dmg;
        _t.tracer_col = (target_type == 2) ? make_color_rgb(255, 150, 40) : make_color_rgb(120, 255, 140);
        audio_play_sound(snd_gunshot, 5, false);
    }
}

if (muzzle_flash > 0) muzzle_flash--;
if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;

// Despawn when it drifts off the left or times out.
if (x < -80 || life <= 0) instance_destroy();
