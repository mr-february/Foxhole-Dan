var bx = x;
var by = y;
var f  = image_xscale;   // facing set by Step

// Health bleed — redder at low HP
var hurt = 1 - (hp / max_hp);

// Frantic scramble animation
var spd_ratio = clamp(abs(hspd) / move_spd, 0, 1);
var wp        = current_time * 0.022;   // faster, panicked gait
var leg_swing = sin(wp) * 6 * spd_ratio;
var body_bob  = abs(sin(wp)) * 2 * spd_ratio;

var bl_y = -leg_swing * 0.4;
var br_y =  leg_swing * 0.4;
var bob_off = body_bob;

// Hunched forward lean while rushing
var lean = f * 2 * spd_ratio;

// === BOOTS ===
draw_set_color(make_color_rgb(20, 15, 10));
draw_rectangle(bx - 7, by - 5 + bl_y, bx + 1, by + bl_y, false);
draw_rectangle(bx + 1, by - 5 + br_y, bx + 7, by + br_y, false);

// === PANTS ===
draw_set_color(make_color_rgb(round(40 + hurt * 60), round(42 + hurt * 5), round(38 - hurt * 15)));
draw_rectangle(bx - 6, by - 14 + bl_y, bx + 1, by - 5 + bl_y, false);
draw_rectangle(bx + 1, by - 14 + br_y, bx + 6, by - 5 + br_y, false);

// === SATCHEL CHARGE (huge pack on the back — the silhouette) ===
draw_set_color(make_color_rgb(64, 52, 30));
draw_rectangle(bx - f * 16 + lean, by - 30 + bob_off, bx - f * 5 + lean, by - 12 + bob_off, false);
// Straps
draw_set_color(make_color_rgb(28, 24, 16));
draw_rectangle(bx - f * 15 + lean, by - 26 + bob_off, bx - f * 6 + lean, by - 24 + bob_off, false);
draw_rectangle(bx - f * 15 + lean, by - 18 + bob_off, bx - f * 6 + lean, by - 16 + bob_off, false);
// Wires curling off the pack
draw_set_color(make_color_rgb(140, 40, 30));
draw_line(bx - f * 14 + lean, by - 30 + bob_off, bx - f * 17 + lean, by - 35 + bob_off);
draw_line(bx - f * 9 + lean,  by - 30 + bob_off, bx - f * 11 + lean, by - 36 + bob_off);

// === TORSO (skinny — dwarfed by the pack) ===
draw_set_color(make_color_rgb(round(48 + hurt * 80), round(52 + hurt * 10), round(36 - hurt * 20)));
draw_rectangle(bx - 5 + lean, by - 25 + bob_off, bx + 6 + lean, by - 14 + bob_off, false);

// === ARMS clutching the detonator in front ===
draw_set_color(make_color_rgb(round(44 + hurt * 60), round(48 + hurt * 8), 34));
draw_rectangle(bx + f * 4 + lean, by - 22 + bob_off, bx + f * 11 + lean, by - 18 + bob_off, false);
// Detonator box
draw_set_color(make_color_rgb(30, 30, 32));
draw_rectangle(bx + f * 10 + lean, by - 24 + bob_off, bx + f * 15 + lean, by - 18 + bob_off, false);

// === HEAD (bare — no helmet, wild) ===
var hx = bx + lean + f;
var hy = by - 33 + bob_off;
draw_set_color(make_color_rgb(170, 118, 80));
draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
// Matted hair
draw_set_color(make_color_rgb(40, 30, 20));
draw_rectangle(hx - 5, hy - 2, hx + 5, hy + 2, false);
// Wide desperate eye
draw_set_color(make_color_rgb(230, 225, 215));
draw_rectangle(hx + f * 1, hy + 3, hx + f * 4, hy + 5, false);
draw_set_color(make_color_rgb(20, 14, 12));
draw_rectangle(hx + f * 2, hy + 3, hx + f * 3, hy + 5, false);

// === ARMED — blinking detonator light + red pulse overlay ===
if (winding) {
    var blink = ((wind_timer div 4) % 2 == 0);
    // Detonator lamp
    draw_set_color(blink ? make_color_rgb(255, 60, 40) : make_color_rgb(90, 20, 14));
    draw_rectangle(bx + f * 11 + lean, by - 27 + bob_off, bx + f * 14 + lean, by - 24 + bob_off, false);
    // Whole-body warning pulse, faster as the timer runs out
    if (blink) {
        draw_set_alpha(0.45 + 0.35 * (1 - wind_timer / 30));
        draw_set_color(make_color_rgb(255, 70, 40));
        draw_rectangle(bx - 16 + lean, by - 36, bx + 16 + lean, by, false);
        draw_set_alpha(1);
    }
}

// === HIT FLASH — redraw sapper silhouette in white ===
if (hit_flash > 0) {
    draw_set_alpha(0.65);
    draw_set_color(c_white);
    draw_rectangle(bx - 7, by - 5 + bl_y, bx + 1, by + bl_y, false);
    draw_rectangle(bx + 1, by - 5 + br_y, bx + 7, by + br_y, false);
    draw_rectangle(bx - 6, by - 14 + bl_y, bx + 1, by - 5 + bl_y, false);
    draw_rectangle(bx + 1, by - 14 + br_y, bx + 6, by - 5 + br_y, false);
    draw_rectangle(bx - f * 16 + lean, by - 30 + bob_off, bx - f * 5 + lean, by - 12 + bob_off, false);
    draw_rectangle(bx - 5 + lean, by - 25 + bob_off, bx + 6 + lean, by - 14 + bob_off, false);
    draw_rectangle(bx + f * 4 + lean, by - 22 + bob_off, bx + f * 11 + lean, by - 18 + bob_off, false);
    draw_rectangle(hx - 5, hy, hx + 5, hy + 8, false);
    draw_set_alpha(1);
}

draw_set_color(c_white);
