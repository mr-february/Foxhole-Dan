// === DOOR-GUN FOREGROUND FRAME (fixed, upper-left cabin) ===
// A tiny rotor-driven vibration sells "in flight" without touching real x/y.
var _bob = sin(rotor * 2) * 1.2;
var bx = x, by = y + _bob;

// --- Fuselage roof + rotor mast, spinning rotor disc up top ---
draw_set_color(make_color_rgb(46, 50, 46));
draw_rectangle(bx - 80, by - 96, bx + 40, by - 40, false);         // roof beam
draw_set_color(make_color_rgb(30, 33, 30));
draw_rectangle(bx - 24, by - 112, bx - 16, by - 96, false);        // rotor mast

// Rotor blades — two long blades spinning around the mast, plus a faint
// motion-blur disc so it always reads as "spinning" even at low framerate.
var _rhx = bx - 20, _rhy = by - 112;
draw_set_alpha(0.16);
draw_set_color(make_color_rgb(20, 20, 20));
draw_circle(_rhx, _rhy, 130, false);
draw_set_alpha(1);
for (var _bi = 0; _bi < 2; _bi++) {
    var _bang = rotor + _bi * 180;
    draw_set_color(make_color_rgb(18, 18, 18));
    draw_line_width(_rhx - lengthdir_x(130, _bang), _rhy - lengthdir_y(130, _bang) * 0.28,
                     _rhx + lengthdir_x(130, _bang), _rhy + lengthdir_y(130, _bang) * 0.28, 4);
}
draw_set_color(make_color_rgb(50, 50, 46));
draw_circle(_rhx, _rhy, 6, false);

// Cabin frame / door edge
draw_set_color(make_color_rgb(38, 42, 40));
draw_rectangle(bx - 60, by - 40, bx + 20, by + 70, false);
draw_set_color(make_color_rgb(52, 56, 54));
draw_rectangle(bx - 60, by - 40, bx - 44, by + 70, false);   // door pillar
draw_set_color(make_color_rgb(30, 33, 30));
draw_rectangle(bx - 80, by + 70, bx + 40, by + 92, false);   // floor / skid line

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
