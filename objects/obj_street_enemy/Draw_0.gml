var bx = x, by = y;
var duck = in_cover ? 8 : 0;                         // crouch in cover
var step = in_cover ? 0 : sin(bob) * 3;              // marching bob

// Legs
draw_set_color(make_color_rgb(40, 46, 30));
draw_rectangle(bx - 7, by - 18 + duck, bx - 1, by, false);
draw_rectangle(bx + 1, by - 18 + duck, bx + 7, by, false);
// Torso
draw_set_color(make_color_rgb(56, 64, 42));
draw_rectangle(bx - 9, by - 34 + duck + step, bx + 9, by - 16 + duck, false);
// Head + helmet
draw_set_color(make_color_rgb(180, 148, 112));
draw_rectangle(bx - 5, by - 44 + duck + step, bx + 5, by - 34 + duck + step, false);
draw_set_color(make_color_rgb(38, 44, 28));
draw_rectangle(bx - 6, by - 46 + duck + step, bx + 6, by - 41 + duck + step, false);
// Rifle toward the nest
draw_set_color(make_color_rgb(22, 20, 16));
draw_line_width(bx - 8, by - 26 + duck, bx - 24, by - 27 + duck, 2);
// Muzzle flash while suppressing
if (in_cover && suppress_timer > suppress_cd - 6) {
    draw_set_color(make_color_rgb(255, 220, 120));
    draw_circle(bx - 26, by - 27 + duck, 4, false);
}

// Hit flash
if (hit_flash > 0) {
    draw_set_alpha(0.65); draw_set_color(c_white);
    draw_rectangle(bx - 9, by - 34 + duck, bx + 9, by, false);
    draw_rectangle(bx - 5, by - 44 + duck, bx + 5, by - 34 + duck, false);
    draw_set_alpha(1);
}
draw_set_color(c_white);
