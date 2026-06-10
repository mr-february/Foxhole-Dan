var i;

// === TERRAIN HEIGHTMAP (200 px spacing, 61 points, x = 0 to 12000) ===
// terrain_y[i] = ground surface y at world x = i * 200
// Lower value = higher ground (hill).  Base road ≈ 500.
global.terrain_y = [
    500, 499, 496, 490, 480, 466, 450, 439, 434, 438,  //  0– 9  x=0–1800
    448, 461, 475, 490, 502, 511, 517, 515, 506, 492,  // 10–19  x=2000–3800
    475, 458, 443, 433, 428, 430, 438, 452, 469, 488,  // 20–29  x=4000–5800
    505, 518, 527, 531, 528, 518, 503, 486, 468, 450,  // 30–39  x=6000–7800
    438, 436, 440, 448, 453, 453, 440, 419, 398, 388,  // 40–49  x=8000–9800
    393, 410, 432, 456, 476, 490, 497, 499, 499, 499,  // 50–59  x=10000–11800
    499                                                  // 60     x=12000
];

// Inline terrain height helper:
//   var _s = clamp(floor(px/200), 0, 59);
//   var _ty = lerp(global.terrain_y[_s], global.terrain_y[_s+1], (px - _s*200)/200.0);

// === PLAYER VEHICLE ===
var _vs = clamp(floor(300 / 200), 0, 59);
var _vty = lerp(global.terrain_y[_vs], global.terrain_y[_vs + 1], (300 - _vs * 200) / 200.0);
instance_create_layer(300, _vty - 15, "Instances", obj_dan_vehicle);

// === SANDBAG OBSTACLES ===
var obs_x = [
    820,  960,
    1500, 1620,
    2100,
    2400, 2480,
    3000,
    3500, 3580,
    4100, 4200, 4260,
    4800,
    5200, 5300,
    5700,
    6100, 6200,
    6600,
    7000, 7080,
    7400, 7500, 7580,
    8000, 8080,
    8400, 8480,
    9000, 9080,
    9500, 9580, 9660,
    10200, 10280,
    10700, 10780, 10860,
    11300, 11380,
];
for (i = 0; i < array_length(obs_x); i++) {
    var _px = obs_x[i];
    var _os = clamp(floor(_px / 200), 0, 59);
    var _oty = lerp(global.terrain_y[_os], global.terrain_y[_os + 1], (_px - _os * 200) / 200.0);
    instance_create_layer(_px, _oty, "Instances", obj_obstacle);
}

// === ENEMY VEHICLES ===
var ev_x = [
    1200, 1800,
    2300, 2700,
    3200, 3600,
    4000, 4400, 4700,
    5100, 5500,
    5900, 6200,
    6500, 6800,
    7100,
    7600, 8100,
    8800, 9200,
    9700, 10100,
    10600, 11000, 11200,
];
for (i = 0; i < array_length(ev_x); i++) {
    var _ex = ev_x[i];
    var _es = clamp(floor(_ex / 200), 0, 59);
    var _ety = lerp(global.terrain_y[_es], global.terrain_y[_es + 1], (_ex - _es * 200) / 200.0);
    instance_create_layer(_ex, _ety - 15, "Instances", obj_enemy_vehicle);
}

// === AERIAL BOMBERS ===
instance_create_layer(3000, 300, "Instances", obj_enemy_bomber);
instance_create_layer(8500, 260, "Instances", obj_enemy_bomber);

// === BACKGROUND + CONTROLLER ===
instance_create_layer(0, 0, "Instances", obj_bg2);
instance_create_layer(0, 0, "Instances", obj_controller2);
