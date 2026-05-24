var x1 = x;
var y1 = y;
var x2 = x + 32;
var y2 = y + 32;

// Position hash for per-tile variety (deterministic, no variables needed)
var _h = (x1 * 7 + y1 * 13) mod 100;

// =========================================================
// TILE VARIANTS based on position hash
// =========================================================
if (_h < 18) {
    // --- SANDBAG TOP ---
    // Concrete base
    draw_set_color(make_color_rgb(62, 56, 48));
    draw_rectangle(x1, y1 + 9, x2, y2, false);
    // Two sandbags side by side
    draw_set_color(make_color_rgb(110, 92, 62));
    draw_ellipse(x1 + 1, y1 + 1, x1 + 15, y1 + 13, false);
    draw_ellipse(x1 + 14, y1 + 1, x2 - 1, y1 + 13, false);
    // Seam tie on bags
    draw_set_color(make_color_rgb(80, 65, 42));
    draw_rectangle(x1 + 13, y1 + 4, x1 + 15, y1 + 10, false);
    // Shadow under bags
    draw_set_color(make_color_rgb(45, 40, 34));
    draw_rectangle(x1, y1 + 10, x2, y1 + 13, false);

} else if (_h < 36) {
    // --- CRACKED / BATTLE-DAMAGED ---
    draw_set_color(make_color_rgb(58, 52, 44));
    draw_rectangle(x1, y1, x2, y2, false);
    // Dirt/rubble top
    draw_set_color(make_color_rgb(48, 64, 34));
    draw_rectangle(x1, y1, x2, y1 + 5, false);
    // Large diagonal crack
    draw_set_color(make_color_rgb(30, 26, 20));
    draw_line(x1 + 6, y1 + 4, x1 + 18, y2 - 2);
    draw_line(x1 + 7, y1 + 4, x1 + 19, y2 - 2);
    // Spalled chunk (missing corner)
    draw_set_color(make_color_rgb(14, 12, 10));
    draw_triangle(x2 - 10, y1, x2, y1, x2, y1 + 10, false);
    // Rubble inside spall
    draw_set_color(make_color_rgb(68, 58, 46));
    draw_rectangle(x2 - 7, y1 + 2, x2 - 2, y1 + 7, false);
    // Mortar horizontal
    draw_set_color(make_color_rgb(38, 33, 27));
    draw_rectangle(x1, y1 + 16, x2, y1 + 18, false);

} else if (_h < 52) {
    // --- MUD / WATER PUDDLE TOP ---
    draw_set_color(make_color_rgb(65, 58, 50));
    draw_rectangle(x1, y1, x2, y2, false);
    // Muddy top
    draw_set_color(make_color_rgb(55, 48, 34));
    draw_rectangle(x1, y1, x2, y1 + 5, false);
    // Puddle
    draw_set_color(make_color_rgb(30, 38, 50));
    draw_ellipse(x1 + 5, y1 + 1, x1 + 22, y1 + 4, false);
    // Puddle highlight
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(120, 150, 180));
    draw_ellipse(x1 + 7, y1 + 1, x1 + 14, y1 + 2, false);
    draw_set_alpha(1);
    // Mortar line
    draw_set_color(make_color_rgb(42, 37, 30));
    draw_rectangle(x1, y1 + 16, x2, y1 + 17, false);
    // Vertical seam
    draw_set_color(make_color_rgb(48, 42, 35));
    draw_rectangle(x1 + 15, y1 + 5, x1 + 16, y2, false);

} else {
    // --- STANDARD CONCRETE (most tiles) ---
    draw_set_color(make_color_rgb(68, 62, 54));
    draw_rectangle(x1, y1, x2, y2, false);
    // Top surface (dirt/grass)
    draw_set_color(make_color_rgb(52, 70, 38));
    draw_rectangle(x1, y1, x2, y1 + 5, false);
    // Dirt clumps on top (vary by hash)
    draw_set_color(make_color_rgb(44, 58, 32));
    if (_h mod 2 == 0) {
        draw_rectangle(x1 + 4,  y1 + 1, x1 + 10, y1 + 4, false);
        draw_rectangle(x1 + 18, y1 + 1, x1 + 26, y1 + 3, false);
    } else {
        draw_rectangle(x1 + 2,  y1 + 1, x1 + 9,  y1 + 3, false);
        draw_rectangle(x1 + 20, y1 + 1, x1 + 29, y1 + 4, false);
    }
    // Mortar line
    draw_set_color(make_color_rgb(45, 40, 34));
    draw_rectangle(x1, y1 + 16, x2, y1 + 18, false);
    // Vertical seam (offset by hash)
    var _sv = x1 + 12 + (_h mod 8);
    draw_set_color(make_color_rgb(50, 45, 38));
    draw_rectangle(_sv, y1 + 5, _sv + 2, y2, false);
}

// Shared edge highlight (top-left)
draw_set_color(make_color_rgb(85, 78, 68));
draw_line(x1, y1, x2, y1);
draw_line(x1, y1, x1, y2);

// Shared edge shadow (bottom-right)
draw_set_color(make_color_rgb(40, 35, 28));
draw_line(x1, y2, x2, y2);
draw_line(x2, y1, x2, y2);

draw_set_color(c_white);
