// Rope from Dan's shoulder to the hook
if (owner != noone && instance_exists(owner)) {
    var ox   = owner.x;
    var oy   = owner.y - 16;
    var dist = point_distance(ox, oy, x, y);
    var mx   = (ox + x) * 0.5;
    var my   = (oy + y) * 0.5 + dist * 0.08;  // catenary sag
    draw_set_color(make_color_rgb(160, 130, 55));
    draw_line_width(ox, oy, mx, my, 2);
    draw_line_width(mx, my, x, y, 2);
}

// Hook head — gold when lodged, light grey in flight
draw_set_color(lodged ? make_color_rgb(255, 200, 50) : make_color_rgb(210, 205, 180));
draw_circle(x, y, lodged ? 5 : 3, false);
draw_set_color(make_color_rgb(80, 70, 40));
draw_circle(x, y, lodged ? 5 : 3, true);
draw_set_color(c_white);
