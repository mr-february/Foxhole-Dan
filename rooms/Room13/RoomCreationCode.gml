var i, j;

// Clean state before anything else
global.game_state = 0;
camera_set_view_pos(view_camera[0], 0, 2466);  // Dan.y(2888) - cam_h*0.55(422) = 2466

// Destroy the persistent Room1 controller so it doesn't conflict with controller13
with (obj_controller)  { instance_destroy(); }

// Defensive cleanup — GM allows one extra Draw frame from the previous room.
// Destroy anything that might still be alive to prevent bleed-through.
with (obj_controller2)  { instance_destroy(); }
with (obj_controller3)  { instance_destroy(); }
with (obj_controller4)  { instance_destroy(); }
with (obj_cutscene)     { instance_destroy(); }
with (obj_cutscene2)    { instance_destroy(); }
with (obj_dan_vehicle)  { instance_destroy(); }
with (obj_bg)           { instance_destroy(); }
with (obj_bg2)          { instance_destroy(); }
with (obj_bg3)          { instance_destroy(); }
with (obj_boss)         { instance_destroy(); }
with (obj_enemy_bomber) { instance_destroy(); }

// === THE MOUNTAIN — PLATFORM LAYOUT ===
// Room is 1920x3500. Dan climbs from y=2920 (base camp) up to y=200 (summit).
// Rows spaced ~160px apart — inside Dan's max jump height (~187px).
// This is a HAZARD level: no enemies. Boulders + avalanches + wind + crumbling ice.
// Each row: [y, x_start, tile_count]. Platforms are 32px tiles.
var plat_data = [
    // Base camp (full width)
    [2920,    0, 60],
    // L1 — two side ledges
    [2760,   64,  6],
    [2760, 1600,  6],
    // L2 — wide center (recovery)
    [2600,  768, 10],
    // L3 — sides
    [2440,  128,  7],
    [2440, 1536,  7],
    // L4 — center
    [2280,  672,  8],
    // L5 — sides
    [2120,   96,  6],
    [2120, 1440,  6],
    // L6 — three across (wind belt begins)
    [1960,  256,  6],
    [1960,  768,  6],
    [1960, 1280,  6],
    // L7 — two
    [1800,  448,  7],
    [1800, 1088,  7],
    // L8 — sides solid (center tile row is crumbling ice, see crumb_data)
    [1640,   80,  6],
    [1640, 1408,  6],
    // L9 — wide safe shelf (medkit + shelters)
    [1480,  608, 20],
    // L10 — sides solid, center crumbles
    [1320,  160,  5],
    [1320, 1440,  5],
    // L11 — two
    [1160,  448,  5],
    [1160, 1024,  5],
    // L11-L12 bridge — outer stones solid, center crumbles
    [1080,  256,  4],
    [1080, 1408,  4],
    // L12 — sides solid, center crumbles
    [1000,  128,  5],
    [1000, 1344,  5],
    // L12-L13 bridge — right stone solid, left crumbles
    [ 920, 1120,  4],
    // L13 — two wide (medkit)
    [ 840,  352,  7],
    [ 840, 1024,  7],
    // L13-L14 bridge — center solid, outers crumble
    [ 760,  768,  4],
    // L14 — four across (one crumbles)
    [ 680,   64,  5],
    [ 680,  928,  5],
    [ 680, 1440,  5],
    // L15 — center solid, sides crumble
    [ 520,  800,  5],
    // L16 — two wide, breathing room before the final pull
    [ 360,  384,  8],
    [ 360,  992,  8],
    // Summit — Dan's home plateau
    [ 200,  256, 44],
];

for (i = 0; i < array_length(plat_data); i++) {
    var py    = plat_data[i][0];
    var px    = plat_data[i][1];
    var count = plat_data[i][2];
    for (j = 0; j < count; j++) {
        instance_create_layer(px + j * 32, py, "Instances", obj_platform);
    }
}

// === CRUMBLING ICE LEDGES ===
// Same row grid, but these break ~40 frames after Dan stands on them.
var crumb_data = [
    [1640,  752,  6],   // L8 center
    [1320,  832,  4],   // L10 center
    [1240,  576,  4],   // L10-L11 stepping stones
    [1240, 1184,  4],
    [1080,  896,  4],   // L11-L12 bridge center
    [1000,  736,  5],   // L12 center
    [ 920,  576,  4],   // L12-L13 bridge left
    [ 760,  192,  4],   // L13-L14 bridge outers
    [ 760, 1344,  4],
    [ 680,  448,  5],   // L14 second-from-left
    [ 520,  256,  5],   // L15 sides
    [ 520, 1216,  5],
];

for (i = 0; i < array_length(crumb_data); i++) {
    var cy    = crumb_data[i][0];
    var cx    = crumb_data[i][1];
    var ccnt  = crumb_data[i][2];
    for (j = 0; j < ccnt; j++) {
        instance_create_layer(cx + j * 32, cy, "Instances", obj_crumbling_platform);
    }
}

// === ROCK OUTCROPS (avalanche shelters) ===
// Short shelves hung 96px above a ledge — duck under them when the snow comes.
// [shelf_y, x_start, tile_count]
var shelf_data = [
    [2504,  800,  3],   // over L2 left end
    [2184,  896,  3],   // over L4 right half
    [1864,  784,  2],   // over L6 center
    [1384,  640,  3],   // over L9 — twin shelters on the safe shelf
    [1384, 1120,  3],
    [1064,  480,  2],   // over L11 left
    [ 744, 1056,  3],   // over L13 right
    [ 424,  832,  2],   // over L15 center
];

for (i = 0; i < array_length(shelf_data); i++) {
    var sy    = shelf_data[i][0];
    var sx    = shelf_data[i][1];
    var scnt  = shelf_data[i][2];
    for (j = 0; j < scnt; j++) {
        instance_create_layer(sx + j * 32, sy, "Instances", obj_platform);
    }
}

// === WIND ZONES ===
// Periodic horizontal gusts inside these rects make jumps drift.
var wz;
wz        = instance_create_layer( 320, 1560, "Instances", obj_wind_zone);  // L6-L8 belt
wz.zone_w = 1280;
wz.zone_h = 480;
wz        = instance_create_layer(  96,  880, "Instances", obj_wind_zone);  // L10-L12 belt
wz.zone_w = 1500;
wz.zone_h = 440;
wz        = instance_create_layer( 256,  300, "Instances", obj_wind_zone);  // summit approach
wz.zone_w = 1200;
wz.zone_h = 420;

// === PICKUPS (y = platform_y - 32) ===
instance_create_layer( 700, 1448, "Instances", obj_medkit);   // L9 safe shelf
instance_create_layer( 416,  808, "Instances", obj_medkit);   // L13 left — before the final push

// === DAN — base camp ===
instance_create_layer(300, 2888, "Instances", obj_dan);

// === CONTROLLER (must be last) ===
instance_create_layer(0, 0, "Instances", obj_controller13);
