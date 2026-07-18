// === PARALLAX TERRAIN (world-space, behind the chopper/gunner/targets) ===
// This used to live in Draw GUI, which paints over EVERYTHING (including the
// player's own chopper and all heli targets) since GUI always composites on
// top of the whole room — that's why the chopper/enemies were invisible.
// depth is set very high in Create_0 so this draws first, before anything else.
var gw = 1920;
var gh = 768;

// Sky
draw_set_color(make_color_rgb(150, 120, 78));
draw_rectangle(0, 0, gw, gh, false);
draw_set_color(make_color_rgb(120, 96, 64));
draw_rectangle(0, gh * 0.55, gw, gh, false);
// Far hills (slow parallax)
draw_set_color(make_color_rgb(70, 84, 56));
var off1 = -(scroll * 0.3) mod (gw + 400);
for (var i = -1; i < 3; i++) {
    var hx = off1 + i * (gw * 0.6);
    draw_triangle(hx, gh * 0.62, hx + 260, gh * 0.44, hx + 520, gh * 0.62, false);
}
// Near jungle strip (fast parallax)
draw_set_color(make_color_rgb(34, 54, 30));
draw_rectangle(0, gh * 0.78, gw, gh, false);
draw_set_color(make_color_rgb(44, 66, 36));
var off2 = -(scroll * 0.9) mod 180;
for (var j = -1; j < gw / 90 + 1; j++) {
    var tx = off2 + j * 90;
    draw_triangle(tx, gh * 0.82, tx + 30, gh * 0.66, tx + 60, gh * 0.82, false);
}
draw_set_color(c_white);
