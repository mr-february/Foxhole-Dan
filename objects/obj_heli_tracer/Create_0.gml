// === obj_heli_tracer — visual-only tracer round fired at the player's chopper ===
// Damage lands here (on arrival), not instantly at the shooter — so every hit the
// chopper takes has a projectile the player can actually see and trace back to
// its source (obj_heli_target overrides these right after instance_create_layer).
depth = -50;

target_x = x;
target_y = y;
direction = 0;
speed     = 30;
dmg       = 8;
tracer_col = make_color_rgb(120, 255, 140);
life = 90;   // failsafe despawn if it somehow never reaches the target
