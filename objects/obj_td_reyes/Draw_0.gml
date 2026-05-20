var _t = current_time * 0.002;

// Pulsing threat aura
draw_set_color(make_color_rgb(180, 20, 20));
draw_set_alpha(0.15 + 0.10 * abs(sin(_t * 3)));
draw_circle(x, y, 28, false);
draw_set_alpha(1);

// Shadow
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.35);
draw_circle(x + 4, y + 5, 17, false);
draw_set_alpha(1);

// Body (commander helmet)
draw_set_color(make_color_rgb(40, 30, 30));
draw_circle(x, y, 17, false);
draw_set_color(make_color_rgb(180, 30, 30));
draw_circle(x, y, 17, true);

// Inner detail
draw_set_color(make_color_rgb(80, 50, 50));
draw_circle(x, y, 10, false);

// Direction arrow toward house
var _house = instance_find(obj_td_house, 0);
if (_house != noone) {
    var _dir = point_direction(x, y, _house.x, _house.y);
    var _ax  = x + lengthdir_x(22, _dir);
    var _ay  = y + lengthdir_y(22, _dir);
    draw_set_color(make_color_rgb(255, 80, 80));
    draw_triangle(_ax, _ay,
        x + lengthdir_x(8, _dir - 130),
        y + lengthdir_y(8, _dir - 130),
        x + lengthdir_x(8, _dir + 130),
        y + lengthdir_y(8, _dir + 130), false);
}

// Name tag
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(220, 60, 60));
draw_text_transformed(x, y - 34, "REYES", 0.90, 0.90, 0);

// HP bar (wider, more prominent)
var _pct = hp / max_hp;
var _bw  = 60;
draw_set_color(c_black);
draw_rectangle(x - _bw/2, y - 50, x + _bw/2, y - 42, false);
draw_set_color(make_color_rgb(200 + 55 * (1 - _pct), 40 * _pct, 40 * _pct));
draw_rectangle(x - _bw/2, y - 50, x - _bw/2 + _bw * _pct, y - 42, false);
draw_set_color(make_color_rgb(200, 60, 60));
draw_rectangle(x - _bw/2, y - 50, x + _bw/2, y - 42, true);

draw_set_halign(fa_left);
draw_set_color(c_white);
