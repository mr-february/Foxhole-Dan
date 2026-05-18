// Concrete/sandbag platform block
var x1 = x;
var y1 = y;
var x2 = x + 32;
var y2 = y + 32;

// Base concrete fill
draw_set_color(make_color_rgb(68, 62, 54));
draw_rectangle(x1, y1, x2, y2, false);

// Top surface (lighter, dirt/grass)
draw_set_color(make_color_rgb(52, 70, 38));
draw_rectangle(x1, y1, x2, y1 + 5, false);
// Dirt variation on top
draw_set_color(make_color_rgb(44, 58, 32));
draw_rectangle(x1 + 4, y1 + 1, x1 + 10, y1 + 4, false);
draw_rectangle(x1 + 18, y1 + 1, x1 + 26, y1 + 3, false);

// Mortar line (horizontal crack)
draw_set_color(make_color_rgb(45, 40, 34));
draw_rectangle(x1, y1 + 16, x2, y1 + 18, false);

// Vertical crack/seam at center
draw_set_color(make_color_rgb(50, 45, 38));
draw_rectangle(x1 + 15, y1 + 5, x1 + 17, y2, false);

// Edge highlight (top-left)
draw_set_color(make_color_rgb(85, 78, 68));
draw_line(x1, y1, x2, y1);
draw_line(x1, y1, x1, y2);

// Edge shadow (bottom-right)
draw_set_color(make_color_rgb(40, 35, 28));
draw_line(x1, y2, x2, y2);
draw_line(x2, y1, x2, y2);

draw_set_color(c_white);
