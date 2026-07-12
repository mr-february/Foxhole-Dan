var _house = instance_find(obj_td_house, 0);
var _dir   = (_house != noone) ? point_direction(x, y, _house.x, _house.y) : 270;

// Direction unit vectors (forward = toward house, side = perpendicular)
var _fwd_x = dcos(_dir);      var _fwd_y = -dsin(_dir);
var _sid_x = dcos(_dir + 90); var _sid_y = -dsin(_dir + 90);

// Type-based palette — matching Room1 enemy soldier RGB values exactly
var _helm_col, _body_col, _trim_col, _boot_col, _weap_col, _helm_r, _body_r;
switch (enemy_type) {
    case 1:   // Heavy — brown, larger
        _helm_col = make_color_rgb(28, 20, 12);
        _body_col = make_color_rgb(94, 68, 38);
        _trim_col = make_color_rgb(54, 38, 18);
        _boot_col = make_color_rgb(20, 14, 8);
        _weap_col = make_color_rgb(38, 28, 16);
        _helm_r = 11; _body_r = 8;
        break;
    case 2:   // Elite — dark red/black
        _helm_col = make_color_rgb(60, 14, 14);
        _body_col = make_color_rgb(72, 16, 16);
        _trim_col = make_color_rgb(120, 30, 30);
        _boot_col = make_color_rgb(22, 8, 8);
        _weap_col = make_color_rgb(36, 36, 42);
        _helm_r = 10; _body_r = 7;
        break;
    default:  // Basic — field green (same as Room1 obj_enemy_soldier)
        _helm_col = make_color_rgb(28, 30, 28);
        _body_col = make_color_rgb(42, 50, 35);
        _trim_col = make_color_rgb(25, 28, 20);
        _boot_col = make_color_rgb(20, 15, 10);
        _weap_col = make_color_rgb(25, 22, 18);
        _helm_r = 9; _body_r = 6;
}

// Walk animation — phased by id so enemies don't bob in sync
var _wt   = current_time * 0.018 + id * 1.7;
var _lleg = sin(_wt)      * 2.5;   // left boot lateral swing
var _rleg = sin(_wt + pi) * 2.5;   // right boot (opposite phase)

// Helmet center — positioned slightly forward of origin
var _hx = x + _fwd_x * (_helm_r * 0.4);
var _hy = y + _fwd_y * (_helm_r * 0.4);

// === SHADOW ===
draw_set_color(c_black);
draw_set_alpha(0.26);
draw_ellipse(_hx - _helm_r + 3, _hy - _helm_r + 5, _hx + _helm_r + 3, _hy + _helm_r + 5, false);
draw_set_alpha(1);

// === GUN BARREL (extends forward from helmet edge, offset to one side) ===
var _wlen = _helm_r + 10;
draw_set_color(_weap_col);
draw_line_width(
    _hx + _fwd_x * (_helm_r - 2) + _sid_x * 3.0,
    _hy + _fwd_y * (_helm_r - 2) + _sid_y * 3.0,
    _hx + _fwd_x * (_helm_r + _wlen) + _sid_x * 3.0,
    _hy + _fwd_y * (_helm_r + _wlen) + _sid_y * 3.0,
    (enemy_type == 1) ? 4 : 3
);

// === BODY — thick oriented line from helmet edge backward ===
draw_set_color(_body_col);
draw_line_width(
    _hx - _fwd_x * (_helm_r - 2), _hy - _fwd_y * (_helm_r - 2),
    _hx - _fwd_x * (_helm_r + 11), _hy - _fwd_y * (_helm_r + 11),
    _body_r * 2.0
);

// Belt stripe across body centre (matches Room1 belt)
draw_set_color(_trim_col);
draw_set_alpha(0.70);
var _belt_x = _hx - _fwd_x * (_helm_r + 4);
var _belt_y = _hy - _fwd_y * (_helm_r + 4);
draw_line_width(
    _belt_x + _sid_x * (_body_r - 1), _belt_y + _sid_y * (_body_r - 1),
    _belt_x - _sid_x * (_body_r - 1), _belt_y - _sid_y * (_body_r - 1),
    2
);
draw_set_alpha(1);

