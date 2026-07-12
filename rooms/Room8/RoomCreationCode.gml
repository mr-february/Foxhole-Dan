// === ROOM 8 — OVERWATCH (sniper) ===
// 1983. Dan is pinned on a rooftop with a scoped rifle. Hold the street.
global.game_state = 0;

with (obj_controller)  { instance_destroy(); }
with (obj_controller2) { instance_destroy(); }
with (obj_controller3) { instance_destroy(); }
with (obj_cutscene)    { instance_destroy(); }
with (obj_cutscene2)   { instance_destroy(); }
with (obj_bg2)         { instance_destroy(); }
with (obj_bg3)         { instance_destroy(); }
with (obj_boss)        { instance_destroy(); }

// Sniper nest — bottom-left parapet.
instance_create_layer(120, 640, "Instances", obj_dan_sniper);

// Controller (spawns the waves).
instance_create_layer(0, 0, "Instances", obj_controller8);
