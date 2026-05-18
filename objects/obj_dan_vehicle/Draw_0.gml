// i-frame blink
if (i_frames > 0 && (current_time mod 8) < 4) exit;

// === DUST TRAIL (on ground) ===
if (on_ground) {
    for (var di = 0; di < 3; di++) {
        draw_set_alpha(0.10 + di * 0.06);
        draw_set_color(make_color_rgb(175, 148, 100));
        draw_circle(x - 36 - di * 16 + irandom(6), y + 6, 5 + di * 5, false);
    }
    draw_set_alpha(1);
}

// === WHEELS ===
draw_set_color(make_color_rgb(28, 24, 18));
draw_circle(x - 24, y, 13, false);
draw_circle(x + 24, y, 13, false);
// Tire tread ring
draw_set_color(make_color_rgb(48, 42, 32));
draw_circle(x - 24, y, 13, true);
draw_circle(x + 24, y, 13, true);
// Hub
draw_set_color(make_color_rgb(78, 68, 52));
draw_circle(x - 24, y, 6, false);
draw_circle(x + 24, y, 6, false);
// Spoke (rotates with wheel_spin)
draw_set_color(make_color_rgb(55, 48, 36));
draw_line_width(x - 24 + lengthdir_x(6, wheel_spin),       y + lengthdir_y(6, wheel_spin),
                x - 24 + lengthdir_x(6, wheel_spin + 180),  y + lengthdir_y(6, wheel_spin + 180), 2);
draw_line_width(x + 24 + lengthdir_x(6, wheel_spin),       y + lengthdir_y(6, wheel_spin),
                x + 24 + lengthdir_x(6, wheel_spin + 180),  y + lengthdir_y(6, wheel_spin + 180), 2);

// === CHASSIS ===
draw_set_color(make_color_rgb(68, 88, 44));
draw_rectangle(x - 40, y - 22, x + 40, y - 4, false);
// Undercarriage reinforcement bar
draw_set_color(make_color_rgb(52, 68, 32));
draw_rectangle(x - 38, y - 6,  x + 38, y - 4, false);

// === HOOD / FRONT (right side) ===
draw_set_color(make_color_rgb(60, 78, 38));
draw_rectangle(x + 26, y - 18, x + 50, y - 6, false);
// Grille slats
draw_set_color(make_color_rgb(38, 50, 22));
for (var s = 0; s < 3; s++) {
    draw_rectangle(x + 44, y - 17 + s * 4, x + 49, y - 14 + s * 4, false);
}
// Headlight
draw_set_color(make_color_rgb(210, 200, 130));
draw_circle(x + 47, y - 10, 3, false);

// === CAB / ROLLBAR ===
draw_set_color(make_color_rgb(52, 68, 32));
draw_rectangle(x - 2, y - 36, x + 28, y - 22, false);
// Windshield glass
draw_set_alpha(0.45);
draw_set_color(make_color_rgb(140, 175, 195));
draw_rectangle(x, y - 34, x + 26, y - 24, false);
draw_set_alpha(1);
// Rollbar post (rear of cab)
draw_set_color(make_color_rgb(42, 55, 25));
draw_rectangle(x - 2, y - 36, x + 2, y - 22, false);

// === DAN (driver, visible above chassis) ===
// Torso
draw_set_color(make_color_rgb(74, 100, 50));
draw_rectangle(x + 4, y - 36, x + 18, y - 22, false);
// Head
draw_set_color(make_color_rgb(195, 140, 88));
draw_rectangle(x + 6, y - 44, x + 16, y - 36, false);
// Helmet
draw_set_color(make_color_rgb(55, 70, 32));
draw_rectangle(x + 4, y - 48, x + 18, y - 40, false);
draw_rectangle(x + 3, y - 41, x + 19, y - 40, false);
// Arm (reaching out right, holding gun)
draw_set_color(make_color_rgb(74, 100, 50));
draw_rectangle(x + 16, y - 36, x + 32, y - 30, false);

// === MOUNTED MG (rear) ===
draw_set_color(make_color_rgb(42, 38, 30));
draw_rectangle(x - 36, y - 38, x - 6,  y - 34, false);
draw_rectangle(x - 26, y - 46, x - 22, y - 38, false);
// Gun barrel
draw_line_width(x - 22, y - 42, x + 2, y - 42, 3);

// === JERRY CANS (left side rear) ===
draw_set_color(make_color_rgb(62, 80, 42));
draw_rectangle(x - 46, y - 28, x - 40, y - 10, false);
draw_rectangle(x - 39, y - 28, x - 33, y - 10, false);

// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
