var _m = matrix_build(x, y, 0, 0, 0, angle, 1, 1, 1);
matrix_set(matrix_world, _m);
draw_set_alpha(alpha);

switch (part_type) {
    case 0: // HEAD — helmet + flesh face + gore at neck
        draw_set_color(make_color_rgb(28, 30, 28));
        draw_rectangle(-pw, -ph, pw, -ph * 0.25, false);
        draw_set_color(make_color_rgb(165, 115, 78));
        draw_rectangle(-pw * 0.75, -ph * 0.25, pw * 0.75, ph * 0.45, false);
        draw_set_color(make_color_rgb(25, 18, 14));
        draw_rectangle(-pw * 0.5, -ph * 0.1, pw * 0.1, ph * 0.1, false);
        draw_set_color(make_color_rgb(130, 8, 8));
        draw_rectangle(-pw * 0.6, ph * 0.38, pw * 0.6, ph, false);
        break;

    case 1: // ARM — jacket sleeve + flesh at wrist + gore at shoulder
        draw_set_color(make_color_rgb(42, 50, 35));
        draw_rectangle(-pw, -ph * 0.6, pw, ph * 0.55, false);
        draw_set_color(make_color_rgb(160, 110, 72));
        draw_rectangle(-pw, ph * 0.55, pw, ph, false);
        draw_set_color(make_color_rgb(130, 8, 8));
        draw_rectangle(-pw, -ph, pw, -ph * 0.6, false);
        break;

    case 2: // LEG — pants + boot + gore at hip
        draw_set_color(make_color_rgb(40, 42, 48));
        draw_rectangle(-pw, -ph * 0.6, pw, ph * 0.5, false);
        draw_set_color(make_color_rgb(20, 15, 10));
        draw_rectangle(-pw * 1.1, ph * 0.5, pw * 1.1, ph, false);
        draw_set_color(make_color_rgb(130, 8, 8));
        draw_rectangle(-pw, -ph, pw, -ph * 0.6, false);
        break;

    case 3: // TORSO CHUNK — jacket with open wounds
        draw_set_color(make_color_rgb(42, 50, 35));
        draw_rectangle(-pw, -ph, pw, ph, false);
        draw_set_color(make_color_rgb(25, 28, 20));
        draw_rectangle(-pw, -ph * 0.05, pw, ph * 0.08, false);
        draw_set_color(make_color_rgb(115, 8, 8));
        draw_rectangle(-pw * 0.7, -ph, pw * 0.7, -ph * 0.5, false);
        draw_rectangle(-pw * 0.5, ph * 0.55, pw * 0.5, ph, false);
        draw_set_color(make_color_rgb(80, 5, 5));
        draw_rectangle(-pw * 0.3, -ph * 0.5, pw * 0.3, ph * 0.55, false);
        break;

    case 4: // BOOT
        draw_set_color(make_color_rgb(20, 15, 10));
        draw_rectangle(-pw, -ph, pw, ph * 0.5, false);
        draw_set_color(make_color_rgb(35, 25, 15));
        draw_rectangle(-pw * 1.1, ph * 0.5, pw * 1.1, ph, false);
        break;
}

matrix_set(matrix_world, matrix_build_identity());
draw_set_alpha(1);
draw_set_color(c_white);
