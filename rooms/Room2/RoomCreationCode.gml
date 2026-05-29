var i;

// === ROAD — 375 tiles at y=500 (12 000 px) ===
for (i = 0; i < 375; i++) {
    instance_create_layer(i * 32, 500, "Instances", obj_platform);
}

// === HILL SECTIONS (elevated platforms — 32 / 48 / 64 px above road) ===
// Hill 1 — gentle rise at x=2500, 32 px up (y=468)
for (i = 0; i < 10; i++) {
    instance_create_layer(2500 + i * 32, 468, "Instances", obj_platform);
}
// Hill 2 — mid rise at x=5300, 48 px up (y=452)
for (i = 0; i < 12; i++) {
    instance_create_layer(5300 + i * 32, 452, "Instances", obj_platform);
}
// Hill 3 — tall ridge at x=8600, 64 px up (y=436)
for (i = 0; i < 15; i++) {
    instance_create_layer(8600 + i * 32, 436, "Instances", obj_platform);
}

// === PLAYER VEHICLE ===
instance_create_layer(300, 468, "Instances", obj_dan_vehicle);

// === SANDBAG OBSTACLES (y=500 = road level) ===
var obs_x = [
    820, 960,              // early cluster — forces first dodge/jump
    1500, 1620,            // zone 2 pair
    2100,                  // single mid-road
    2400, 2480,            // tight pair before first hill
    3000,                  // zone 3 lone
    3500, 3580,
    4100, 4200, 4260,      // triple weave
    4800,
    5200, 5300,            // near hill 2
    5700,
    6100, 6200,
    6600,
    7000, 7080,            // end of original zone
    // === Extended section ===
    7400, 7500, 7580,      // zone 7 triple
    8000, 8080,            // zone 8 pair
    8400, 8480,            // hill 3 approach
    9000, 9080,            // post-ridge pair
    9500, 9580, 9660,      // zone 9 triple
    10200, 10280,          // zone 10 pair
    10700, 10780, 10860,   // zone 10 triple
    11300, 11380,          // final approach — last chance to stop
];
for (i = 0; i < array_length(obs_x); i++) {
    instance_create_layer(obs_x[i], 500, "Instances", obj_obstacle);
}

// === ENEMY VEHICLES ===
var ev_x = [
    1200, 1800,            // zone 1
    2300, 2700,            // zone 2 (flanks first hill)
    3200, 3600,            // zone 3
    4000, 4400, 4700,      // mid zone — heat picks up
    5100, 5500,
    5900, 6200,            // zone 5 (flanks second hill)
    6500, 6800,            // zone 6
    7100,                  // last of the original gauntlet
    // === Extended section ===
    7600, 8100,            // zone 7
    8800, 9200,            // zone 8 — flanks the big ridge
    9700, 10100,           // zone 9
    10600, 11000, 11200,   // final gauntlet — 3 in a row
];
for (i = 0; i < array_length(ev_x); i++) {
    instance_create_layer(ev_x[i], 468, "Instances", obj_enemy_vehicle);
}

// === AERIAL BOMBERS (drop bombs along the full road) ===
instance_create_layer(3000, 300, "Instances", obj_enemy_bomber);
instance_create_layer(8500, 260, "Instances", obj_enemy_bomber);

// === BACKGROUND + CONTROLLER ===
instance_create_layer(0, 0, "Instances", obj_bg2);
instance_create_layer(0, 0, "Instances", obj_controller2);
