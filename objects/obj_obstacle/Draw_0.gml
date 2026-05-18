// Sandbag wall — 24px wide, 40px tall, origin at bottom-center (12, 40)
// So drawing area: x-12 to x+12, y-40 to y

var c1 = make_color_rgb(148, 118, 72);   // sandbag tan
var c2 = make_color_rgb(120, 95,  55);   // shadow tan
var c3 = make_color_rgb(162, 132, 84);   // highlight

// Row 1 — bottom two bags
draw_set_color(c1);
draw_rectangle(x - 12, y - 10, x - 1,  y, false);
draw_rectangle(x + 1,  y - 10, x + 12, y, false);
draw_set_color(c2);
draw_rectangle(x - 12, y - 2,  x + 12, y, false);
draw_set_color(c3);
draw_rectangle(x - 12, y - 10, x + 12, y - 9, false);

// Row 2 — offset by half-bag
draw_set_color(c1);
draw_rectangle(x - 11, y - 20, x + 1,  y - 10, false);
draw_rectangle(x + 1,  y - 20, x + 11, y - 10, false);
draw_set_color(c2);
draw_rectangle(x - 11, y - 12, x + 11, y - 10, false);

// Row 3
draw_set_color(make_color_rgb(155, 124, 78));
draw_rectangle(x - 10, y - 30, x,      y - 20, false);
draw_rectangle(x,      y - 30, x + 10, y - 20, false);
draw_set_color(c2);
draw_rectangle(x - 10, y - 22, x + 10, y - 20, false);

// Row 4 — top, single narrow
draw_set_color(make_color_rgb(140, 112, 65));
draw_rectangle(x - 8,  y - 38, x + 8,  y - 30, false);

// Topmost small sandbag
draw_set_color(c1);
draw_rectangle(x - 5, y - 40, x + 5, y - 38, false);

// Rope binding lines
draw_set_color(make_color_rgb(90, 70, 40));
draw_line(x - 12, y - 10, x + 12, y - 10);
draw_line(x - 11, y - 20, x + 11, y - 20);
draw_line(x - 10, y - 30, x + 10, y - 30);
