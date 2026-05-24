depth = 9999;

// Marching enemy columns
march_x   = array_create(32, 0);
march_row = array_create(32, 0);
march_spd = array_create(32, 0);
var i;
for (i = 0; i < 32; i++) {
    march_row[i] = i mod 3;
    march_spd[i] = 0.22 + march_row[i] * 0.14;
    march_x[i]   = i * 66 + irandom(40);
}

// Artillery flash
flash_timer = 0;
flash_x     = 0;
flash_y     = 0;
flash_size  = 0;

// Burning vehicle wrecks (fixed world positions)
burn_x = [280, 720, 1380, 1700];
burn_y = [455, 468, 460,  450 ];

// Enemy tank column (5 tanks advancing)
tank_x   = array_create(5, 0);
tank_spd = array_create(5, 0);
for (i = 0; i < 5; i++) {
    tank_x[i]   = irandom(1920);
    tank_spd[i] = 0.08 + (i mod 3) * 0.06;
}

// Parachute illumination flares (3 descending)
flare_x = array_create(3, 0);
flare_y = array_create(3, 0);
for (i = 0; i < 3; i++) {
    flare_x[i] = 200 + i * 640 + irandom(200);
    flare_y[i] = 40  + i * 80  + irandom(60);
}

// Incoming tracer rounds from enemy line
tracer_x      = array_create(8, 0);
tracer_y      = array_create(8, 0);
tracer_active = array_create(8, false);
