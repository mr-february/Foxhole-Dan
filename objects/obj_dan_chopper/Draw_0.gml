// === DOOR-GUN FOREGROUND FRAME (fixed, upper-left cabin) ===
var bx = x, by = y;

// Cabin frame / door edge
draw_set_color(make_color_rgb(38, 42, 40));
draw_rectangle(bx - 60, by - 40, bx + 20, by + 70, false);
draw_set_color(make_color_rgb(52, 56, 54));
draw_rectangle(bx - 60, by - 40, bx - 44, by + 70, false);   // door pillar

// Gunner
draw_set_color(make_color_rgb(50, 58, 38));
draw_rectangle(bx - 34, by - 6, bx - 12, by + 34, false);     // torso
draw_set_color(make_color_rgb(176, 142, 108));
draw_ellipse(bx - 30, by - 22, bx - 14, by - 6, false);       // helmet head
draw_set_color(make_color_rgb(30, 34, 30));
draw_ellipse(bx - 31, by - 24, bx - 13, by - 10, false);      // flight helmet

// The door gun, tracking the aim
var ang = point_direction(bx + 18, by + 30, aim_x, aim_y);
draw_set_color(make_color_rgb(28, 26, 22));
draw_line_width(bx - 6, by + 18, bx + 18 + lengthdir_x(46, ang), by + 30 + lengthdir_y(46, ang), 5);
draw_set_color(make_color_rgb(60, 58, 54));
draw_rectangle(bx - 10, by + 10, bx + 6, by + 26, false);     // receiver

// === RETICLE ===
draw_set_color(make_color_rgb(255, 90, 60));
draw_circle(aim_x, aim_y, 16, true);
draw_line(aim_x - 22, aim_y, aim_x - 8, aim_y);
draw_line(aim_x + 8, aim_y, aim_x + 22, aim_y);
draw_line(aim_x, aim_y - 22, aim_x, aim_y - 8);
draw_line(aim_x, aim_y + 8, aim_x, aim_y + 22);
draw_set_color(c_white);
