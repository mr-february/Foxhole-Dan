depth   = -9999;
visible = true;

bomb_frames_left = 180 * 60;  // 3 minutes at 60fps
timer_red        = false;

// phase: 0=ropes, 1=bomb, 2=win, 3=dead
phase = 0;

// Intro narrative (5 seconds before puzzle clock starts)
intro_timer = 300;

// === ROPE PUZZLE (phase 0) ===
rope_progress = [0.0, 0.0, 0.0];
rope_done     = [false, false, false];
active_strand = 0;          // UP/DOWN arrow to switch focus

// Strand 1: alternate LEFT/RIGHT — track which is expected next
strand1_expect = 1;         // 1=right first, -1=left first

// Strand 2: hold J+K (keyboard) or LB+RB (gamepad)
strand2_hold = 0;
strand2_need = 120;         // 2 seconds at 60fps

// === BOMB PUZZLE (phase 1) ===
bomb_step = 0;              // 0=wire, 1=code, 2=detonator

// Step 0: Wire — 0=RED 1=BLUE 2=GREEN 3=YELLOW 4=WHITE
wire_correct  = irandom(4);
wire_selected = 0;

// Step 1: Code
code_digits      = [irandom(9), irandom(9), irandom(9), irandom(9)];
code_show_timer  = 180;     // 3 seconds display window
code_hidden      = false;
code_input       = [-1, -1, -1, -1];
code_cursor      = 0;
code_wrong_flash = 0;

// Step 2: Detonator pull
detonator_hold = 0;
detonator_need = 180;       // 3 seconds

// End state
end_timer      = 0;
narrative_slide = 0;   // which reveal slide is showing (phase 2 only)
slide_fade_in   = 0;   // frames since slide started (for fade)
