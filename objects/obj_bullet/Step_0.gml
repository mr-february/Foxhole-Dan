age++;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (place_meeting(x, y, obj_platform)) {
    instance_destroy();
    exit;
}

// All masked humanoid enemies (soldier + the new roster, incl. sniper/heavy/captain)
// hit via the par_enemy parent. Boss/Handler are handled in their own blocks below
// (need i_frames tuning); the spriteless bomber is handled by the distance check
// further down.
var hit = instance_place(x, y, par_enemy);
if (hit != noone && hit.object_index != obj_boss) {
    var _hif = variable_instance_exists(hit, "i_frames") ? hit.i_frames : 0;
    if (_hif == 0) {
        hit.hp -= 25;
        hit.hit_flash = 10;
        var dmg = instance_create_layer(hit.x, hit.y - 28, "Instances", obj_damage_number);
        dmg.amount = 25;
        repeat (irandom_range(4, 8)) {
            instance_create_layer(x, y, "Instances", obj_blood_particle);
        }
        if (hit.hp <= 0) {
            var _sv = variable_instance_exists(hit, "score_value") ? hit.score_value : 100;
            var _fc = variable_instance_exists(hit, "facing") ? hit.facing : 1;
            scr_award_kill(hit, _sv);
            scr_spawn_gore(hit.x, hit.y, _fc);
            instance_destroy(hit);
        } else {
            global.shake_mag = max(global.shake_mag, 2.5);
            audio_play_sound(snd_bullet_impact, 8, false);
        }
        instance_destroy();
        exit;
    }
}

var boss = instance_place(x, y, obj_boss);
if (boss != noone && boss.i_frames == 0) {
    boss.hp       -= 25;
    boss.i_frames  = 8;
    boss.hit_flash = 10;
    global.shake_mag = max(global.shake_mag, 5.0);
    audio_play_sound(snd_bullet_impact, 8, false);
    var bdmg = instance_create_layer(boss.x, boss.y - 50, "Instances", obj_damage_number);
    bdmg.amount = 25;
    instance_destroy();
    exit;
}

// The Handler (Room11 boss) — not a par_enemy child, so it needs its own block
var handler = instance_place(x, y, obj_boss_handler);
if (handler != noone && handler.i_frames == 0) {
    handler.hp       -= 25;
    handler.i_frames  = 8;
    handler.hit_flash = 10;
    global.shake_mag = max(global.shake_mag, 5.0);
    audio_play_sound(snd_bullet_impact, 8, false);
    var hdmg = instance_create_layer(handler.x, handler.y - 50, "Instances", obj_damage_number);
    hdmg.amount = 25;
    instance_destroy();
    exit;
}

// Bomber — distance-based since it has no sprite mask
var bomber = noone;
with (obj_enemy_bomber) {
    if (point_distance(other.x, other.y, x, y) < 30) { bomber = id; break; }
}
if (bomber != noone) {
    bomber.hp -= 25;
    bomber.hit_flash = 10;
    repeat (irandom_range(4, 8)) {
        instance_create_layer(x, y, "Instances", obj_blood_particle);
    }
    var fmg = instance_create_layer(bomber.x, bomber.y - 28, "Instances", obj_damage_number);
    fmg.amount = 25;
    if (bomber.hp <= 0) {
        scr_award_kill(bomber, 150);
        global.flash_timer = max(global.flash_timer, 14);
        // Bomber uses inline gore (no scr_spawn_gore), so play its death sound here.
        audio_play_sound(choose(snd_enemy_die, snd_enemy_die2, snd_enemy_die3), 9, false);
        repeat (irandom_range(8, 14)) {
            instance_create_layer(bomber.x, bomber.y, "Instances", obj_gore_part);
        }
        repeat (irandom_range(24, 40)) {
            instance_create_layer(bomber.x, bomber.y, "Instances", obj_blood_particle);
        }
        instance_create_layer(bomber.x, bomber.y, "Instances", obj_gore_decal);
        instance_destroy(bomber);
    } else {
        global.shake_mag = max(global.shake_mag, 4.0);
        audio_play_sound(snd_bullet_impact, 8, false);
    }
    instance_destroy();
}
