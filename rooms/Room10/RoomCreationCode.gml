// === ROOM 10 — DOWNRIVER (swim/dive) ===
// Vietnam flashback. The boat sank; swim the submerged river to the far bank.
global.game_state = 0;

with (obj_controller)  { instance_destroy(); }
with (obj_controller2) { instance_destroy(); }
with (obj_controller3) { instance_destroy(); }
with (obj_cutscene)    { instance_destroy(); }
with (obj_cutscene2)   { instance_destroy(); }
with (obj_bg2)         { instance_destroy(); }
with (obj_bg3)         { instance_destroy(); }
with (obj_boss)        { instance_destroy(); }

// Player at the near bank.
instance_create_layer(150, 320, "Instances", obj_dan_swim);

// Hazards scattered down the river (room is 4800 wide, ~768 tall).
var mx = 700;
repeat (9) {
    instance_create_layer(mx + irandom_range(-60, 60), irandom_range(260, 640), "Instances", obj_river_mine);
    mx += 430;
}
var dx = 1000;
repeat (6) {
    instance_create_layer(dx, irandom_range(240, 600), "Instances", obj_enemy_diver);
    dx += 620;
}
var ax = 900;
repeat (7) {
    instance_create_layer(ax + irandom_range(-40, 40), irandom_range(300, 620), "Instances", obj_air_bubble);
    ax += 560;
}

instance_create_layer(0, 0, "Instances", obj_controller10);
