age++;
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (place_meeting(x, y, obj_platform)) {
    instance_destroy();
    exit;
}

var hit = instance_place(x, y, obj_enemy_soldier);
if (hit != noone) {
    hit.hp -= 25;
    hit.hit_flash = 10;
    var dmg = instance_create_layer(hit.x, hit.y - 28, "Instances", obj_damage_number);
    dmg.amount = 25;
    repeat (irandom_range(4, 8)) {
        instance_create_layer(x, y, "Instances", obj_blood_particle);
    }
    if (hit.hp <= 0) {
        global.shake_mag   = max(global.shake_mag, 8.0);
        global.flash_timer = max(global.flash_timer, 10);
        audio_play_sound(snd_enemy_die, 9, false);
        var _kx = hit.x;
        var _ky = hit.y;
        // Body parts fly off
        repeat (irandom_range(3, 5)) {
            instance_create_layer(_kx, _ky, "Instances", obj_gore_part);
        }
        // Blood spray (directional, not a ball)
        repeat (irandom_range(8, 14)) {
            instance_create_layer(_kx, _ky, "Instances", obj_blood_particle);
        }
        instance_create_layer(_kx, _ky, "Instances", obj_gore_decal);
        var c = instance_create_layer(_kx, _ky, "Instances", obj_corpse);
        c.facing = hit.facing;
        instance_destroy(hit);
    } else {
        global.shake_mag = max(global.shake_mag, 2.5);
        audio_play_sound(snd_bullet_impact, 8, false);
    }
    instance_destroy();
    exit;
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
        global.shake_mag   = max(global.shake_mag, 8.0);
        global.flash_timer = max(global.flash_timer, 14);
        audio_play_sound(snd_enemy_die, 9, false);
        repeat (irandom_range(3, 5)) {
            instance_create_layer(bomber.x, bomber.y, "Instances", obj_gore_part);
        }
        repeat (irandom_range(8, 14)) {
            instance_create_layer(bomber.x, bomber.y, "Instances", obj_blood_particle);
        }
        instance_create_layer(bomber.x, bomber.y, "Instances", obj_gore_decal);
        instance_destroy(bomber);
    } else {
        global.shake_mag = max(global.shake_mag, 2.5);
        audio_play_sound(snd_bullet_impact, 8, false);
    }
    instance_destroy();
}
