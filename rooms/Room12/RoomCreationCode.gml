// Clean state before anything else
global.game_state = 0;

// Destroy the persistent Room1 controller so it doesn't conflict with controller12
with (obj_controller) { instance_destroy(); }

// Defensive cleanup — GM allows one extra Draw frame from the previous room.
// Destroy anything that might still be alive to prevent bleed-through.
with (obj_bg)            { instance_destroy(); }
with (obj_bg2)           { instance_destroy(); }
with (obj_bg3)           { instance_destroy(); }
with (obj_bg5)           { instance_destroy(); }
with (obj_controller2)   { instance_destroy(); }
with (obj_controller3)   { instance_destroy(); }
with (obj_cutscene)      { instance_destroy(); }
with (obj_cutscene2)     { instance_destroy(); }
with (obj_dan)           { instance_destroy(); }
with (obj_dan_vehicle)   { instance_destroy(); }
with (obj_boss)          { instance_destroy(); }
with (obj_enemy_soldier) { instance_destroy(); }
with (obj_enemy_bomber)  { instance_destroy(); }
with (obj_platform)      { instance_destroy(); }

// === CONTROLLER === (the interrogation minigame draws everything itself)
instance_create_layer(0, 0, "Instances", obj_controller12);
