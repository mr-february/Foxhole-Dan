if (is_aoe) {
    // Artillery shell — orange circle
    draw_set_color(make_color_rgb(255, 140, 30));
    draw_circle(x, y, 5, false);
    draw_set_color(make_color_rgb(200, 80, 20));
    draw_circle(x, y, 5, true);
} else {
    // MG bullet — small yellow dot with tracer line
    if (instance_exists(target)) {
        draw_set_color(make_color_rgb(255, 220, 80));
        draw_set_alpha(0.35);
        draw_line(x, y, target.x, target.y);
        draw_set_alpha(1);
    }
    draw_set_color(make_color_rgb(255, 240, 120));
    draw_circle(x, y, 3, false);
}
draw_set_color(c_white);
