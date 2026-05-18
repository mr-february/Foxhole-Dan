x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

if (x > room_width + 100 || x < -100) { instance_destroy(); exit; }

if (place_meeting(x, y, obj_platform)) { instance_destroy(); exit; }

var hit = instance_place(x, y, obj_enemy_vehicle);
if (hit != noone && hit.i_frames == 0) {
    hit.hp       -= 25;
    hit.i_frames  = 6;
    hit.hit_flash = 10;
    var d    = instance_create_layer(hit.x, hit.y - 32, "Instances", obj_damage_number);
    d.amount = 25;
    if (hit.hp <= 0) instance_destroy(hit);
    instance_destroy();
}
