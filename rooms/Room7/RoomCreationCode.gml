// === ROOM 7 — COLD SWEAT (stealth) ===
// 1983. Dan wakes in his apartment; MK-ECHO men have come. Slip past or fight.
global.game_state = 0;

// Kill the persistent Room1 controller + any stray objects from earlier rooms.
with (obj_controller)  { instance_destroy(); }
with (obj_controller2) { instance_destroy(); }
with (obj_controller3) { instance_destroy(); }
with (obj_cutscene)    { instance_destroy(); }
with (obj_cutscene2)   { instance_destroy(); }
with (obj_bg2)         { instance_destroy(); }
with (obj_bg3)         { instance_destroy(); }
with (obj_boss)        { instance_destroy(); }

// --- Ground floor (150 tiles across the 4800-wide corridor) ---
for (var i = 0; i < 150; i++) {
    instance_create_layer(i * 32, 560, "Instances", obj_platform);
}
// --- A few raised ledges / cover ---
var ledges = [[900, 460], [1500, 420], [2200, 470], [3000, 430], [3700, 460]];
for (var j = 0; j < array_length(ledges); j++) {
    for (var k = 0; k < 5; k++) {
        instance_create_layer(ledges[j][0] + k * 32, ledges[j][1], "Instances", obj_platform);
    }
}

// --- Shadow hiding zones ---
var sz;
sz = instance_create_layer(1150, 560, "Instances", obj_shadow_zone); sz.zw = 200; sz.zh = 210;
sz = instance_create_layer(2500, 560, "Instances", obj_shadow_zone); sz.zw = 240; sz.zh = 210;
sz = instance_create_layer(3400, 560, "Instances", obj_shadow_zone); sz.zw = 220; sz.zh = 210;

// --- Guards on patrol ---
instance_create_layer(1000, 552, "Instances", obj_guard);
instance_create_layer(1800, 552, "Instances", obj_guard);
instance_create_layer(2600, 552, "Instances", obj_guard);
instance_create_layer(3300, 552, "Instances", obj_guard);
instance_create_layer(4100, 552, "Instances", obj_guard);

// --- Pickups ---
instance_create_layer(1500, 400, "Instances", obj_clarity);
instance_create_layer(2900, 410, "Instances", obj_medkit);
instance_create_layer(3700, 440, "Instances", obj_ammo_box);

// --- Player + background + controller (LAST) ---
instance_create_layer(150, 520, "Instances", obj_dan);
instance_create_layer(0, 0, "Instances", obj_bg);
instance_create_layer(0, 0, "Instances", obj_controller7);