// === ARMS (stubs each side of torso, like Room1) ===
var _arm_x = _hx - _fwd_x * (_helm_r + 5);
var _arm_y = _hy - _fwd_y * (_helm_r + 5);
var _al = _body_r + 4;
draw_set_color(_body_col);
draw_line_width(_arm_x, _arm_y, _arm_x + _sid_x * _al, _arm_y + _sid_y * _al, 3);
draw_line_width(_arm_x, _arm_y, _arm_x - _sid_x * _al, _arm_y - _sid_y * _al, 3);

// === BOOTS (two circles at rear with walk animation) ===
var _rear_x = _hx - _fwd_x * (_helm_r + 13);
var _rear_y = _hy - _fwd_y * (_helm_r + 13);
var _boot_r = max(3, _body_r * 0.55);
draw_set_color(_boot_col);
draw_circle(
    _rear_x + _sid_x * (_body_r * 0.55 + _lleg * 0.4),
    _rear_y + _sid_y * (_body_r * 0.55 + _lleg * 0.4),
    _boot_r, false
);
draw_circle(
    _rear_x - _sid_x * (_body_r * 0.55 + _rleg * 0.4),
    _rear_y - _sid_y * (_body_r * 0.55 + _rleg * 0.4),
    _boot_r, false
);

// === HELMET fill ===
draw_set_color(_helm_col);
draw_circle(_hx, _hy, _helm_r, false);
// Helmet rim
draw_set_color(_trim_col);
draw_circle(_hx, _hy, _helm_r, true);
// Helmet top-shine
var _hl_x = _hx + _fwd_x * (_helm_r * 0.36) + _sid_x * (_helm_r * 0.22);
var _hl_y = _hy + _fwd_y * (_helm_r * 0.36) + _sid_y * (_helm_r * 0.22);
draw_set_color(make_color_rgb(
    min(color_get_red(_helm_col)   + 38, 255),
    min(color_get_green(_helm_col) + 38, 255),
    min(color_get_blue(_helm_col)  + 38, 255)
));
draw_set_alpha(0.42);
draw_circle(_hl_x, _hl_y, _helm_r * 0.30, false);
draw_set_alpha(1);

// Red star insignia — cross shape matching Room1 enemy helmet star
draw_set_color(make_color_rgb(180, 20, 20));
draw_line_width(
    _hx - _sid_x * 2.5, _hy - _sid_y * 2.5,
    _hx + _sid_x * 2.5, _hy + _sid_y * 2.5, 2.2);
draw_line_width(
    _hx - _fwd_x * 2.5, _hy - _fwd_y * 2.5,
    _hx + _fwd_x * 2.5, _hy + _fwd_y * 2.5, 2.2);

// Elite: red command stripe across helmet
if (enemy_type == 2) {
    draw_set_color(make_color_rgb(200, 45, 45));
    draw_set_alpha(0.72);
    draw_line_width(
        _hx + _sid_x * _helm_r, _hy + _sid_y * _helm_r,
        _hx - _sid_x * _helm_r, _hy - _sid_y * _helm_r,
        3
    );
    draw_set_alpha(1);
}

// === HP BAR ===
var _pct = hp / max_hp;
var _bw  = 26;
var _byt = _hy - _helm_r - 10;
draw_set_color(c_black);
draw_rectangle(_hx - _bw/2 - 1, _byt - 1, _hx + _bw/2 + 1, _byt + 6, false);
draw_set_color(make_color_rgb(40 + 180 * (1 - _pct), 180 * _pct, 40));
draw_rectangle(_hx - _bw/2, _byt, _hx - _bw/2 + _bw * _pct, _byt + 6, false);

// Hit flash
if (hit_flash > 0) {
    hit_flash--;
    draw_set_alpha(0.55 * (hit_flash / 8.0));
    draw_set_color(c_white);
    draw_circle(_hx, _hy, _helm_r + 4, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
