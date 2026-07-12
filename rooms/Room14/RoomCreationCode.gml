// === ROOM 14 — ENDLESS SURVIVAL (arena) ===
global.game_state = 0;

with (obj_controller)  { instance_destroy(); }
with (obj_controller2) { instance_destroy(); }
with (obj_controller3) { instance_destroy(); }
with (obj_cutscene)    { instance_destroy(); }
with (obj_cutscene2)   { instance_destroy(); }
with (obj_bg2)         { instance_destroy(); }
with (obj_bg3)         { instance_destroy(); }
with (obj_boss)        { instance_destroy(); }

// Arena floor (4800 wide).
for (var i = 0; i < 150; i++) instance_create_layer(i * 32, 620, "Instances", obj_platform);
// Cover platforms.
var cov = [[700, 500], [1400, 440], [2100, 520], [2800, 460], [3500, 500], [4100, 440]];
for (var j = 0; j < array_length(cov); j++) {
    for (var k = 0; k < 5; k++) instance_create_layer(cov[j][0] + k * 32, cov[j][1], "Instances", obj_platform);
}

// Player centered.
instance_create_layer(2400, 560, "Instances", obj_dan);
instance_create_layer(0, 0, "Instances", obj_bg);
instance_create_layer(0, 0, "Instances", obj_controller_endless);
