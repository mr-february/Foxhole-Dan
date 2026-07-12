// === PARAPET + SNIPER (fixed nest, bottom-left rooftop) ===
var bx = nest_x, by = nest_y;

// Sandbag parapet
draw_set_color(make_color_rgb(70, 66, 52));
draw_rectangle(bx - 40, by, bx + 40, by + 60, false);
draw_set_color(make_color_rgb(84, 80, 64));
for (var s = 0; s < 3; s++) draw_ellipse(bx - 40 + s * 28, by - 4, bx - 16 + s * 28, by + 12, false);

// Dan prone behind the rifle
draw_set_color(make_color_rgb(52, 62, 40));
draw_rectangle(bx - 30, by - 14, bx + 6, by, false);           // body
draw_set_color(make_color_rgb(180, 148, 112));
draw_rectangle(bx + 2, by - 18, bx + 12, by - 8, false);        // head
draw_set_color(make_color_rgb(44, 52, 34));
draw_rectangle(bx + 1, by - 20, bx + 13, by - 15, false);       // boonie

// Rifle pointed toward the aim
var ang = point_direction(bx + 10, by - 20, aim_x, aim_y);
draw_set_color(make_color_rgb(24, 22, 18));
draw_line_width(bx + 10, by - 20, bx + 10 + lengthdir_x(40, ang), by - 20 + lengthdir_y(40, ang), 3);

// === RETICLE (world-space, when NOT scoped; scoped reticle is drawn in the controller GUI) ===
if (!scoped) {
    draw_set_color(make_color_rgb(255, 60, 60));
    draw_line(aim_x - 12, aim_y, aim_x - 4, aim_y);
    draw_line(aim_x + 4, aim_y, aim_x + 12, aim_y);
    draw_line(aim_x, aim_y - 12, aim_x, aim_y - 4);
    draw_line(aim_x, aim_y + 4, aim_x, aim_y + 12);
    draw_circle(aim_x, aim_y, 2, false);
}
draw_set_color(c_white);
