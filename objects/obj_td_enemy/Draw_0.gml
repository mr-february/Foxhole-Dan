var _house = instance_find(obj_td_house, 0);
var _dir   = (_house != noone) ? point_direction(x, y, _house.x, _house.y) : 270;
var _left  = _dir + 90;
var _right = _dir - 90;

// Type-based palette and size
var _helm_r, _body_r, _helm_col, _body_col, _trim_col, _weap_col;
switch (enemy_type) {
    case 1:   // Heavy — brown, larger
        _helm_r   = 11;  _body_r = 8;
        _helm_col = make_color_rgb(80, 56, 30);
        _body_col = make_color_rgb(94, 68, 38);
        _trim_col = make_color_rgb(54, 38, 18);
        _weap_col = make_color_rgb(38, 28, 16);
        break;
    case 2:   // Elite — dark red/black
        _helm_r   = 10;  _body_r = 7;
        _helm_col = make_color_rgb(102, 26, 26);
        _body_col = make_color_rgb(72,  16, 16);
        _trim_col = make_color_rgb(44,   8,  8);
        _weap_col = make_color_rgb(36,  36, 42);
        break;
    default:  // Basic — field green
        _helm_r   = 9;   _body_r = 6;
        _helm_col = make_color_rgb(50, 76, 38);
        _body_col = make_color_rgb(60, 92, 46);
        _trim_col = make_color_rgb(34, 54, 24);
        _weap_col = make_color_rgb(44, 32, 16);
}

// Shadow
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.26);
draw_ellipse(x - _helm_r + 3, y - _helm_r + 5, x + _helm_r + 3, y + _helm_r + 5, false);
draw_set_alpha(1);

// Rifle barrel (extends forward from helmet edge)
var _wlen = _helm_r + 9;
draw_set_color(_weap_col);
draw_line_width(
    x + lengthdir_x(_helm_r - 2, _dir), y + lengthdir_y(_helm_r - 2, _dir),
    x + lengthdir_x(_helm_r + _wlen, _dir), y + lengthdir_y(_helm_r + _wlen, _dir),
    (enemy_type == 1) ? 4 : 3
);

// Torso (oval, offset back from helmet center)
var _bx = x + lengthdir_x(4, _dir + 180);
var _by = y + lengthdir_y(4, _dir + 180);
draw_set_color(_body_col);
draw_ellipse(_bx - _body_r, _by - _body_r * 1.25, _bx + _body_r, _by + _body_r * 1.25, false);
draw_set_color(_trim_col);
draw_set_alpha(0.5);
draw_ellipse(_bx - _body_r, _by - _body_r * 1.25, _bx + _body_r, _by - _body_r * 0.2, false);
draw_set_alpha(1);

// Arms (stubs to left and right of torso)
var _al = _body_r + 4;
draw_set_color(_body_col);
draw_line_width(_bx, _by, _bx + lengthdir_x(_al, _left),  _by + lengthdir_y(_al, _left),  3);
draw_line_width(_bx, _by, _bx + lengthdir_x(_al, _right), _by + lengthdir_y(_al, _right), 3);

// Helmet fill
draw_set_color(_helm_col);
draw_circle(x, y, _helm_r, false);
// Helmet rim
draw_set_color(_trim_col);
draw_circle(x, y, _helm_r, true);
// Helmet top-shine
var _hl_x = x + lengthdir_x(_helm_r * 0.38, _dir - 38);
var _hl_y = y + lengthdir_y(_helm_r * 0.38, _dir - 38);
draw_set_color(make_color_rgb(
    min(color_get_red(_helm_col)   + 38, 255),
    min(color_get_green(_helm_col) + 38, 255),
    min(color_get_blue(_helm_col)  + 38, 255)
));
draw_set_alpha(0.42);
draw_circle(_hl_x, _hl_y, _helm_r * 0.30, false);
draw_set_alpha(1);

// Elite: red command stripe across helmet
if (enemy_type == 2) {
    draw_set_color(make_color_rgb(200, 45, 45));
    draw_set_alpha(0.72);
    draw_line_width(
        x + lengthdir_x(_helm_r, _left),  y + lengthdir_y(_helm_r, _left),
        x + lengthdir_x(_helm_r, _right), y + lengthdir_y(_helm_r, _right),
        3
    );
    draw_set_alpha(1);
}

// HP bar
var _pct = hp / max_hp;
var _bw  = 26;
var _byt = y - _helm_r - 10;
draw_set_color(c_black);
draw_rectangle(x - _bw/2 - 1, _byt - 1, x + _bw/2 + 1, _byt + 6, false);
draw_set_color(make_color_rgb(40 + 180 * (1 - _pct), 180 * _pct, 40));
draw_rectangle(x - _bw/2, _byt, x - _bw/2 + _bw * _pct, _byt + 5, false);

// Hit flash
if (hit_flash > 0) {
    hit_flash--;
    draw_set_alpha(0.55 * (hit_flash / 8.0));
    draw_set_color(c_white);
    draw_circle(x, y, _helm_r + 4, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
