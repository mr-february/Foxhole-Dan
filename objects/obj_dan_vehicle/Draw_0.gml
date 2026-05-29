// i-frame blink
if (i_frames > 0 && (current_time mod 8) < 4) exit;

var wr  = 15;   // wheel radius
var wx1 = x - 27;
var wx2 = x + 27;

// =========================================================
// DUST TRAIL (kick up behind left wheel when on ground)
// =========================================================
if (on_ground) {
    for (var di = 0; di < 4; di++) {
        draw_set_alpha(0.07 + di * 0.055);
        draw_set_color(make_color_rgb(162, 136, 88));
        draw_circle(x - 50 - di * 14 + irandom(6), y + 2 + irandom(3), 4 + di * 7, false);
    }
    draw_set_alpha(1);
}

// =========================================================
// WHEELS — tread blocks, wheel disc, spokes, hub, lug nuts
// =========================================================
// Outer rubber tyre (dark)
draw_set_color(make_color_rgb(18, 14, 8));
draw_circle(wx1, y, wr, false);
draw_circle(wx2, y, wr, false);

// Tread lugs (6 per wheel, animated with wheel_spin)
for (var td = 0; td < 6; td++) {
    var ta = wheel_spin + td * 60;
    draw_set_color(make_color_rgb(28, 22, 12));
    draw_line_width(
        wx1 + lengthdir_x(wr - 1, ta), y + lengthdir_y(wr - 1, ta),
        wx1 + lengthdir_x(wr - 5, ta), y + lengthdir_y(wr - 5, ta), 3);
    draw_line_width(
        wx2 + lengthdir_x(wr - 1, ta), y + lengthdir_y(wr - 1, ta),
        wx2 + lengthdir_x(wr - 5, ta), y + lengthdir_y(wr - 5, ta), 3);
}

// Wheel disc face
draw_set_color(make_color_rgb(56, 50, 38));
draw_circle(wx1, y, wr - 5, false);
draw_circle(wx2, y, wr - 5, false);

// 3 spokes (rotating)
draw_set_color(make_color_rgb(72, 65, 50));
for (var sp = 0; sp < 3; sp++) {
    var sa = wheel_spin + sp * 120;
    draw_line_width(
        wx1 + lengthdir_x(3,      sa), y + lengthdir_y(3,      sa),
        wx1 + lengthdir_x(wr - 6, sa), y + lengthdir_y(wr - 6, sa), 2);
    draw_line_width(
        wx2 + lengthdir_x(3,      sa), y + lengthdir_y(3,      sa),
        wx2 + lengthdir_x(wr - 6, sa), y + lengthdir_y(wr - 6, sa), 2);
}

// Hub cap
draw_set_color(make_color_rgb(90, 82, 64));
draw_circle(wx1, y, 4, false);
draw_circle(wx2, y, 4, false);

// 4 lug nuts
draw_set_color(make_color_rgb(114, 104, 82));
for (var lu = 0; lu < 4; lu++) {
    var la = wheel_spin + lu * 90;
    draw_circle(wx1 + lengthdir_x(7, la), y + lengthdir_y(7, la), 1, false);
    draw_circle(wx2 + lengthdir_x(7, la), y + lengthdir_y(7, la), 1, false);
}

// =========================================================
// FENDERS (flat metal arches above each wheel)
// =========================================================
draw_set_color(make_color_rgb(62, 76, 40));
draw_rectangle(wx1 - wr - 2, y - wr - 3, wx1 + wr + 2, y - wr + 4, false);
draw_rectangle(wx2 - wr - 2, y - wr - 3, wx2 + wr + 2, y - wr + 4, false);
// Fender shadow edge
draw_set_color(make_color_rgb(44, 55, 26));
draw_line(wx1 - wr - 2, y - wr - 3, wx1 + wr + 2, y - wr - 3);
draw_line(wx2 - wr - 2, y - wr - 3, wx2 + wr + 2, y - wr - 3);

// =========================================================
// CHASSIS — main body (olive drab)
// =========================================================
draw_set_color(make_color_rgb(70, 86, 44));
draw_rectangle(x - 44, y - 20, x + 30, y - 5, false);
// Lower side skirt / armor lip
draw_set_color(make_color_rgb(52, 64, 30));
draw_rectangle(x - 44, y - 8, x + 30, y - 5, false);
// Top panel line (highlight)
draw_set_color(make_color_rgb(78, 96, 50));
draw_rectangle(x - 44, y - 20, x + 30, y - 18, false);

