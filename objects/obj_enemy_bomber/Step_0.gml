// Fly horizontally
x += move_spd * facing;

// Bounce off room bounds
if (x < 300)        { facing =  1; x = 300; }
if (x > room_width - 300) { facing = -1; x = room_width - 300; }

// Gentle altitude bob
y = altitude + sin(current_time * 0.0018) * 10;

// Drop bombs when player is roughly below
var p = instance_find(obj_dan, 0);
if (p == noone) p = instance_find(obj_dan_vehicle, 0);
if (p != noone) {
    bomb_timer--;
    if (bomb_timer <= 0) {
        var bom = instance_create_layer(x, y + 14, "Instances", obj_bomb);
        bom.drop_spd = 1.5 + random(1.0);
        bomb_timer = 140 + irandom(100);
    }
}

// Hit flash
if (hit_flash > 0) hit_flash--;

// Death
if (hp <= 0) {
    global.shake_mag   = max(global.shake_mag, 6.0);
    global.flash_timer = max(global.flash_timer, 14);
    repeat (4) {
        var d = instance_create_layer(x + irandom_range(-20, 20), y + irandom_range(-10, 10),
                                      "Instances", obj_damage_number);
        d.amount = 0;
    }
    instance_destroy();
}
