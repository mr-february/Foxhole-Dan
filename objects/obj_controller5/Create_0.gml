depth   = -9999;
visible = true;

// === INTRO ===
phase        = 0;    // 0=intro  1=play  2=reyes_warning  3=win  4=lose
intro_slide  = 0;
slide_timer  = 0;    // auto-advance after 240 frames (4 sec)
slide_fade   = 0;    // frames since slide started

// === WAVE SYSTEM ===
wave          = 0;   // 0-indexed; display as wave+1
wave_state    = 0;   // 0=countdown  1=spawning
wave_timer    = 300; // initial build phase (5 sec) before wave 1
enemies_left  = 0;   // enemies still to spawn this wave
spawn_timer   = 0;

// Per-wave definitions — counts scale with difficulty
var _d = variable_global_exists("difficulty") ? global.difficulty : 1;
var _wc_tab = [
    [3,  5,  8,  10, 12, 5 ],   // Easy
    [5,  8,  12, 14, 18, 8 ],   // Normal
    [7,  11, 16, 18, 24, 12],   // Hard
    [10, 15, 22, 26, 32, 18],   // Brutal
];
wave_counts    = _wc_tab[_d];
wave_intervals = [60, 50, 45, 40, 35, 30];   // frames between spawns
wave_types     = [0,  0,  0,  3,  3,  2 ];   // 0=basic 2=elite 3=mixed
wave_sides     = [3,  7,  15, 15, 15, 15];   // side bitmask 1=L 2=R 4=T 8=B

reyes_warning_active = false;
reyes_warning_timer  = 0;
reyes_spawned        = false;

// === CURRENCY ===
currency       = 150;
selected_tower = 0;    // 0=MG 1=Artillery 2=Barricade
tower_costs    = [80, 180, 40];
tower_names    = ["MG NEST", "ARTILLERY", "BARRICADE"];

// === END STATES ===
end_timer       = 0;
narrative_slide = 0;
slide_fade_in   = 0;