// =========================================================
// REAR CARGO AREA (left side of chassis)
// =========================================================
// Ammo crate
draw_set_color(make_color_rgb(80, 96, 52));
draw_rectangle(x - 42, y - 26, x - 20, y - 10, false);
draw_set_color(make_color_rgb(60, 74, 36));
draw_line(x - 31, y - 26, x - 31, y - 10);
draw_line(x - 42, y - 18, x - 20, y - 18);
// Crate latch
draw_set_color(make_color_rgb(92, 104, 60));
draw_point(x - 31, y - 17);
// Jerry can stack (far left)
draw_set_color(make_color_rgb(64, 78, 42));
draw_rectangle(x - 48, y - 24, x - 42, y - 8, false);
draw_set_color(make_color_rgb(50, 62, 30));
draw_line(x - 45, y - 24, x - 45, y - 8);
// Can cap
draw_set_color(make_color_rgb(84, 78, 58));
draw_rectangle(x - 48, y - 26, x - 42, y - 24, false);

// =========================================================
// HOOD / ENGINE COMPARTMENT (right side, protruding forward)
// =========================================================
draw_set_color(make_color_rgb(65, 80, 42));
draw_rectangle(x + 28, y - 18, x + 56, y - 5, false);
// Hood panel louvres (engine vents)
draw_set_color(make_color_rgb(50, 62, 28));
for (var lv = 0; lv < 4; lv++) {
    draw_line(x + 33 + lv * 5, y - 18, x + 33 + lv * 5, y - 6);
}
// Top hood line
draw_set_color(make_color_rgb(76, 92, 48));
draw_line(x + 28, y - 18, x + 56, y - 18);
// Front grille face (vertical bars)
draw_set_color(make_color_rgb(26, 30, 14));
draw_rectangle(x + 52, y - 17, x + 57, y - 6, false);
for (var gs = 0; gs < 4; gs++) {
    draw_set_color(make_color_rgb(18, 22, 10));
    draw_line(x + 53, y - 16 + gs * 3, x + 56, y - 16 + gs * 3);
}
// Bumper bar
draw_set_color(make_color_rgb(42, 36, 24));
draw_rectangle(x + 55, y - 12, x + 61, y - 3, false);
// Tow hook
draw_set_color(make_color_rgb(70, 64, 48));
draw_line(x + 58, y - 7, x + 63, y - 5);
// Round headlight
draw_set_color(make_color_rgb(50, 46, 34));
draw_circle(x + 53, y - 10, 4, false);
draw_set_color(make_color_rgb(218, 208, 138));
draw_circle(x + 53, y - 10, 2, false);
// Exhaust pipe (low right, runs along bottom)
draw_set_color(make_color_rgb(38, 33, 23));
draw_rectangle(x + 38, y - 7, x + 57, y - 4, false);
draw_set_color(make_color_rgb(28, 25, 17));
draw_circle(x + 57, y - 5, 2, false);

// =========================================================
// CAB FRAME / ROLLBAR STRUCTURE
// =========================================================
draw_set_color(make_color_rgb(52, 65, 30));
// Left rollbar post (rear)
draw_rectangle(x - 5,  y - 40, x - 1,  y - 20, false);
// Right rollbar post (front/windshield edge)
draw_rectangle(x + 27, y - 40, x + 31, y - 20, false);
// Top crossbar
draw_rectangle(x - 5, y - 41, x + 31, y - 38, false);
// Rear cross-brace (X-shape)
draw_line(x - 4, y - 38, x + 30, y - 22);
draw_line(x + 30, y - 38, x - 4, y - 22);

// Cab floor / footwell
draw_set_color(make_color_rgb(62, 76, 38));
draw_rectangle(x - 3, y - 20, x + 30, y - 20, false);

