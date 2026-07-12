// === BOULDER — round grey rock that visibly rotates ===
var cx = x + 16;
var cy = y + 16;
var r  = 17;

// Body
draw_set_color(make_color_rgb(96, 94, 98));
draw_circle(cx, cy, r, false);

// Shaded lower-right
draw_set_color(make_color_rgb(66, 64, 70));
draw_circle(cx + 4, cy + 4, r - 6, false);

// Rotating pits/cracks — three dark spots orbiting with rot
var _a;
_a = degtorad(rot);
draw_set_color(make_color_rgb(52, 50, 55));
draw_circle(cx + cos(_a) * 8,  cy - sin(_a) * 8,  3.5, false);
_a = degtorad(rot + 130);
draw_circle(cx + cos(_a) * 10, cy - sin(_a) * 10, 2.5, false);
_a = degtorad(rot + 245);
draw_circle(cx + cos(_a) * 6,  cy - sin(_a) * 6,  3.0, false);

// Rotating fracture line
_a = degtorad(rot + 60);
draw_set_color(make_color_rgb(48, 46, 52));
draw_line_width(cx - cos(_a) * (r - 4), cy + sin(_a) * (r - 4),
                cx + cos(_a) * (r - 4), cy - sin(_a) * (r - 4), 2);

// Top-left highlight + snow dusting
draw_set_color(make_color_rgb(150, 150, 156));
draw_circle(cx - 6, cy - 6, 4, false);
draw_set_alpha(0.55);
draw_set_color(make_color_rgb(226, 236, 246));
draw_circle(cx - 4, cy - r + 3, 4, false);
draw_circle(cx + 5, cy - r + 2, 3, false);
draw_set_alpha(1);

// Outline
draw_set_color(make_color_rgb(38, 36, 42));
draw_circle(cx, cy, r, true);

draw_set_color(c_white);
