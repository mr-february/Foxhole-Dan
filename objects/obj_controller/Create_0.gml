global.game_state  = 0;  // 0=playing  1=win  2=dead
global.score       = 0;
global.shake_mag   = 0;
global.flash_timer = 0;
visible = true;

// Safety: if Room0 was skipped during dev, default to Normal
if (!variable_global_exists("difficulty")) global.difficulty = 1;