// =========================================================
// WINDSHIELD — split pane with frame
// =========================================================
// Frame
draw_set_color(make_color_rgb(44, 55, 24));
draw_rectangle(x - 2, y - 38, x + 30, y - 20, false);
// Left pane glass
draw_set_alpha(0.42);
draw_set_color(make_color_rgb(148, 184, 205));
draw_rectangle(x, y - 36, x + 13, y - 22, false);
// Right pane glass
draw_rectangle(x + 15, y - 36, x + 28, y - 22, false);
draw_set_alpha(1);
// Centre divider
draw_set_color(make_color_rgb(40, 50, 22));
draw_line(x + 14, y - 37, x + 14, y - 21);
// Corner bolts
draw_set_color(make_color_rgb(66, 60, 44));
draw_point(x + 1,  y - 37);
draw_point(x + 27, y - 37);
draw_point(x + 1,  y - 21);
draw_point(x + 27, y - 21);

// =========================================================
// DAN (driver silhouette)
// =========================================================
// Torso (olive uniform)
draw_set_color(make_color_rgb(72, 98, 48));
draw_rectangle(x + 5, y - 38, x + 20, y - 22, false);
// Equipment/ammo pouch
draw_set_color(make_color_rgb(56, 76, 34));
draw_rectangle(x + 13, y - 34, x + 20, y - 26, false);
// Shoulder strap
draw_set_color(make_color_rgb(96, 116, 62));
draw_line(x + 8, y - 36, x + 20, y - 28);
// Head
draw_set_color(make_color_rgb(196, 144, 90));
draw_rectangle(x + 7, y - 46, x + 19, y - 38, false);
// M1 helmet (domed shape)
draw_set_color(make_color_rgb(58, 72, 34));
draw_ellipse(x + 4, y - 52, x + 22, y - 40, false);
// Helmet rim brim
draw_rectangle(x + 3, y - 43, x + 23, y - 40, false);
// Goggle strap on helmet
draw_set_color(make_color_rgb(40, 56, 28));
draw_rectangle(x + 5, y - 50, x + 21, y - 46, false);
// Arm reaching forward to gun grip
draw_set_color(make_color_rgb(72, 98, 48));
draw_rectangle(x + 18, y - 36, x + 32, y - 30, false);
// Gloved hand
draw_set_color(make_color_rgb(46, 42, 32));
draw_circle(x + 31, y - 32, 3, false);

// =========================================================
// PINTLE-MOUNTED .30 CAL MG (rear of cab)
// =========================================================
// Mount socket post
draw_set_color(make_color_rgb(36, 32, 23));
draw_rectangle(x - 26, y - 48, x - 21, y - 36, false);
// Pintle ring
draw_set_color(make_color_rgb(50, 46, 34));
draw_circle(x - 23, y - 47, 5, true);
// Receiver body
draw_set_color(make_color_rgb(30, 26, 18));
draw_rectangle(x - 36, y - 53, x - 14, y - 45, false);
// Rear sight
draw_set_color(make_color_rgb(22, 20, 14));
draw_line(x - 34, y - 53, x - 34, y - 57);
// Barrel (pointing right toward enemy)
draw_set_color(make_color_rgb(24, 22, 16));
draw_line_width(x - 14, y - 49, x + 4,  y - 49, 3);
// Barrel jacket / cooling shroud
draw_set_color(make_color_rgb(38, 34, 24));
draw_rectangle(x - 14, y - 51, x - 4, y - 47, false);
// Muzzle tip
draw_set_color(make_color_rgb(20, 18, 12));
draw_circle(x + 4, y - 49, 2, false);
// Muzzle flash
if (shoot_flash > 0) {
    var _mfa = shoot_flash / 5.0;
    draw_set_alpha(0.9 * _mfa);
    draw_set_color(make_color_rgb(255, 215, 70));
    draw_circle(x + 8, y - 49, 9 * _mfa, false);
    draw_set_alpha(0.6 * _mfa);
    draw_set_color(c_white);
    draw_circle(x + 8, y - 49, 4 * _mfa, false);
    draw_set_alpha(1);
}
// Ammo box (belt-fed)
draw_set_color(make_color_rgb(76, 90, 48));
draw_rectangle(x - 36, y - 60, x - 24, y - 53, false);
draw_set_color(make_color_rgb(58, 70, 34));
draw_line(x - 30, y - 60, x - 30, y - 53);
// Belt feed
draw_set_color(make_color_rgb(92, 104, 60));
draw_line(x - 28, y - 53, x - 22, y - 49);

draw_set_alpha(1);
draw_set_color(c_white);
