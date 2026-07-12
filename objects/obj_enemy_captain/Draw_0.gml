var bx = x;
var by = y;
var f  = image_xscale;

var hurt = 1 - (hp / max_hp);

// === BODY (soldier build, darker command coat) ===
draw_set_color(make_color_rgb(16, 12, 8));
draw_rectangle(bx - 8, by - 5, bx + 8, by, false);
draw_set_color(make_color_rgb(round(38 + hurt * 70), round(34 + hurt * 8), round(30 - hurt * 12)));
draw_rectangle(bx - 7, by - 17, bx + 7, by - 5, false);
draw_set_color(make_color_rgb(round(46 + hurt * 80), round(40 + hurt * 10), round(32 - hurt * 15)));
draw_rectangle(bx - 9, by - 30, bx + 9, by - 17, false);
// Command sash
draw_set_color(make_color_rgb(150, 20, 20));
draw_line_width(bx - 6, by - 29, bx + 6, by - 18, 2);
// Gun arm
draw_set_color(make_color_rgb(30, 27, 22));
draw_rectangle(bx + f * 5, by - 25, bx + f * 15, by - 21, false);
// Head
draw_set_color(make_color_rgb(165, 115, 78));
draw_rectangle(bx - 5, by - 38, bx + 5, by - 30, false);
// Captain's cap — red band
draw_set_color(make_color_rgb(24, 22, 20));
draw_rectangle(bx - 6, by - 41, bx + 6, by - 36, false);
draw_set_color(make_color_rgb(180, 20, 20));
draw_rectangle(bx - 6, by - 37, bx + 6, by - 35, false);

// === ALERT INDICATOR ===
if (alert_timer > 0) {
    var _aa = clamp(alert_timer / 8.0, 0, 1);
    draw_set_alpha(_aa);
    draw_set_color(make_color_rgb(255, 60, 40));
    draw_rectangle(bx - 2, by - 60, bx + 2, by - 50, false);
    draw_rectangle(bx - 2, by - 48, bx + 2, by - 44, false);
    draw_set_alpha(1);
}

// === HIT FLASH ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 8, by - 5, bx + 8, by, false);
    draw_rectangle(bx - 7, by - 17, bx + 7, by - 5, false);
    draw_rectangle(bx - 9, by - 30, bx + 9, by - 17, false);
    draw_rectangle(bx - 5, by - 38, bx + 5, by - 30, false);
    draw_rectangle(bx - 6, by - 41, bx + 6, by - 36, false);
    draw_set_alpha(1);
}

// === MINIBOSS HP BAR (overhead, only once engaged) ===
if (alerted) {
    var _bw = 60;
    var _bx = bx - _bw / 2;
    var _by = by - 52;
    draw_set_color(c_dkgray);
    draw_rectangle(_bx, _by, _bx + _bw, _by + 6, false);
    draw_set_color(enraged ? make_color_rgb(230, 60, 30) : make_color_rgb(200, 40, 40));
    draw_rectangle(_bx, _by, _bx + _bw * (hp / max_hp), _by + 6, false);
    draw_set_color(c_white);
    draw_rectangle(_bx, _by, _bx + _bw, _by + 6, true);
}

draw_set_color(c_white);
