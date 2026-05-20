// ============================================================
// PHASE 0: INTRO SLIDES
// ============================================================
if (phase == 0) {
    slide_timer++;
    if (slide_timer >= 240 || keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return)
        || (gamepad_is_connected(0) && gamepad_button_check_pressed(0, gp_face1))) {
        slide_timer = 0;
        intro_slide++;
        if (intro_slide >= 5) {
            phase      = 1;
            wave_state = 0;   // countdown before wave 1
            wave_timer = 300; // 5-sec build phase
        }
    }
    exit;
}

// ============================================================
// PHASE 1: GAMEPLAY
// ============================================================
if (phase == 1) {

    // ---------- Tower selection (keys 1/2/3) ----------
    if (keyboard_check_pressed(ord("1"))) selected_tower = 0;
    if (keyboard_check_pressed(ord("2"))) selected_tower = 1;
    if (keyboard_check_pressed(ord("3"))) selected_tower = 2;

    // ---------- Place tower — left click ----------
    if (mouse_check_button_pressed(mb_left) && !reyes_warning_active) {
        var _mx = mouse_x;
        var _my = mouse_y;
        var _cost = tower_costs[selected_tower];
        var _too_close_house = (point_distance(_mx, _my, 960, 380) < 100);
        var _on_edge = (_mx < 40 || _mx > 1880 || _my < 40 || _my > 728);
        // Can't stack on an existing tower
        var _stacked = false;
        var _nt2 = instance_number(obj_td_tower);
        for (var _si = 0; _si < _nt2; _si++) {
            var _tt = instance_find(obj_td_tower, _si);
            if (point_distance(_mx, _my, _tt.x, _tt.y) < 36) { _stacked = true; break; }
        }
        if (currency >= _cost && !_too_close_house && !_on_edge && !_stacked) {
            var _new = instance_create_layer(_mx, _my, "Instances", obj_td_tower);
            _new.tower_type = selected_tower;
            currency -= _cost;
        }
    }

    // ---------- Sell tower — right click (half refund) ----------
    if (mouse_check_button_pressed(mb_right)) {
        var _mx2 = mouse_x;
        var _my2 = mouse_y;
        var _nt3 = instance_number(obj_td_tower);
        var _best     = noone;
        var _best_dist = 44.0;
        for (var _si2 = 0; _si2 < _nt3; _si2++) {
            var _tt2 = instance_find(obj_td_tower, _si2);
            var _d2  = point_distance(_mx2, _my2, _tt2.x, _tt2.y);
            if (_d2 < _best_dist) { _best_dist = _d2; _best = _tt2; }
        }
        if (_best != noone) {
            currency += _best.sell_value;
            with (_best) { instance_destroy(); }
        }
    }

    // ---------- Reyes arrival warning overlay ----------
    if (reyes_warning_active) {
        reyes_warning_timer++;
        if (reyes_warning_timer >= 300) {  // 5 seconds of warning
            reyes_warning_active = false;
            // Spawn Reyes from the south road
            var _r = instance_create_layer(960, 810, "Instances", obj_td_reyes);
            reyes_spawned = true;
            // 3 elite bodyguards from other sides
            var _be1 = instance_create_layer(-20,  random_range(220, 540), "Instances", obj_td_enemy);
            var _be2 = instance_create_layer(1940, random_range(220, 540), "Instances", obj_td_enemy);
            var _be3 = instance_create_layer(random_range(220, 1700), -20, "Instances", obj_td_enemy);
            for (var _bi = 0; _bi < 3; _bi++) {
                var _be = ((_bi == 0) ? _be1 : ((_bi == 1) ? _be2 : _be3));
                _be.enemy_type = 2;
                _be.hp = 100; _be.max_hp = 100; _be.spd = 1.2; _be.reward = 40; _be.damage = 50;
            }
        }
        exit;  // pause normal wave logic while warning plays
    }

    // ---------- Wave countdown between waves ----------
    if (wave_state == 0) {
        wave_timer--;
        if (wave_timer <= 0) {
            wave_state    = 1;
            enemies_left  = wave_counts[wave];
            spawn_timer   = 0;  // spawn first enemy immediately
        }
        exit;
    }

    // ---------- Active spawning ----------
    if (wave_state == 1) {
        if (enemies_left > 0) {
            spawn_timer--;
            if (spawn_timer <= 0) {
                // Pick spawn side from bitmask
                var _sides = wave_sides[wave];
                var _valid_sides = [];
                if (_sides & 1)  array_push(_valid_sides, 1);
                if (_sides & 2)  array_push(_valid_sides, 2);
                if (_sides & 4)  array_push(_valid_sides, 4);
                if (_sides & 8)  array_push(_valid_sides, 8);
                var _side = _valid_sides[irandom(array_length(_valid_sides) - 1)];

                var _ex = 0; var _ey = 0;
                switch (_side) {
                    case 1: _ex = -20;   _ey = random_range(220, 540); break;  // left
                    case 2: _ex = 1940;  _ey = random_range(220, 540); break;  // right
                    case 4: _ex = random_range(220, 1700); _ey = -20;  break;  // top
                    case 8: _ex = random_range(220, 1700); _ey = 810;  break;  // bottom
                }

                // Enemy type
                var _wtype = wave_types[wave];
                var _etype;
                if      (_wtype == 0) _etype = 0;
                else if (_wtype == 2) _etype = 2;
                else                  _etype = (irandom(3) == 0) ? 1 : 0;  // mixed: 25% heavy

                var _e = instance_create_layer(_ex, _ey, "Instances", obj_td_enemy);
                _e.enemy_type = _etype;
                switch (_etype) {
                    case 0: _e.hp = 50;  _e.max_hp = 50;  _e.spd = 0.90; _e.reward = 25; _e.damage = 35; break;
                    case 1: _e.hp = 150; _e.max_hp = 150; _e.spd = 0.45; _e.reward = 60; _e.damage = 70; break;
                    case 2: _e.hp = 100; _e.max_hp = 100; _e.spd = 1.20; _e.reward = 40; _e.damage = 50; break;
                }

                enemies_left--;
                spawn_timer = wave_intervals[wave];
            }
        }

        // Wave cleared when all spawned and none alive (and Reyes not active)
        var _alive = instance_number(obj_td_enemy)
                   + (instance_exists(obj_td_reyes) ? 1 : 0);
        if (enemies_left == 0 && _alive == 0) {
            if (reyes_spawned) {
                // Reyes dead — we win
                phase           = 3;
                end_timer       = 0;
                narrative_slide = 0;
                slide_fade_in   = 0;
            } else if (wave < 5) {
                // Normal wave complete — build phase
                wave++;
                wave_state = 0;
                wave_timer = 900;  // 15-sec build phase between waves
            } else {
                // Wave 6 complete — Reyes warning
                reyes_warning_active = true;
                reyes_warning_timer  = 0;
            }
        }
    }
}

// ============================================================
// PHASE 3: WIN NARRATIVE — SPACE to advance slides
// ============================================================
if (phase == 3) {
    end_timer++;
    slide_fade_in++;
    if (end_timer > 120 && narrative_slide < 8) {
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_return)
            || (gamepad_is_connected(0) && gamepad_button_check_pressed(0, gp_face1))) {
            narrative_slide++;
            slide_fade_in = 0;
        }
    }
    if (narrative_slide >= 8 && slide_fade_in >= 300) {
        global.game_state = 0;
        room_goto(Room0);  // credits done — back to title
    }
}

// ============================================================
// PHASE 4: LOSE
// ============================================================
if (phase == 4) {
    end_timer++;
    var _restart = keyboard_check_pressed(ord("R"))
                || (gamepad_is_connected(0) && (gamepad_button_check_pressed(0, gp_start)
                                             || gamepad_button_check_pressed(0, gp_face1)));
    if (end_timer > 120 && _restart) {
        global.game_state = 0;
        room_restart();
    }
}
