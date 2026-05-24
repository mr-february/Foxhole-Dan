var i, j;

// Clean state before anything else
global.game_state = 0;
camera_set_view_pos(view_camera[0], 0, 2466);  // Dan.y(2888) - cam_h*0.55(422) = 2466

// Destroy the persistent Room1 controller so it doesn't conflict with controller3
with (obj_controller)  { instance_destroy(); }

// Defensive cleanup — GM allows one extra Draw frame from the previous room.
// Destroy any Room2 objects that might still be alive to prevent bleed-through.
with (obj_bg2)          { instance_destroy(); }
with (obj_controller2)  { instance_destroy(); }
with (obj_cutscene2)    { instance_destroy(); }
with (obj_dan_vehicle)  { instance_destroy(); }
with (obj_cutscene)     { instance_destroy(); }
with (obj_bg)           { instance_destroy(); }
with (obj_boss)         { instance_destroy(); }
with (obj_enemy_bomber) { instance_destroy(); }

// === PLATFORM LAYOUT ===
// Room is 1920x3000. Dan climbs from y=2920 (ground) up to y=200 (exit).
// Each row: [y, x_start, tile_count]. Platforms are 32px tiles.
// Layers spaced ~160px apart — just inside Dan's max jump height (~187px).
// Pattern zigzags left/right to force lateral movement on the climb.
var plat_data = [
    // Ground floor (full width)
    [2920,    0, 60],
    // L1 — two side ledges, gap in the middle forces a choice
    [2760,   64,  6],
    [2760, 1600,  6],
    // L2 — wide center (recovery platform)
    [2600,  768, 10],
    // L3 — sides again (enemy on right)
    [2440,  128,  7],
    [2440, 1536,  7],
    // L4 — center (enemy + medkit here)
    [2280,  672,  8],
    // L5 — sides
    [2120,   96,  6],
    [2120, 1440,  6],
    // L6 — three platforms (enemy on center) — widened from 4→6 tiles
    [1960,  256,  6],
    [1960,  768,  6],
    [1960, 1280,  6],
    // L7 — two platforms (ammo on left) — widened from 5→7 tiles
    [1800,  448,  7],
    [1800, 1088,  7],
    // L8 — three platforms (two enemies) — widened from 4→6 tiles
    [1640,   80,  6],
    [1640,  752,  6],
    [1640, 1408,  6],
    // L9 — wide safe zone (clarity + medkit)
    [1480,  608, 20],
    // L10 — three with gaps (two enemies on sides)
    [1320,  160,  5],
    [1320,  832,  4],
    [1320, 1440,  5],
    // L10–L11 bridge — stepping stones across the wide gaps
    [1240,  576,  4],
    [1240, 1184,  4],
    // L11 — two platforms (medkit on left)
    [1160,  448,  5],
    [1160, 1024,  5],
    // L11–L12 bridge
    [1080,  256,  4],
    [1080,  896,  4],
    [1080, 1408,  4],
    // L12 — three (enemy on center)
    [1000,  128,  5],
    [1000,  736,  5],
    [1000, 1344,  5],
    // L12–L13 bridge
    [ 920,  576,  4],
    [ 920, 1120,  4],
    // L13 — two wide (ammo on left)
    [ 840,  352,  7],
    [ 840, 1024,  7],
    // L13–L14 bridge
    [ 760,  192,  4],
    [ 760,  768,  4],
    [ 760, 1344,  4],
    // L14 — four platforms (two enemies) — widened from 4→5 tiles
    [ 680,   64,  5],
    [ 680,  448,  5],
    [ 680,  928,  5],
    [ 680, 1440,  5],
    // L15 — three (enemy on center)
    [ 520,  256,  5],
    [ 520,  800,  5],
    [ 520, 1216,  5],
    // L16 — two wide (clarity + ammo, breathing room before final push)
    [ 360,  384,  8],
    [ 360,  992,  8],
    // Exit platform — large, safe landing at the top
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

// === DAN — spawns 32px above ground so gravity settles him onto the floor ===
instance_create_layer(300, 2888, "Instances", obj_dan);

// === ENEMIES (y = platform_y - 32) ===
instance_create_layer(1568, 2408, "Instances", obj_enemy_soldier);  // L3 right ledge
instance_create_layer( 800, 2248, "Instances", obj_enemy_soldier);  // L4 center
instance_create_layer( 832, 1928, "Instances", obj_enemy_soldier);  // L6 center small
instance_create_layer(1472, 1608, "Instances", obj_enemy_soldier);  // L8 right narrow
instance_create_layer( 800, 1608, "Instances", obj_enemy_soldier);  // L8 center narrow
instance_create_layer( 192, 1288, "Instances", obj_enemy_soldier);  // L10 left
instance_create_layer(1472, 1288, "Instances", obj_enemy_soldier);  // L10 right
instance_create_layer( 768,  968, "Instances", obj_enemy_soldier);  // L12 center
instance_create_layer( 480,  648, "Instances", obj_enemy_soldier);  // L14 platform 2
instance_create_layer( 960,  648, "Instances", obj_enemy_soldier);  // L14 platform 3
instance_create_layer( 832,  488, "Instances", obj_enemy_soldier);  // L15 center

// === PICKUPS (y = platform_y - 32) ===
instance_create_layer( 640, 2248, "Instances", obj_medkit);    // L4 center — early health
instance_create_layer( 512, 1768, "Instances", obj_ammo_box);  // L7 left — mid resupply
instance_create_layer( 800, 1448, "Instances", obj_clarity);   // L9 wide — PTSD relief
instance_create_layer( 960, 1448, "Instances", obj_medkit);    // L9 wide — health top-up
instance_create_layer( 384,  808, "Instances", obj_ammo_box);  // L13 left — late resupply
instance_create_layer( 600,  328, "Instances", obj_clarity);   // L16 left — final calm
instance_create_layer(1024,  328, "Instances", obj_ammo_box);  // L16 right — final ammo

// === BACKGROUND ===
instance_create_layer(0, 0, "Instances", obj_bg3);

// === CONTROLLER ===
instance_create_layer(0, 0, "Instances", obj_controller3);
