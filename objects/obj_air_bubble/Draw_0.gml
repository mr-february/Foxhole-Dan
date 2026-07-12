// A shimmering pocket of rising bubbles — swim through to refill air.
draw_set_color(make_color_rgb(190, 220, 235));
for (var i = 0; i < 6; i++) {
    var t = rise + i * 1.1;
    var bxp = x + sin(t * 1.3) * 8;
    var byp = y - ((t * 6) mod 40) + 20;
    draw_set_alpha(0.35 + 0.25 * sin(t));
    draw_circle(bxp, byp, 3 + (i mod 3), true);
}
draw_set_alpha(1);
draw_set_color(c_white);
