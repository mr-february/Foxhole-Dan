var _m = matrix_build(x, y, 0, 0, 0, angle, 1, 1, 1);
matrix_set(matrix_world, _m);
draw_set_alpha(alpha);

switch (part_type) {
    case 0: // WHEEL CHUNK
        draw_set_color(make_color_rgb(18, 14, 8));
        draw_circle(0, 0, pw / 2, false);
        draw_set_color(make_color_rgb(52, 46, 34));
        draw_circle(0, 0, pw / 4, false);
        break;
    case 1: // ARMOR PLATE (Feldgrau green)
        draw_set_color(make_color_rgb(66, 74, 52));
        draw_rectangle(-pw, -ph, pw, ph, false);
        draw_set_color(make_color_rgb(42, 48, 32));
        draw_rectangle(-pw, -ph, pw, -ph + 2, false);
        break;
    case 2: // ENGINE PIECE (dark metal)
        draw_set_color(make_color_rgb(34, 30, 22));
        draw_rectangle(-pw, -ph, pw, ph, false);
        draw_set_color(make_color_rgb(52, 46, 34));
        draw_rectangle(-pw + 2, -ph + 2, pw - 2, ph - 2, false);
        break;
    case 3: // BARREL FRAGMENT (thin dark rod)
        draw_set_color(make_color_rgb(22, 20, 14));
        draw_rectangle(-pw, -ph, pw, ph, false);
        break;
    case 4: // CAB PANEL (olive with cracked glass)
        draw_set_color(make_color_rgb(56, 64, 44));
        draw_rectangle(-pw, -ph, pw, ph, false);
        draw_set_alpha(alpha * 0.35);
        draw_set_color(make_color_rgb(105, 132, 145));
        draw_rectangle(-pw / 2, -ph / 2, pw / 2, ph / 2, false);
        draw_set_alpha(alpha);
        break;
}

matrix_set(matrix_world, matrix_build_identity());
draw_set_alpha(1);
draw_set_color(c_white);
