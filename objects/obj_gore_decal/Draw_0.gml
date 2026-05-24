var _a = (life / max_life) * 0.80;
draw_set_alpha(_a);
draw_set_color(make_color_rgb(90, 0, 0));
draw_ellipse(x - w, y - h, x + w, y + h, false);
draw_set_color(make_color_rgb(55, 0, 0));
draw_ellipse(x - w * 0.55, y - h * 0.5, x + w * 0.55, y + h * 0.5, false);
draw_set_alpha(1);
draw_set_color(c_white);
