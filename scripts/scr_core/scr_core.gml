// === scr_core — shared run/combo/scoring helpers (Phase 0 foundation refactor) ===

/// Reset per-run stat + combo globals. Call wherever global.score is reset to 0.
/// Also the lazy safety net for any room entered directly (dev level-select,
/// the Endless-mode shortcut from the title screen) without ever running
/// obj_controller's Create_0 (Room1) first — shake_mag/hitstop_timer/flash_timer
/// are read through max() all over the combat code, which throws a hard GML
/// exception ("unable to convert undefined to a number") the instant anything
/// dies or explodes if these were never initialized.
function scr_init_run() {
    global.combo_count    = 0;
    global.combo_mult     = 1;
    global.combo_timer    = 0;
    global.run_kills      = 0;
    global.run_time       = 0;
    global.run_hits_taken = 0;
    if (!variable_global_exists("shake_mag"))     global.shake_mag     = 0;
    if (!variable_global_exists("hitstop_timer")) global.hitstop_timer = 0;
    if (!variable_global_exists("flash_timer"))   global.flash_timer   = 0;
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
    global.shake_mag     = max(global.shake_mag, 8.0);
    global.hitstop_timer = max(global.hitstop_timer, 5);
    global.flash_timer   = max(global.flash_timer, 10);
    // Pre-existing streak/Rage Mode system — kept alive alongside the new combo
    // multiplier so both HUD elements (COMBO and STREAK) and Rage Mode still work.
    global.streak++;
    global.streak_timer = 180;
    if (global.streak >= 5 && global.rage_timer <= 0) global.rage_timer = 360;
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

/// Headshot gore burst — a concentrated head-only explosion instead of a full-body
/// gore spray, leaving a headless corpse. Used for precision-aimed kills (obj_bullet
/// hitting the top band of an enemy's hitbox), always an instant kill.
function scr_spawn_headshot_gore(_x, _y, _facing) {
    // Bias heavily toward "head" chunks (part_type 0) instead of the normal random mix.
    repeat (irandom_range(6, 10)) {
        var _gp = instance_create_layer(_x, _y, "Instances", obj_gore_part);
        _gp.part_type = 0;
        _gp.pw = 6;
        _gp.ph = 8;
    }
    // Heavier, tighter blood spray than a body kill.
    repeat (irandom_range(18, 28)) {
        instance_create_layer(_x, _y, "Instances", obj_blood_particle);
    }
    instance_create_layer(_x, _y, "Instances", obj_gore_decal);
    var c = instance_create_layer(_x, _y, "Instances", obj_corpse);
    c.facing   = _facing;
    c.headless = true;
    audio_play_sound(choose(snd_enemy_die, snd_enemy_die2, snd_enemy_die3), 9, false);
}

/// Persist a stat to foxhole_dan.ini [saves] — only if it beats the stored value.
/// ini_open/ini_close crash on HTML5 (no filesystem) — no-op there.
function scr_save_stat(_key, _value) {
    if (os_browser != browser_not_a_browser) return;
    ini_open("foxhole_dan.ini");
    if (_value > ini_read_real("saves", _key, 0)) {
        ini_write_real("saves", _key, _value);
    }
    ini_close();
}
