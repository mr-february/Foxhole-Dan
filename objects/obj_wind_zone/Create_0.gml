// === WIND ZONE — periodic horizontal gusts inside a rect (x,y .. x+w,y+h) ===
// Room creation code sets zone_w / zone_h after creating the instance.

zone_w = 800;
zone_h = 400;

gust_period = 300;                    // full cycle length (frames)
gust_len    = 130;                    // gusting portion of the cycle
cycle       = irandom(gust_period-1); // desync zones from each other
wind_dir    = choose(-1, 1);

// Push strength per frame — fights Dan's air-control lerp without overpowering it
var _d   = variable_global_exists("difficulty") ? global.difficulty : 1;
var _tab = [0.20, 0.26, 0.32, 0.38];
strength = _tab[clamp(_d, 0, 3)];

gusting  = false;
gust_pct = 0;   // 0..1 ramp for drawing/force envelope
