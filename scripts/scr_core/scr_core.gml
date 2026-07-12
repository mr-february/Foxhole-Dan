// === scr_core — shared run/combo/scoring helpers (Phase 0 foundation refactor) ===

/// Reset per-run stat + combo globals. Call wherever global.score is reset to 0.
function scr_init_run() {
    global.combo_count    = 0;
    global.combo_mult     = 1;
    global.combo_timer    = 0;
    global.run_kills      = 0;
    global.run_time       = 0;
    global.run_hits_taken = 0;
}

/// Tick the combo window down. Call once per frame from the active controller Step.
function scr_combo_tick() {
    if (global.combo_timer > 0) {
        global.combo_timer--;
        if (global.combo_timer <= 0) {
            global.combo_count = 0;
            global.combo_mult  = 1;
        }
    }
}

/// Single kill-scoring path. _base_score is the enemy's point value BEFORE the combo multiplier.
function scr_award_kill(_enemy, _base_score) {
    global.combo_count++;
    global.combo_mult  = clamp(1 + floor(global.combo_count / 4), 1, 8);
    global.combo_timer = 150;
    global.run_kills++;
    global.score += _base_score * global.combo_mult;
    global.kill_flash_timer = 5;
    global.shake_mag   = max(global.shake_mag, 8.0);
    global.flash_timer = max(global.flash_timer, 10);
    // NOTE: death SOUND lives in scr_spawn_gore (humanoid kills only), so
    // vehicles/boss keep their own explosion/cutscene audio instead.
}

/// Gore burst on kill — identical to the block obj_bullet used inline.
function scr_spawn_gore(_x, _y, _facing) {
    // Body parts fly off
    repeat (irandom_range(3, 5)) {
        instance_create_layer(_x, _y, "Instances", obj_gore_part);
    }
    // Blood spray (directional, not a ball)
    repeat (irandom_range(8, 14)) {
        instance_create_layer(_x, _y, "Instances", obj_blood_particle);
    }
    instance_create_layer(_x, _y, "Instances", obj_gore_decal);
    var c = instance_create_layer(_x, _y, "Instances", obj_corpse);
    c.facing = _facing;
    // Humanoid death sound belongs with the gore (vehicles/boss are handled elsewhere).
    audio_play_sound(choose(snd_enemy_die, snd_enemy_die2, snd_enemy_die3), 9, false);
}

/// Persist a stat to foxhole_dan.ini [saves] — only if it beats the stored value.
function scr_save_stat(_key, _value) {
    ini_open("foxhole_dan.ini");
    if (_value > ini_read_real("saves", _key, 0)) {
        ini_write_real("saves", _key, _value);
    }
    ini_close();
}
