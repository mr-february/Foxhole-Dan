var i;

// === ROAD — full 8000px stretch of platforms ===
for (i = 0; i < 250; i++) {
    instance_create_layer(i * 32, 500, "Instances", obj_platform);
}

// === PLAYER VEHICLE ===
instance_create_layer(300, 468, "Instances", obj_dan_vehicle);

// === SANDBAG OBSTACLES ===
// Placed at road level (y=500 = platform top, obstacle origin is bottom-center)
var obs_x = [
    820, 960,           // early cluster — forces first jump
    1500, 1620,         // zone 2 pair
    2100,               // single mid-road
    2400, 2480,         // tight pair — gap just wide enough for jeep
    3000,               // zone 3 lone
    3500, 3580,
    4100, 4200, 4260,   // triple — need to weave/jump all three
    4800,
    5200, 5300,
    5700,
    6100, 6200,
    6600,
    7000, 7080,         // final approach before LZ
];
for (i = 0; i < array_length(obs_x); i++) {
    instance_create_layer(obs_x[i], 500, "Instances", obj_obstacle);
}

// === ENEMY VEHICLES ===
// Staggered through the level — each has its own patrol zone
var ev_x = [
    1200, 1800,         // zone 1
    2300, 2700,         // zone 2
    3200, 3600,         // zone 3
    4000, 4400, 4700,   // mid zone (3 vehicles — heat picks up)
    5100, 5500,
    5900, 6200,
    6500, 6800,         // final gauntlet
    7100,               // last defender before LZ
];
for (i = 0; i < array_length(ev_x); i++) {
    instance_create_layer(ev_x[i], 468, "Instances", obj_enemy_vehicle);
}

// === BACKGROUND + CONTROLLER ===
instance_create_layer(0, 0, "Instances", obj_bg2);
instance_create_layer(0, 0, "Instances", obj_controller2);
