// Primary explosion
instance_create_layer(x, y, "Instances", obj_explosion_fx);
// Offset secondary blast
instance_create_layer(x + irandom_range(-22, 22), y + irandom_range(-8, 8), "Instances", obj_explosion_fx);

// Debris shower
repeat (irandom_range(8, 13)) {
    instance_create_layer(x, y, "Instances", obj_vehicle_part);
}

// Screen impact
global.shake_mag   = max(global.shake_mag, 20.0);
global.flash_timer = max(global.flash_timer, 25);
audio_play_sound(snd_explosion, 10, false);
