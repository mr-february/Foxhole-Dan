var a  = clamp(life / 55, 0, 1);
var sc = 1.0 + (1 - a) * 0.4;   // pops big then shrinks slightly

draw_set_alpha(a);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Shadow
draw_set_color(make_color_rgb(80, 0, 0));
draw_text_transformed(x + 1, y - rise + 1, "-" + string(amount), sc, sc, 0);

// Main number — bright red/orange
draw_set_color(make_color_rgb(255, 70, 40));
draw_text_transformed(x, y - rise, "-" + string(amount), sc, sc, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
