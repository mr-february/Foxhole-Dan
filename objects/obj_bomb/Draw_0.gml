if (exploding) {
    var prog = 1 - exp_timer / 22;
    var rad  = prog * 58;
    // Outer smoke ring
    draw_set_alpha(0.45 * (1 - prog));
    draw_set_color(make_color_rgb(85, 75, 65));
    draw_circle(x, y, rad * 1.6, false);
    // Fire
    draw_set_alpha(0.75 * (1 - prog * 0.7));
    draw_set_color(make_color_rgb(220, 95, 18));
    draw_circle(x, y, rad, false);
    // Inner flash
    draw_set_alpha(max(0, 0.9 - prog * 1.5));
    draw_set_color(make_color_rgb(255, 245, 110));
    draw_circle(x, y, rad * 0.42, false);
    draw_set_alpha(1);
} else {
    // Bomb body
    draw_set_color(make_color_rgb(55, 50, 35));
    draw_ellipse(x - 4, y - 9, x + 4, y - 3, false);
    draw_rectangle(x - 4, y - 5, x + 4, y + 5, false);
    // Nose tip
    draw_set_color(make_color_rgb(70, 64, 46));
    draw_ellipse(x - 3, y - 11, x + 3, y - 6, false);
    // Tail fins
    draw_set_color(make_color_rgb(40, 36, 25));
    draw_rectangle(x - 7, y + 3, x - 4, y + 8, false);
    draw_rectangle(x + 4, y + 3, x + 7, y + 8, false);
    draw_rectangle(x - 2, y + 5, x + 2, y + 10, false);
}
draw_set_color(c_white);
