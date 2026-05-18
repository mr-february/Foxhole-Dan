var bx = x;
var by = y;
var f  = facing;

// Phase 2 enrage glow
if (phase == 2) {
    var rage = 0.3 + abs(sin(current_time * 0.008)) * 0.4;
    draw_set_color(make_color_rgb(220, 40, 0));
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

// Boots
draw_set_color(make_color_rgb(40, 30, 20));
draw_rectangle(bx - 16, by - 8, bx + 16, by, false);

// Legs
draw_set_color(make_color_rgb(50, 50, 50));
draw_rectangle(bx - 14, by - 22, bx + 14, by - 8, false);

// Body armor (heavy plating)
var armor_col = (phase == 2) ? make_color_rgb(120, 20, 20) : make_color_rgb(50, 60, 50);
draw_set_color(armor_col);
draw_rectangle(bx - 18, by - 42, bx + 18, by - 22, false);

// Armor highlights
draw_set_color(make_color_rgb(80, 90, 80));
draw_rectangle(bx - 16, by - 40, bx - 10, by - 24, false);
draw_rectangle(bx + 10, by - 40, bx + 16, by - 24, false);

// Shoulders (epaulettes)
draw_set_color(make_color_rgb(60, 70, 60));
draw_rectangle(bx - 20, by - 44, bx - 12, by - 38, false);
draw_rectangle(bx + 12, by - 44, bx + 20, by - 38, false);

// Rank bars on shoulder
draw_set_color(make_color_rgb(200, 160, 40));
draw_rectangle(bx - 19, by - 43, bx - 14, by - 42, false);
draw_rectangle(bx + 14, by - 43, bx + 19, by - 42, false);
draw_rectangle(bx - 19, by - 41, bx - 14, by - 40, false);
draw_rectangle(bx + 14, by - 41, bx + 19, by - 40, false);

// Neck
draw_set_color(make_color_rgb(180, 130, 90));
draw_rectangle(bx - 5, by - 46, bx + 5, by - 42, false);

// Head
draw_set_color(make_color_rgb(180, 130, 90));
draw_rectangle(bx - 10, by - 56, bx + 10, by - 42, false);

// Helmet
draw_set_color(make_color_rgb(30, 35, 30));
draw_rectangle(bx - 12, by - 58, bx + 12, by - 50, false);
draw_rectangle(bx - 10, by - 60, bx + 10, by - 55, false);

// Eyes — menacing red
draw_set_color(make_color_rgb(220, 40, 0));
draw_rectangle(bx - 8, by - 53, bx - 3, by - 50, false);
draw_rectangle(bx + 3, by - 53, bx + 8, by - 50, false);

// Scar
draw_set_color(make_color_rgb(120, 60, 50));
draw_line(bx - 2, by - 54, bx + 4, by - 48);

// Gun arm — big rifle
var gun_dir = (f >= 0) ? 0 : 180;
var gun_len = 28;
var gx = bx + f * 18;
var gy = by - 32;
draw_set_color(make_color_rgb(30, 30, 30));
draw_line_width(gx, gy, gx + lengthdir_x(gun_len, gun_dir), gy + lengthdir_y(gun_len, gun_dir), 5);

draw_set_color(c_white);
