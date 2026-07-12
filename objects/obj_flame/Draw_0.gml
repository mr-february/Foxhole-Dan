var _t    = 1 - life / life_max;          // 0 → 1 over lifetime
var _grow = min(_t * 2.2, 1);             // grows fast, then holds
var _r    = 4 + _grow * 14;
var _a    = life / life_max;              // fades out as it dies
var _jx   = random_range(-1.5, 1.5);
var _jy   = random_range(-1.5, 1.5);

// Outer ember — deep orange
draw_set_alpha(0.45 * _a);
draw_set_color(make_color_rgb(230, 90, 20));
draw_circle(x + _jx, y + _jy, _r, false);

// Mid flame — bright orange
draw_set_alpha(0.65 * _a);
draw_set_color(make_color_rgb(255, 150, 40));
draw_circle(x + _jx * 0.6, y + _jy * 0.6 - 1, _r * 0.65, false);

// Hot core — yellow-white
draw_set_alpha(0.90 * _a);
draw_set_color(make_color_rgb(255, 230, 120));
draw_circle(x, y - 1, _r * 0.32, false);

// Stray spark
if (irandom(2) == 0) {
    draw_set_alpha(0.8 * _a);
    draw_set_color(make_color_rgb(255, 200, 80));
    draw_circle(x + random_range(-_r, _r), y - _r * 0.8 + random_range(-3, 0), 1, false);
}

draw_set_alpha(1);
draw_set_color(c_white);
