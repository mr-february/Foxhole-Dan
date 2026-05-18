var bx = x;
var by = y;
var f  = facing;
var pa = current_time * 0.04 * f;   // prop animation angle

// === SMOKE TRAIL when damaged ===
if (hp < max_hp * 0.5) {
    var sm = 0.35 * (1 - hp / (max_hp * 0.5));
    draw_set_alpha(sm);
    draw_set_color(make_color_rgb(75, 68, 60));
    draw_circle(bx - f * 24 + sin(current_time * 0.025) * 5, by - 2, 7 + abs(sin(current_time * 0.04)) * 5, false);
    draw_set_alpha(1);
}

// === UPPER WING (biplane) ===
draw_set_color(make_color_rgb(65, 70, 55));
draw_rectangle(bx - 22, by - 15, bx + 22, by - 10, false);
// Wing struts
draw_set_color(make_color_rgb(48, 52, 40));
draw_line_width(bx - 11, by - 10, bx - 13, by + 2, 1);
draw_line_width(bx + 11, by - 10, bx + 13, by + 2, 1);

// === FUSELAGE ===
draw_set_color(make_color_rgb(72, 78, 60));
draw_rectangle(bx - 26, by - 6, bx + 26, by + 6, false);
// Top highlight
draw_set_color(make_color_rgb(92, 98, 78));
draw_rectangle(bx - 25, by - 6, bx + 24, by - 4, false);
// Bottom shadow
draw_set_color(make_color_rgb(48, 52, 40));
draw_rectangle(bx - 25, by + 4, bx + 24, by + 6, false);

// === LOWER WING ===
draw_set_color(make_color_rgb(65, 70, 55));
draw_rectangle(bx - 18, by + 2, bx + 18, by + 8, false);

// === TAIL ===
draw_set_color(make_color_rgb(62, 68, 52));
draw_rectangle(bx - f * 26, by - 12, bx - f * 17, by - 6, false);   // vertical fin
draw_rectangle(bx - f * 25, by + 5,  bx - f * 14, by + 10, false);  // horizontal stab

// === ENGINE + PROP ===
draw_set_color(make_color_rgb(50, 48, 42));
draw_circle(bx + f * 24, by, 6, false);
draw_set_color(make_color_rgb(32, 30, 26));
draw_circle(bx + f * 28, by, 3, false);
// Propeller blades (spin)
draw_set_color(make_color_rgb(28, 26, 22));
draw_line_width(bx + f*30 + cos(pa)*14, by + sin(pa)*10, bx + f*30 - cos(pa)*14, by - sin(pa)*10, 2);
draw_line_width(bx + f*30 + cos(pa + pi*0.5)*10, by + sin(pa + pi*0.5)*8,
                bx + f*30 - cos(pa + pi*0.5)*10, by - sin(pa + pi*0.5)*8, 2);

// === COCKPIT ===
draw_set_color(make_color_rgb(65, 108, 138));
draw_rectangle(bx + f*6, by - 9, bx + f*16, by - 4, false);
draw_set_color(make_color_rgb(115, 165, 195));
draw_rectangle(bx + f*7, by - 8, bx + f*12, by - 6, false);

// === BOMB (hanging) ===
draw_set_color(make_color_rgb(52, 48, 35));
draw_rectangle(bx - 3, by + 8, bx + 3, by + 15, false);
draw_rectangle(bx - 5, by + 13, bx + 5, by + 17, false);

// === HIT FLASH ===
if (hit_flash > 0) {
    draw_set_alpha(0.55);
    draw_set_color(c_white);
    draw_rectangle(bx - 30, by - 18, bx + 34, by + 18, false);
    draw_set_alpha(1);
}

// === HP BAR (above plane) ===
var hp_pct = hp / max_hp;
draw_set_color(c_dkgray);
draw_rectangle(bx - 24, by - 26, bx + 24, by - 22, false);
draw_set_color(make_color_rgb(40, 200, 55));
draw_rectangle(bx - 24, by - 26, bx - 24 + 48 * hp_pct, by - 22, false);
draw_set_color(c_white);
draw_rectangle(bx - 24, by - 26, bx + 24, by - 22, true);

draw_set_color(c_white);
