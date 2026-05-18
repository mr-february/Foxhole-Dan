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
    if (hit.hp <= 0) {
        var c = instance_create_layer(hit.x, hit.y, "Instances", obj_corpse);
        c.facing = hit.facing;
        instance_destroy(hit);
    }
    instance_destroy();
    exit;
}

var boss = instance_place(x, y, obj_boss);
if (boss != noone && boss.i_frames == 0) {
    boss.hp       -= 25;
    boss.i_frames  = 8;
    boss.hit_flash = 10;
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
    var fmg = instance_create_layer(bomber.x, bomber.y - 28, "Instances", obj_damage_number);
    fmg.amount = 25;
    if (bomber.hp <= 0) instance_destroy(bomber);
    instance_destroy();
}
