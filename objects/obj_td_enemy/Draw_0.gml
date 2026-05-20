// Enemy colours by type
var _body_col = make_color_rgb(60, 100, 60);   // basic = green
if (enemy_type == 1) _body_col = make_color_rgb(80, 55, 35);   // heavy = brown
if (enemy_type == 2) _body_col = make_color_rgb(140, 40, 40);  // elite = red

// Shadow
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.25);
draw_circle(x + 3, y + 4, 12, false);
draw_set_alpha(1);

// Body (helmet from above)
draw_set_color(_body_col);
draw_circle(x, y, 12, false);
draw_set_color(make_color_rgb(30, 30, 30));
draw_circle(x, y, 12, true);

// Direction indicator (small triangle pointing toward house)
var _house = instance_find(obj_td_house, 0);
if (_house != noone) {
    var _dir = point_direction(x, y, _house.x, _house.y);
    var _ax  = x + lengthdir_x(16, _dir);
    var _ay  = y + lengthdir_y(16, _dir);
    draw_set_color(make_color_rgb(220, 200, 120));
    draw_triangle(_ax, _ay,
        x + lengthdir_x(6, _dir - 120),
        y + lengthdir_y(6, _dir - 120),
        x + lengthdir_x(6, _dir + 120),
        y + lengthdir_y(6, _dir + 120), false);
}

// HP bar
var _pct = hp / max_hp;
var _bw  = 24;
draw_set_color(c_black);
draw_rectangle(x - _bw/2, y - 20, x + _bw/2, y - 14, false);
draw_set_color(make_color_rgb(40 + 180 * (1 - _pct), 180 * _pct, 40));
draw_rectangle(x - _bw/2, y - 20, x - _bw/2 + _bw * _pct, y - 14, false);

draw_set_color(c_white);
