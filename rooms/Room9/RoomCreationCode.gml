// === ROOM 9 — DUST-OFF (on-rails chopper gunner) ===
global.game_state = 0;

with (obj_controller)  { instance_destroy(); }
with (obj_controller2) { instance_destroy(); }
with (obj_controller3) { instance_destroy(); }
with (obj_cutscene)    { instance_destroy(); }
with (obj_cutscene2)   { instance_destroy(); }
with (obj_bg2)         { instance_destroy(); }
with (obj_bg3)         { instance_destroy(); }
with (obj_boss)        { instance_destroy(); }

// Door gunner cabin — fixed upper-left of the screen.
instance_create_layer(210, 200, "Instances", obj_dan_chopper);

// Controller (scroll + target spawner).
instance_create_layer(0, 0, "Instances", obj_controller9);
