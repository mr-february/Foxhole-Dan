var i;

// Advance marching soldiers
for (i = 0; i < 32; i++) {
    march_x[i] += march_spd[i];
    if (march_x[i] > 1980) march_x[i] = -60;
}

// Advance tank column
for (i = 0; i < array_length(tank_x); i++) {
    tank_x[i] += tank_spd[i];
    if (tank_x[i] > 2080) tank_x[i] = -130;
}

// Descend parachute illumination flares
for (i = 0; i < array_length(flare_x); i++) {
    flare_y[i] += 0.25;
    if (flare_y[i] > 480) {
        flare_x[i] = 120 + irandom(1680);
        flare_y[i] = -irandom(180);
    }
}

// Artillery flash (more frequent than before — this is the climactic final level)
if (flash_timer <= 0) {
    if (irandom(40) == 0) {
        flash_timer = irandom_range(6, 18);
        flash_x     = irandom_range(80, 1840);
        flash_y     = irandom_range(350, 440);
        flash_size  = irandom_range(55, 145);
    }
} else {
    flash_timer--;
}

// Tracer rounds — spawn from right (enemy direction), fly left
for (i = 0; i < array_length(tracer_x); i++) {
    if (tracer_active[i]) {
        tracer_x[i] -= 20 + (i mod 3) * 7;
        if (tracer_x[i] < -120) tracer_active[i] = false;
    } else {
        if (irandom(35) == 0) {
            tracer_x[i]      = 1980 + irandom(220);
            tracer_y[i]      = 370 + irandom(140);
            tracer_active[i] = true;
        }
    }
}
