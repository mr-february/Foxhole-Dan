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
if (instance_exists(obj_dan_chopper)) {
    var c = instance_find(obj_dan_chopper, 0);
    fire_timer--;
    if (fire_timer <= 0) {
        fire_timer = fire_cd;
        if (c.i_frames == 0) {
            c.chopper_hp -= dmg;
            c.i_frames    = 14;
            global.shake_mag = max(global.shake_mag, 5.0);
            global.flash_timer = max(global.flash_timer, 8);
            audio_play_sound(snd_bullet_impact, 6, false);
        }
    }
}

if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;

// Despawn when it drifts off the left or times out.
if (x < -80 || life <= 0) instance_destroy();
