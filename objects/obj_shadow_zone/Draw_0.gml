// Dark translucent hiding zone — a pool of shadow Dan can slip into.
draw_set_color(make_color_rgb(6, 8, 16));
draw_set_alpha(0.55);
draw_rectangle(x - zw, y - zh, x + zw, y, false);
// soft feathered edges
draw_set_alpha(0.28);
draw_rectangle(x - zw - 24, y - zh, x - zw, y, false);
draw_rectangle(x + zw, y - zh, x + zw + 24, y, false);
draw_set_alpha(1);
draw_set_color(c_white);
