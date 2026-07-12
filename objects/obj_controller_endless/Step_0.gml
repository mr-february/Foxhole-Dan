// === FX DECAY ===
if (global.shake_mag > 0.05) global.shake_mag *= 0.82; else global.shake_mag = 0;
if (global.flash_timer > 0)  global.flash_timer--;

scr_combo_tick();
if (banner_timer > 0) banner_timer--;

// ============================================================
// DEATH / SUBMIT FLOW
// ============================================================
if (global.game_state == 2) {
    if (submit_state == 0) {
        submit_state = 1;
        input_delay  = 20;
    }

    if (input_delay > 0) input_delay--;

    if (submit_state == 1 && input_delay <= 0) {
        var gp = gamepad_is_connected(0);
        // Move cursor
        if (keyboard_check_pressed(vk_left)  || (gp && gamepad_button_check_pressed(0, gp_padl))) init_pos = (init_pos + 2) mod 3;
        if (keyboard_check_pressed(vk_right) || (gp && gamepad_button_check_pressed(0, gp_padr))) init_pos = (init_pos + 1) mod 3;
        // Cycle letter (A-Z)
        var chg = 0;
        if (keyboard_check_pressed(vk_up)   || (gp && gamepad_button_check_pressed(0, gp_padu))) chg =  1;
        if (keyboard_check_pressed(vk_down) || (gp && gamepad_button_check_pressed(0, gp_padd))) chg = -1;
        if (chg != 0) {
            var c = ord(initials[init_pos]) - ord("A");
            c = (c + chg + 26) mod 26;
            initials[init_pos] = chr(ord("A") + c);
        }
        // Confirm
        var confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
        if (gp) confirm = confirm || gamepad_button_check_pressed(0, gp_face1);
        if (confirm) {
            var istr = initials[0] + initials[1] + initials[2];
            scr_save_stat("endless_best_score", global.score);
            scr_save_stat("endless_best_wave", wave);
            if (os_browser == browser_not_a_browser) {
                ini_open("foxhole_dan.ini");
                ini_write_string("saves", "last_initials", istr);
                ini_close();
            }
            // Online submit (offline-safe: fails soft to local scores if no board).
            scr_lb_submit("endless", istr, global.score, wave);
            run_submitted = true;
            submit_state  = 2;
        }
    }

    // Restart / return
    if (submit_state == 2) {
        if (keyboard_check_pressed(ord("R")) || (gamepad_is_connected(0) && gamepad_button_check_pressed(0, gp_face1))) {
            global.game_state = 0;
            room_restart();
        }
        if (keyboard_check_pressed(vk_escape) || (gamepad_is_connected(0) && gamepad_button_check_pressed(0, gp_face2))) {
            global.game_state = 0;
            room_goto(Room0);
        }
    }
    exit;
}

// ============================================================
// WAVE MACHINE
// ============================================================
global.run_time++;

if (phase == 0) {
    // Intermission
    inter_timer--;
    if (inter_timer <= 0) {
        wave++;
        // Enemies this wave: grows steadily.
        to_spawn = 3 + wave + floor(wave / 3);
        spawn_timer = 0;
        phase = 1;
        banner_timer = 120;
        // Small heal each new wave so long runs are possible.
        if (instance_exists(obj_dan)) {
            var p = instance_find(obj_dan, 0);
            p.hp = min(p.hp + 15, p.max_hp);
        }
    }
}
else if (phase == 1) {
    // Spawn the wave over time.
    if (to_spawn > 0) {
        spawn_timer--;
        if (spawn_timer <= 0) {
            spawn_timer = 22 + irandom(20);
            // Choose roster tier by wave.
            var pool;
            if (wave <= 3)      pool = roster_basic;
            else if (wave <= 8) pool = roster_mid;
            else                pool = roster_hard;
            // Every 5th wave leans elite/heavy.
            var otype;
            if (wave mod 5 == 0 && irandom(1) == 0) otype = choose(obj_enemy_elite, obj_enemy_heavy);
            else otype = pool[irandom(array_length(pool) - 1)];
            // Spawn at a ground edge relative to the player.
            var px = instance_exists(obj_dan) ? instance_find(obj_dan, 0).x : room_width / 2;
            var side = choose(-1, 1);
            var sx = clamp(px + side * (800 + irandom(400)), 64, room_width - 64);
            instance_create_layer(sx, 600, "Instances", otype);
            to_spawn--;
        }
    } else if (instance_number(par_enemy) == 0) {
        // Wave cleared — bonus + intermission.
        global.score += 500 * wave;
        banner_timer = 90;
        phase = 0;
        inter_timer = 150;
    }
}
