// === GROUND FLOOR ===
// 140 tiles cover x=64 to x=64+140*32=4544
var i;
for (i = 0; i < 140; i++) {
    instance_create_layer(64 + i * 32, 500, "Instances", obj_platform);
}

// === ELEVATED PLATFORMS ===
// Zone 1 ledge (y=420): x=400-560
var _z1 = [400, 432, 464, 496, 528];
for (i = 0; i < 5; i++) instance_create_layer(_z1[i], 420, "Instances", obj_platform);

// Zone 2 upper (y=340): x=800-1024
var _z2 = [800, 832, 864, 896, 928, 960, 992];
for (i = 0; i < 7; i++) instance_create_layer(_z2[i], 340, "Instances", obj_platform);

// Zone 3 ledge (y=420): x=1300-1460
var _z3 = [1300, 1332, 1364, 1396, 1428];
for (i = 0; i < 5; i++) instance_create_layer(_z3[i], 420, "Instances", obj_platform);

// Zone 4 sniper perch (y=300): x=1800-1992
var _z4 = [1800, 1832, 1864, 1896, 1928, 1960];
for (i = 0; i < 6; i++) instance_create_layer(_z4[i], 300, "Instances", obj_platform);

// Boss arena pillars (y=420): x=2600 and x=3000 (two raised platforms)
var _boss_ledge1 = [2600, 2632, 2664];
var _boss_ledge2 = [3000, 3032, 3064];
for (i = 0; i < 3; i++) {
    instance_create_layer(_boss_ledge1[i], 420, "Instances", obj_platform);
    instance_create_layer(_boss_ledge2[i], 420, "Instances", obj_platform);
}

// === DAN START ===
instance_create_layer(200, 468, "Instances", obj_dan);

// === ZONE 1: First contact (x~600-900) ===
instance_create_layer(650,  468, "Instances", obj_enemy_soldier);
instance_create_layer(820,  468, "Instances", obj_enemy_soldier);
// Medkit pickup on ledge
instance_create_layer(464,  388, "Instances", obj_medkit);

// === ZONE 2: Elevated fight (x~900-1300) ===
instance_create_layer(950,  308, "Instances", obj_enemy_soldier);  // upper ledge
instance_create_layer(1100, 468, "Instances", obj_enemy_soldier);
instance_create_layer(1200, 468, "Instances", obj_enemy_soldier);
// Ammo box on upper platform
instance_create_layer(864,  308, "Instances", obj_ammo_box);

// === ZONE 3: Mid gauntlet (x~1300-1800) ===
instance_create_layer(1380, 388, "Instances", obj_enemy_soldier);  // ledge patrol
instance_create_layer(1500, 468, "Instances", obj_enemy_soldier);
instance_create_layer(1650, 468, "Instances", obj_enemy_soldier);
// Clarity (PTSD relief) before sniper section
instance_create_layer(1250, 468, "Instances", obj_clarity);

// === ZONE 4: Sniper nest (x~1800-2200) ===
instance_create_layer(1850, 268, "Instances", obj_enemy_soldier);  // perched high
instance_create_layer(2000, 468, "Instances", obj_enemy_soldier);
instance_create_layer(2100, 468, "Instances", obj_enemy_soldier);
// Medkit after gauntlet
instance_create_layer(2250, 468, "Instances", obj_medkit);

// === ZONE 5: Pre-boss push (x~2300-3200) ===
instance_create_layer(2400, 468, "Instances", obj_enemy_soldier);
instance_create_layer(2550, 468, "Instances", obj_enemy_soldier);
instance_create_layer(2650, 388, "Instances", obj_enemy_soldier);
instance_create_layer(2850, 468, "Instances", obj_enemy_soldier);
// Ammo resupply
instance_create_layer(2750, 468, "Instances", obj_ammo_box);
// Final clarity before boss
instance_create_layer(3100, 468, "Instances", obj_clarity);

// === BOSS (x~3500) ===
instance_create_layer(3550, 468, "Instances", obj_boss);

// === SKY BOMBERS ===
// Zone 2-3 patrol (high altitude)
var b1 = instance_create_layer(1100, 170, "Instances", obj_enemy_bomber);
b1.facing   = 1;
b1.bomb_timer = 220;
var b2 = instance_create_layer(2200, 150, "Instances", obj_enemy_bomber);
b2.facing   = -1;
b2.bomb_timer = 300;
// Pre-boss gauntlet bomber (lower, more aggressive)
var b3 = instance_create_layer(3000, 200, "Instances", obj_enemy_bomber);
b3.facing     = 1;
b3.move_spd   = 2.4;
b3.bomb_timer = 140;

// === BACKGROUND ===
instance_create_layer(0, 0, "Instances", obj_bg);

// === CONTROLLER ===
instance_create_layer(0, 0, "Instances", obj_controller);
