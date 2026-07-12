var bx = x, by = y;

switch (target_type) {
    case 0: // TROOP
        draw_set_color(make_color_rgb(48, 56, 36));
        draw_rectangle(bx - 6, by - 20, bx + 6, by, false);
        draw_set_color(make_color_rgb(176, 142, 108));
        draw_rectangle(bx - 4, by - 28, bx + 4, by - 20, false);
        draw_set_color(make_color_rgb(30, 34, 24));
        draw_rectangle(bx - 5, by - 30, bx + 5, by - 25, false);
    break;
    case 1: // TECHNICAL (gun truck)
        draw_set_color(make_color_rgb(60, 54, 40));
        draw_rectangle(bx - 26, by - 18, bx + 26, by, false);
        draw_set_color(make_color_rgb(40, 36, 28));
        draw_circle(bx - 16, by, 7, false); draw_circle(bx + 16, by, 7, false);
        draw_set_color(make_color_rgb(30, 30, 28));
        draw_line_width(bx, by - 18, bx + 20, by - 26, 3);   // mounted MG
    break;
    case 2: // RPG TEAM
        draw_set_color(make_color_rgb(52, 60, 40));
        draw_rectangle(bx - 8, by - 20, bx + 4, by, false);
        draw_set_color(make_color_rgb(176, 142, 108));
        draw_rectangle(bx - 6, by - 28, bx + 2, by - 20, false);
        draw_set_color(make_color_rgb(24, 22, 18));
        draw_line_width(bx - 4, by - 22, bx + 22, by - 30, 4);  // launcher tube
        draw_set_color(make_color_rgb(200, 60, 40));
        draw_circle(bx + 22, by - 30, 3, false);
    break;
    case 3: // ENEMY CHOPPER
        draw_set_color(make_color_rgb(40, 44, 42));
        draw_ellipse(bx - 26, by - 10, bx + 22, by + 10, false);
        draw_rectangle(bx + 18, by - 3, bx + 44, by + 3, false);   // tail boom
        draw_set_color(make_color_rgb(70, 74, 72));
        var r = current_time * 0.04;
        draw_line_width(bx - 4 + cos(r) * 34, by - 16, bx - 4 - cos(r) * 34, by - 16, 2);  // rotor
    break;
}

// Hit flash
if (hit_flash > 0) {
    draw_set_alpha(0.6); draw_set_color(c_white);
    draw_rectangle(bx - 20, by - 26, bx + 20, by, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
