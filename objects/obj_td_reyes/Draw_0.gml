var _t = current_time * 0.002;
var _house = instance_find(obj_td_house, 0);
var _dir   = (_house != noone) ? point_direction(x, y, _house.x, _house.y) : 270;
var _left  = _dir + 90;
var _right = _dir - 90;

// Pulsing threat aura (two rings)
draw_set_color(make_color_rgb(180, 20, 20));
draw_set_alpha(0.12 + 0.09 * abs(sin(_t * 3.1)));
draw_circle(x, y, 34, false);
draw_set_alpha(0.07 + 0.05 * abs(sin(_t * 2.2 + 1.4)));
draw_circle(x, y, 50, false);
draw_set_alpha(1);

// Drop shadow
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.42);
draw_ellipse(x - 18 + 5, y - 20 + 6, x + 18 + 5, y + 20 + 6, false);
draw_set_alpha(1);

// Tactical body armor (wider oval below helmet)
draw_set_color(make_color_rgb(22, 14, 14));
draw_ellipse(x - 13, y + 2, x + 13, y + 20, false);
draw_set_color(make_color_rgb(40, 22, 22));
draw_line(x - 10, y + 6, x + 10, y + 6);
draw_line(x -  8, y + 12, x +  8, y + 12);

// Shoulder epaulettes (rank marks)
draw_set_color(make_color_rgb(145, 18, 18));
var _el = 14;
draw_ellipse(
    x + lengthdir_x(_el, _left)  - 4, y + lengthdir_y(_el, _left)  - 4,
    x + lengthdir_x(_el, _left)  + 4, y + lengthdir_y(_el, _left)  + 4, false);
draw_ellipse(
    x + lengthdir_x(_el, _right) - 4, y + lengthdir_y(_el, _right) - 4,
    x + lengthdir_x(_el, _right) + 4, y + lengthdir_y(_el, _right) + 4, false);

// Command pistol (angled forward-right)
var _gdir = _dir - 35;
draw_set_color(make_color_rgb(18, 18, 24));
draw_line_width(
    x + lengthdir_x(8,  _gdir), y + lengthdir_y(8,  _gdir),
    x + lengthdir_x(24, _gdir), y + lengthdir_y(24, _gdir),
    4
);

// Commander helmet
draw_set_color(make_color_rgb(34, 20, 20));
draw_circle(x, y, 18, false);
draw_set_color(make_color_rgb(175, 28, 28));
draw_circle(x, y, 18, true);
draw_set_color(make_color_rgb(56, 30, 30));
draw_circle(x, y, 11, false);
// Rank star centre
draw_set_color(make_color_rgb(220, 60, 60));
draw_circle(x, y, 4, false);
// Helmet top-shine
var _hl_x = x + lengthdir_x(6, _dir - 42);
var _hl_y = y + lengthdir_y(6, _dir - 42);
draw_set_color(make_color_rgb(210, 110, 110));
draw_set_alpha(0.32);
draw_circle(_hl_x, _hl_y, 4, false);
draw_set_alpha(1);

// Direction arrow toward house
if (_house != noone) {
    var _ax = x + lengthdir_x(25, _dir);
    var _ay = y + lengthdir_y(25, _dir);
    draw_set_color(make_color_rgb(255, 80, 80));
    draw_triangle(_ax, _ay,
        x + lengthdir_x(10, _dir - 130), y + lengthdir_y(10, _dir - 130),
        x + lengthdir_x(10, _dir + 130), y + lengthdir_y(10, _dir + 130),
        false);
}

// Name tag
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(220, 60, 60));
draw_text_transformed(x, y - 38, "REYES", 0.90, 0.90, 0);

// HP bar (wider, boss-style)
var _pct = hp / max_hp;
var _bw  = 68;
draw_set_color(c_black);
draw_rectangle(x - _bw/2 - 1, y - 56, x + _bw/2 + 1, y - 46, false);
draw_set_color(make_color_rgb(200 + 55 * (1 - _pct), 40 * _pct, 40 * _pct));
draw_rectangle(x - _bw/2, y - 55, x - _bw/2 + _bw * _pct, y - 47, false);
draw_set_color(make_color_rgb(200, 60, 60));
draw_rectangle(x - _bw/2 - 1, y - 56, x + _bw/2 + 1, y - 46, true);

draw_set_halign(fa_left);
// Hit flash
if (hit_flash > 0) {
    hit_flash--;
    draw_set_alpha(0.60 * (hit_flash / 10.0));
    draw_set_color(c_white);
    draw_circle(x, y, 26, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
