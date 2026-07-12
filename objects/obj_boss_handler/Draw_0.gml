// === THE HANDLER — '80s intelligence operative. Long charcoal trench coat,
// black gloves, aviators, earpiece. Deliberately NOT a soldier silhouette.
var bx = x;
var by = y;
var f  = facing;

// Phase 2 enrage glow — cold blue-white, not the Sergeant's red
if (phase == 2) {
    var rage = 0.3 + abs(sin(current_time * 0.008)) * 0.4;
    draw_set_color(make_color_rgb(90, 140, 220));
    draw_set_alpha(rage * 0.35);
    draw_circle(bx, by - 28, 36, false);
    draw_set_alpha(1);
}

// Flash white when enraging
if (enrage_flash > 0 && (enrage_flash mod 8) < 4) {
    draw_set_color(c_white);
    draw_rectangle(bx - 20, by - 56, bx + 20, by, false);
    draw_set_color(c_white);
    exit;
}

// I-frames blink
if (i_frames > 0 && (i_frames mod 6) < 3) {
    draw_set_color(c_white);
    draw_rectangle(bx - 20, by - 56, bx + 20, by, false);
    draw_set_color(c_white);
    exit;
}

// Dress shoes
draw_set_color(make_color_rgb(15, 15, 18));
draw_rectangle(bx - 14, by - 6, bx + 14, by, false);

// Slacks (visible below the coat hem)
draw_set_color(make_color_rgb(28, 28, 34));
draw_rectangle(bx - 12, by - 16, bx + 12, by - 6, false);

// Trench coat — long body, darker in phase 2
var coat_col = (phase == 2) ? make_color_rgb(30, 34, 46) : make_color_rgb(42, 44, 52);
draw_set_color(coat_col);
draw_rectangle(bx - 17, by - 42, bx + 17, by - 16, false);
// Coat skirt flares slightly at the hem
draw_rectangle(bx - 19, by - 24, bx + 19, by - 16, false);

// Coat lapels — V opening down the chest
draw_set_color(make_color_rgb(22, 24, 30));
draw_line_width(bx - 8, by - 42, bx, by - 30, 3);
draw_line_width(bx + 8, by - 42, bx, by - 30, 3);

// Shirt sliver + tie (dark red — the only color on him)
draw_set_color(make_color_rgb(190, 190, 195));
draw_rectangle(bx - 2, by - 41, bx + 2, by - 31, false);
draw_set_color(make_color_rgb(120, 20, 30));
draw_rectangle(bx - 1, by - 41, bx + 1, by - 29, false);

// Coat belt
draw_set_color(make_color_rgb(20, 22, 28));
draw_rectangle(bx - 17, by - 28, bx + 17, by - 25, false);

// Shoulders — squared, padded
draw_set_color(coat_col);
draw_rectangle(bx - 20, by - 44, bx + 20, by - 38, false);

// Black gloves at the coat cuffs
draw_set_color(make_color_rgb(12, 12, 14));
draw_rectangle(bx - 20, by - 30, bx - 15, by - 25, false);

// Neck
draw_set_color(make_color_rgb(200, 165, 135));
draw_rectangle(bx - 4, by - 46, bx + 4, by - 43, false);

// Head — pale, gaunt
draw_set_color(make_color_rgb(205, 170, 140));
draw_rectangle(bx - 9, by - 58, bx + 9, by - 44, false);

// Slicked-back hair — steel gray
draw_set_color(make_color_rgb(120, 120, 125));
draw_rectangle(bx - 9, by - 60, bx + 9, by - 55, false);
draw_rectangle(bx - 10, by - 58, bx + 10, by - 56, false);

// Aviator sunglasses — single black band, cold glint
draw_set_color(make_color_rgb(8, 8, 10));
draw_rectangle(bx - 9, by - 54, bx + 9, by - 50, false);
draw_set_color((phase == 2) ? make_color_rgb(120, 170, 255) : make_color_rgb(160, 160, 170));
draw_rectangle(bx + f * 3, by - 53, bx + f * 6, by - 52, false);

// Earpiece + wire down into the collar
draw_set_color(make_color_rgb(60, 60, 65));
draw_rectangle(bx - f * 10, by - 53, bx - f * 8, by - 50, false);
draw_line(bx - f * 9, by - 50, bx - f * 11, by - 43);

// Gun arm — suppressed machine pistol, held level
var gun_dir = (f >= 0) ? 0 : 180;
var gun_len = 24;
var gx = bx + f * 17;
var gy = by - 30;
draw_set_color(make_color_rgb(18, 18, 20));
draw_line_width(gx, gy, gx + lengthdir_x(gun_len, gun_dir), gy + lengthdir_y(gun_len, gun_dir), 4);
// Suppressor — thicker tip
draw_line_width(gx + lengthdir_x(gun_len, gun_dir), gy,
                gx + lengthdir_x(gun_len + 8, gun_dir), gy, 6);

draw_set_color(c_white);
