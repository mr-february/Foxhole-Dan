// === LEVEL 8: THE FACILITY — the MK-ECHO lab (1983) ===
// Horizontal run-and-gun, Room1 architecture. Heaviest mix of the '80s roster.
var i;

// Clean state before anything else
global.game_state = 0;

// Destroy the persistent Room1 controller so it doesn't conflict with controller11
with (obj_controller)   { instance_destroy(); }

// Defensive cleanup — GM allows one extra Draw frame from the previous room.
// Destroy anything that might still be alive to prevent bleed-through.
with (obj_controller2)  { instance_destroy(); }
with (obj_controller3)  { instance_destroy(); }
with (obj_cutscene)     { instance_destroy(); }
with (obj_cutscene2)    { instance_destroy(); }
with (obj_dan_vehicle)  { instance_destroy(); }
with (obj_bg)           { instance_destroy(); }
with (obj_bg2)          { instance_destroy(); }
with (obj_bg3)          { instance_destroy(); }
with (obj_boss)         { instance_destroy(); }
with (obj_enemy_bomber) { instance_destroy(); }

// === GROUND FLOOR ===
// 140 tiles cover x=64 to x=64+140*32=4544
for (i = 0; i < 140; i++) {
    instance_create_layer(64 + i * 32, 500, "Instances", obj_platform);
}

// === ELEVATED PLATFORMS ===
// Zone 1 lab bench (y=420): x=400-560
var _z1 = [400, 432, 464, 496, 528];
for (i = 0; i < 5; i++) instance_create_layer(_z1[i], 420, "Instances", obj_platform);

// Zone 2 upper gantry (y=340): x=800-1024
var _z2 = [800, 832, 864, 896, 928, 960, 992];
for (i = 0; i < 7; i++) instance_create_layer(_z2[i], 340, "Instances", obj_platform);

// Zone 3 server ledge (y=420): x=1300-1460
var _z3 = [1300, 1332, 1364, 1396, 1428];
for (i = 0; i < 5; i++) instance_create_layer(_z3[i], 420, "Instances", obj_platform);

// Zone 4 observation deck (y=300): x=1800-1992
var _z4 = [1800, 1832, 1864, 1896, 1928, 1960];
for (i = 0; i < 6; i++) instance_create_layer(_z4[i], 300, "Instances", obj_platform);

// Zone 5 catwalk (y=340): x=2400-2624
var _z5 = [2400, 2432, 2464, 2496, 2528, 2560, 2592];
for (i = 0; i < 7; i++) instance_create_layer(_z5[i], 340, "Instances", obj_platform);

// Zone 6 test-cell ledge (y=420): x=3200-3360
var _z6 = [3200, 3232, 3264, 3296, 3328];
for (i = 0; i < 5; i++) instance_create_layer(_z6[i], 420, "Instances", obj_platform);

// Boss arena pillars (y=420): x=3800 and x=4480 (two raised platforms flanking the arena)
var _boss_ledge1 = [3800, 3832, 3864];
var _boss_ledge2 = [4480, 4512, 4544];
for (i = 0; i < 3; i++) {
    instance_create_layer(_boss_ledge1[i], 420, "Instances", obj_platform);
    instance_create_layer(_boss_ledge2[i], 420, "Instances", obj_platform);
}

// === DAN START ===
instance_create_layer(200, 468, "Instances", obj_dan);

// === ZONE 1: Lobby breach (x~600-900) ===
instance_create_layer(650,  468, "Instances", obj_enemy_soldier);
instance_create_layer(820,  468, "Instances", obj_enemy_dog);
// Medkit on the lab bench
instance_create_layer(464,  388, "Instances", obj_medkit);

// === ZONE 2: Gantry fight (x~900-1300) ===
instance_create_layer(950,  308, "Instances", obj_enemy_soldier);  // upper gantry
instance_create_layer(1100, 468, "Instances", obj_enemy_heavy);
instance_create_layer(1220, 468, "Instances", obj_enemy_soldier);
// Ammo box on the gantry
instance_create_layer(864,  308, "Instances", obj_ammo_box);

// === ZONE 3: Server hall (x~1300-1800) ===
instance_create_layer(1380, 388, "Instances", obj_enemy_sniper);   // ledge overwatch
instance_create_layer(1500, 468, "Instances", obj_enemy_soldier);
instance_create_layer(1580, 468, "Instances", obj_enemy_medic);    // keeps the hall alive
instance_create_layer(1680, 468, "Instances", obj_enemy_dog);
// Clarity before the choke point
instance_create_layer(1250, 468, "Instances", obj_clarity);

// === ZONE 4: Security choke (x~1800-2300) ===
instance_create_layer(1850, 268, "Instances", obj_enemy_soldier);  // observation deck
instance_create_layer(2050, 468, "Instances", obj_mg_nest);        // area denial
instance_create_layer(2160, 468, "Instances", obj_sapper);         // satchel rush
// Medkit after the choke
instance_create_layer(2280, 468, "Instances", obj_medkit);

// === ZONE 5: Catwalk gauntlet (x~2350-2950) ===
instance_create_layer(2500, 308, "Instances", obj_enemy_soldier);  // catwalk
instance_create_layer(2550, 468, "Instances", obj_enemy_elite);    // first operative
instance_create_layer(2720, 468, "Instances", obj_enemy_heavy);
instance_create_layer(2870, 468, "Instances", obj_sapper);
// Ammo resupply on the catwalk
instance_create_layer(2432, 308, "Instances", obj_ammo_box);

// === ZONE 6: Test cells (x~2950-3650) ===
instance_create_layer(3020, 468, "Instances", obj_ambusher);       // springs from a cell
instance_create_layer(3264, 388, "Instances", obj_enemy_rocket);   // ledge RPG
instance_create_layer(3400, 468, "Instances", obj_enemy_medic);
instance_create_layer(3480, 468, "Instances", obj_enemy_dog);
// Clarity + medkit between the cells
instance_create_layer(3120, 468, "Instances", obj_clarity);
instance_create_layer(3600, 468, "Instances", obj_medkit);

// === ZONE 7: Pre-boss push (x~3650-4050) ===
instance_create_layer(3720, 468, "Instances", obj_enemy_elite);
instance_create_layer(3820, 388, "Instances", obj_enemy_soldier);  // left pillar
instance_create_layer(3950, 468, "Instances", obj_mg_nest);
// Final resupply before the Handler
instance_create_layer(3680, 468, "Instances", obj_ammo_box);
instance_create_layer(4020, 468, "Instances", obj_clarity);

// === BOSS: THE HANDLER (x~4300) ===
instance_create_layer(4300, 468, "Instances", obj_boss_handler);

// === BACKGROUND ===
instance_create_layer(0, 0, "Instances", obj_bg);

// === CONTROLLER (must be created LAST) ===
instance_create_layer(0, 0, "Instances", obj_controller11);
