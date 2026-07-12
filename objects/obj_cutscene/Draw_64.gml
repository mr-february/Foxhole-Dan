gw  = display_get_gui_width();
gh  = display_get_gui_height();
lb  = 82;
cay = lb;
cab = gh - lb;
cah = cab - cay;
mid = gw * 0.5;

// ── Local helpers ──────────────────────────────────────────
// Dan (olive, helmeted protagonist) — feet at cy, center at cx
function cs_dan(cx, cy, f) {
    var S = 3.5;
    // Helmet
    draw_set_color(make_color_rgb(55, 70, 32));
    draw_rectangle(cx-13*S, cy-76*S, cx+13*S, cy-62*S, false);
    draw_rectangle(cx-11*S, cy-86*S, cx+11*S, cy-74*S, false);
    draw_set_color(make_color_rgb(38, 50, 20));
    draw_rectangle(cx-14*S, cy-63*S, cx+14*S, cy-62*S, false);
    // Face
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_rectangle(cx-9*S, cy-62*S, cx+9*S, cy-48*S, false);
    draw_set_color(make_color_rgb(150, 108, 66));
    draw_rectangle(cx-8*S, cy-51*S, cx+8*S, cy-48*S, false);
    draw_set_color(make_color_rgb(38, 28, 15));
    draw_rectangle(cx+f*2*S, cy-59*S, cx+f*6*S, cy-56*S, false);
    // Neck
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_rectangle(cx-4*S, cy-48*S, cx+4*S, cy-44*S, false);
    // Jacket
    draw_set_color(make_color_rgb(74, 100, 50));
    draw_rectangle(cx-15*S, cy-44*S, cx+15*S, cy-26*S, false);
    draw_set_color(make_color_rgb(55, 75, 38));
    draw_line_width(cx-7*S, cy-42*S, cx+7*S, cy-28*S, 2);
    draw_line_width(cx+7*S, cy-42*S, cx-7*S, cy-28*S, 2);
    // Left arm
    draw_set_color(make_color_rgb(74, 100, 50));
    draw_rectangle(cx-20*S, cy-42*S, cx-13*S, cy-20*S, false);
    // Right arm + rifle
    draw_rectangle(cx+13*S, cy-42*S, cx+20*S, cy-20*S, false);
    draw_set_color(make_color_rgb(38, 32, 24));
    draw_line_width(cx+17*S, cy-38*S, cx+17*S+f*28*S, cy-40*S, 3);
    // Pants
    draw_set_color(make_color_rgb(65, 80, 40));
    draw_rectangle(cx-12*S, cy-26*S, cx-1*S, cy-6*S, false);
    draw_rectangle(cx+1*S,  cy-26*S, cx+12*S, cy-6*S, false);
    // Boots
    draw_set_color(make_color_rgb(48, 32, 18));
    draw_rectangle(cx-14*S, cy-6*S, cx-1*S, cy, false);
    draw_rectangle(cx+1*S,  cy-6*S, cx+14*S, cy, false);
}

// Hayes (battle buddy) — sergeant cap, square jaw, slightly taller
function cs_hayes(cx, cy, f, dark) {
    var S = 3.5;
    var dim = dark ? 0.55 : 1.0;   // dark=true renders him as a silhouette
    // Sergeant field cap
    draw_set_color(make_color_rgb(42*dim, 56*dim, 28*dim));
    draw_rectangle(cx-12*S, cy-84*S, cx+12*S, cy-72*S, false);
    draw_set_color(make_color_rgb(28*dim, 40*dim, 16*dim));
    draw_rectangle(cx+f*4*S, cy-72*S, cx+f*18*S, cy-67*S, false);
    // Head — square jaw
    draw_set_color(make_color_rgb(182*dim, 128*dim, 78*dim));
    draw_rectangle(cx-10*S, cy-72*S, cx+10*S, cy-56*S, false);
    draw_rectangle(cx-12*S, cy-62*S, cx+12*S, cy-56*S, false);
    // Brow
    draw_set_color(make_color_rgb(50*dim, 35*dim, 18*dim));
    draw_rectangle(cx-9*S, cy-70*S, cx+9*S, cy-66*S, false);
    // Eyes (narrow, intense)
    draw_set_color(make_color_rgb(22*dim, 16*dim, 8*dim));
    draw_rectangle(cx+f*1*S, cy-67*S, cx+f*8*S, cy-63*S, false);
    // Neck
    draw_set_color(make_color_rgb(182*dim, 128*dim, 78*dim));
    draw_rectangle(cx-4*S, cy-56*S, cx+4*S, cy-50*S, false);
    // Jacket (darker olive)
    draw_set_color(make_color_rgb(55*dim, 76*dim, 38*dim));
    draw_rectangle(cx-16*S, cy-50*S, cx+16*S, cy-28*S, false);
    // Sergeant stripes on upper left sleeve
    draw_set_color(make_color_rgb(185*dim, 148*dim, 52*dim));
    draw_rectangle(cx-20*S, cy-46*S, cx-14*S, cy-43*S, false);
    draw_rectangle(cx-20*S, cy-41*S, cx-14*S, cy-38*S, false);
    draw_rectangle(cx-20*S, cy-36*S, cx-14*S, cy-33*S, false);
    // Arms
    draw_set_color(make_color_rgb(55*dim, 76*dim, 38*dim));
    draw_rectangle(cx-21*S, cy-48*S, cx-14*S, cy-20*S, false);
    draw_rectangle(cx+14*S, cy-48*S, cx+21*S, cy-20*S, false);
    // Pants
    draw_set_color(make_color_rgb(50*dim, 66*dim, 32*dim));
    draw_rectangle(cx-13*S, cy-28*S, cx-1*S, cy-6*S, false);
    draw_rectangle(cx+1*S,  cy-28*S, cx+13*S, cy-6*S, false);
    // Boots
    draw_set_color(make_color_rgb(36*dim, 24*dim, 12*dim));
    draw_rectangle(cx-15*S, cy-6*S, cx-1*S, cy, false);
    draw_rectangle(cx+1*S,  cy-6*S, cx+15*S, cy, false);
}

// Draw a war-sky background (humid jungle dusk) into content area
function cs_war_sky(flicker) {
    // Sky gradient (monsoon green-grey)
    for (var i = 0; i < 8; i++) {
        var f2 = i / 8;
        draw_set_color(make_color_rgb(
            round(lerp(10,  34,  f2)),
            round(lerp(18,  56,  f2)),
            round(lerp(12,  38,  f2))
        ));
        var sy1 = cay + f2 * cah * 0.65;
        var sy2 = cay + (f2 + 0.13) * cah * 0.65;
        draw_rectangle(0, sy1, gw, sy2, false);
    }
    // Ground — wet paddy mud
    draw_set_color(make_color_rgb(30, 32, 14));
    draw_rectangle(0, cay + cah * 0.64, gw, cab, false);
    // Artillery glow at horizon
    if (flicker) {
        var ga = abs(sin(current_time * 0.018)) * 0.45;
        draw_set_alpha(ga);
        draw_set_color(make_color_rgb(210, 130, 45));
        draw_ellipse(1500, cay + cah * 0.52, 1750, cay + cah * 0.64, false);
        draw_set_alpha(0.3 * ga);
        draw_set_color(make_color_rgb(240, 180, 80));
        draw_ellipse(1580, cay + cah * 0.55, 1700, cay + cah * 0.63, false);
        draw_set_alpha(1);
    }
    // Monsoon haze wisps
    for (var sm = 0; sm < 6; sm++) {
        draw_set_alpha(0.18);
        draw_set_color(make_color_rgb(72, 92, 76));
        draw_circle(200 + sm * 320 + sin(current_time * 0.006 + sm) * 20,
                    cay + cah * 0.45 - sm * 12,
                    25 + sm * 8, false);
    }
    draw_set_alpha(1);
}

// Draw a bunker earth wall (foreground — packed jungle mud + sandbag line)
function cs_trench() {
    draw_set_color(make_color_rgb(42, 38, 18));
    draw_rectangle(0, cay + cah * 0.7, gw, cab, false);
    draw_set_color(make_color_rgb(58, 56, 28));
    draw_rectangle(0, cay + cah * 0.68, gw, cay + cah * 0.72, false);
    draw_set_color(make_color_rgb(28, 28, 12));
    draw_rectangle(0, cab - 10, gw, cab, false);
}

// Dialogue box + text
function cs_box(speaker, spk_col, line1, line2, line3) {
    var bx1 = 70;
    var by1 = cab - 130;
    var bx2 = gw - 70;
    var by2 = cab - 8;
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(8, 6, 4));
    draw_rectangle(bx1, by1, bx2, by2, false);
    draw_set_alpha(0.6);
    draw_set_color(spk_col);
    draw_rectangle(bx1, by1, bx2, by2, true);
    draw_set_alpha(1);
    // Speaker name
    draw_set_color(spk_col);
    draw_set_halign(fa_left);
    draw_text_transformed(bx1 + 16, by1 + 8, speaker + ":", 1.05, 1.05, 0);
    // Lines
    draw_set_color(c_white);
    draw_text_transformed(bx1 + 16, by1 + 30, line1, 0.95, 0.95, 0);
    if (line2 != "") draw_text_transformed(bx1 + 16, by1 + 52, line2, 0.95, 0.95, 0);
    if (line3 != "") draw_text_transformed(bx1 + 16, by1 + 74, line3, 0.95, 0.95, 0);
}

function cs_narrate(line1, line2) {
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(8, 6, 4));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(140, 110, 55));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 175, 110));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, line1, 1.0, 1.0, 0);
    if (line2 != "") draw_text_transformed(mid, cab - 52, line2, 1.0, 1.0, 0);
    draw_set_halign(fa_left);
}

// ─────────────────────────────────────────────────────────────
// BLACK BASE
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// PANEL CONTENT
// ─────────────────────────────────────────────────────────────
var gy = cab - 18;   // character feet y (just above letterbox)

switch (panel) {

// ───────────────────────────────────────────────────────────
case 0: // LOCATION CARD — Vietnam · 1968
// ───────────────────────────────────────────────────────────
    cs_war_sky(true);
    // Jungle canopy silhouette treeline
    draw_set_color(make_color_rgb(8, 16, 8));
    for (var t = 0; t < 30; t++) {
        var tx  = t * 66 + 10;
        var th  = 55 + (t * 41) mod 70;
        var tw  = 16 + (t * 17) mod 20;
        var ty0 = cay + cah * 0.64;
        draw_triangle(tx, ty0 - th, tx - tw, ty0, tx + tw, ty0, false);
        draw_triangle(tx, ty0 - th - 20, tx - tw + 4, ty0 - th + 10, tx + tw - 4, ty0 - th + 10, false);
    }
    // River / paddy water catching the light
    draw_set_alpha(0.6);
    draw_set_color(make_color_rgb(64, 104, 88));
    draw_ellipse(150,  gy - 12, 400,  gy - 4,  false);
    draw_ellipse(820,  gy - 14, 1140, gy - 5,  false);
    draw_ellipse(1450, gy - 11, 1760, gy - 3,  false);
    draw_set_alpha(1);
    // Humid green wash
    draw_set_alpha(0.22);
    draw_set_color(make_color_rgb(52, 110, 62));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // TITLE
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(210, 175, 90));
    draw_text_transformed(mid, cay + cah * 0.22, "VIETNAM  ·  1968", 3.0, 3.0, 0);
    draw_set_color(make_color_rgb(165, 130, 68));
    draw_text_transformed(mid, cay + cah * 0.40, "A bend in the river with no name.", 1.5, 1.5, 0);
    draw_set_color(make_color_rgb(110, 88, 50));
    draw_text_transformed(mid, cay + cah * 0.78, "Before the nightmares began.", 1.1, 1.1, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 1: // THE BUNKER — Dan + Hayes, dug in above the river
// ───────────────────────────────────────────────────────────
    cs_war_sky(true);
    cs_trench();
    // Bunker walls (foreground earth walls L/R)
    draw_set_color(make_color_rgb(48, 44, 22));
    draw_rectangle(0, cay + cah * 0.38, 160, cab, false);
    draw_rectangle(gw - 160, cay + cah * 0.38, gw, cab, false);
    // Dan left, Hayes right, both huddled down a little
    cs_dan(530, gy, 1);
    cs_hayes(1390, gy, -1, false);
    // Humid green tint
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(50, 108, 60));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Dialogue — Hayes speaking
    cs_box("HAYES", make_color_rgb(100, 180, 100),
           "Every man I've fought beside made it home.",
           "You know why?",
           "");
    break;

// ───────────────────────────────────────────────────────────
case 2: // THE PROMISE — Hayes grips Dan's shoulder
// ───────────────────────────────────────────────────────────
    cs_war_sky(true);
    cs_trench();
    // Closer together
    cs_dan(700,  gy, 1);
    cs_hayes(1220, gy, -1, false);
    // Hayes' hand on Dan's shoulder (a rectangle bridge)
    draw_set_color(make_color_rgb(55, 76, 38));
    draw_rectangle(840, gy - 140, 1010, gy - 112, false);
    // Humid green tint
    draw_set_alpha(0.18);
    draw_set_color(make_color_rgb(50, 108, 60));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Dialogue (alternating — Hayes)
    cs_box("HAYES", make_color_rgb(100, 180, 100),
           "When this ends — and it WILL end —",
           "we go home.  Together.  That's a promise.",
           "");
    // Narration below box
    draw_set_alpha(0.72);
    draw_set_color(make_color_rgb(8, 6, 4));
    draw_rectangle(70, cay + 14, 580, cay + 44, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(170, 140, 80));
    draw_text_transformed(90, cay + 18, "You believed him.", 1.05, 1.05, 0);
    break;

// ───────────────────────────────────────────────────────────
case 3: // INCOMING — the ambush / mortars erupt
// ───────────────────────────────────────────────────────────
    // Flash white/orange with shockwave rings
    var fl = 0.6 + sin(current_time * 0.04) * 0.38;
    draw_set_alpha(fl);
    draw_set_color(make_color_rgb(255, 240, 140));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(fl * 0.6);
    draw_set_color(make_color_rgb(255, 160, 40));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Shockwave rings
    var ring_t = (current_time mod 60) / 60.0;
    for (var r = 0; r < 4; r++) {
        var rp = frac(ring_t + r * 0.25);
        draw_set_alpha(max(0, 0.7 * (1 - rp)));
        draw_set_color(c_white);
        draw_circle(mid, cay + cah * 0.5, rp * 500, true);
    }
    draw_set_alpha(1);
    // Debris fragments
    draw_set_color(make_color_rgb(60, 45, 28));
    for (var d = 0; d < 12; d++) {
        var da = d * (360 / 12);
        var dr = 80 + (d * 37) mod 120;
        var dx = mid + lengthdir_x(dr, da);
        var dy = cay + cah * 0.5 + lengthdir_y(dr, da);
        draw_rectangle(dx - 4, dy - 4, dx + 4, dy + 4, false);
    }
    // Big text
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(180, 20, 10));
    draw_text_transformed(mid + 3, cay + cah * 0.38 + 3, "— INCOMING —", 3.5, 3.5, 0);
    draw_set_color(make_color_rgb(255, 60, 40));
    draw_text_transformed(mid, cay + cah * 0.38, "— INCOMING —", 3.5, 3.5, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 4: // HAYES SAVES DAN — dark rescue
// ───────────────────────────────────────────────────────────
    // Very dark smoke-filled scene
    draw_set_color(make_color_rgb(18, 12, 8));
    draw_rectangle(0, cay, gw, cab, false);
    // Smoke clouds
    for (var sm = 0; sm < 8; sm++) {
        draw_set_alpha(0.35 + 0.15 * abs(sin(current_time * 0.01 + sm)));
        draw_set_color(make_color_rgb(60, 52, 44));
        draw_circle(sm * 265 + sin(current_time * 0.008 + sm * 0.9) * 30,
                    cay + cah * 0.35 + (sm mod 3) * 40, 55 + sm * 12, false);
    }
    draw_set_alpha(1);
    // Ground rubble
    draw_set_color(make_color_rgb(40, 28, 15));
    draw_rectangle(0, cay + cah * 0.72, gw, cab, false);
    draw_set_color(make_color_rgb(55, 38, 20));
    for (var rb = 0; rb < 10; rb++) {
        draw_rectangle(rb * 195 + 30, cay + cah * 0.7 - (rb mod 3) * 14,
                       rb * 195 + 130, cay + cah * 0.73 + (rb mod 2) * 10, false);
    }
    // Fire glow from right
    draw_set_alpha(0.45 + abs(sin(current_time * 0.022)) * 0.3);
    draw_set_color(make_color_rgb(220, 90, 15));
    draw_ellipse(gw - 80, cay + cah * 0.5, gw + 40, cab, false);
    draw_set_alpha(1);
    // Dan collapsed (horizontal silhouette)
    draw_set_color(make_color_rgb(55, 72, 38));
    draw_ellipse(520, gy - 22, 760, gy - 8, false);  // body
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_ellipse(730, gy - 30, 790, gy - 10, false); // head
    draw_set_color(make_color_rgb(55, 70, 32));
    draw_rectangle(720, gy - 44, 780, gy - 28, false); // helmet
    // Hayes upright, dragging
    cs_hayes(840, gy, 1, false);
    // Arm reaching down to Dan
    draw_set_color(make_color_rgb(55, 76, 38));
    draw_rectangle(680, gy - 42, 760, gy - 26, false);
    // Orange fire tint over scene
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(200, 80, 10));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    cs_box("HAYES", make_color_rgb(100, 180, 100),
           "DANILO!  STAY WITH ME!",
           "Don't you dare close your eyes.",
           "");
    // Narrator tag
    draw_set_alpha(0.75);
    draw_set_color(make_color_rgb(8,6,4));
    draw_rectangle(70, cay+14, 780, cay+44, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(170,140,80));
    draw_text_transformed(90, cay+18, "The bunker came down behind you.", 1.0, 1.0, 0);
    break;

// ───────────────────────────────────────────────────────────
case 5: // THE DEBT — field hospital, Da Nang; ominous Hayes
// ───────────────────────────────────────────────────────────
    // Recovery room — muted, grey-green walls
    draw_set_color(make_color_rgb(38, 42, 34));
    draw_rectangle(0, cay, gw, cab, false);
    // Wall texture
    draw_set_color(make_color_rgb(44, 49, 40));
    for (var wy = 0; wy < 10; wy++) {
        draw_rectangle(0, cay + wy * (cah / 10), gw, cay + wy * (cah / 10) + 1, false);
    }
    // Window (light from outside)
    draw_set_color(make_color_rgb(30, 32, 28));
    draw_rectangle(mid - 80, cay + 30, mid + 80, cay + 180, false);
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(120, 140, 90));
    draw_rectangle(mid - 78, cay + 32, mid + 78, cay + 178, false);
    draw_set_alpha(0.2);
    draw_set_color(c_white);
    draw_rectangle(mid - 78, cay + 32, mid + 78, cay + 178, false); // window glare
    draw_set_alpha(1);
    // Window frame cross
    draw_set_color(make_color_rgb(28, 30, 24));
    draw_rectangle(mid - 4, cay + 32, mid + 4, cay + 178, false);
    draw_rectangle(mid - 78, cay + 100, mid + 78, cay + 108, false);
    // Cot (where Dan rests — implied, just bedding)
    draw_set_color(make_color_rgb(160, 150, 130));
    draw_rectangle(80, gy - 12, 600, gy, false);
    draw_set_color(make_color_rgb(140, 130, 112));
    draw_rectangle(80, gy - 28, 250, gy - 12, false); // pillow
    // Dan lying (just head + outline on cot)
    draw_set_color(make_color_rgb(195, 140, 88));
    draw_ellipse(225, gy - 42, 285, gy - 18, false);
    draw_set_color(make_color_rgb(55, 70, 32));
    draw_rectangle(215, gy - 54, 295, gy - 38, false);
    // Hayes — silhouette in doorway (right side, dark, slightly ominous)
    cs_hayes(1480, gy, -1, true);
    // Door frame
    draw_set_color(make_color_rgb(28, 22, 14));
    draw_rectangle(1360, cay + cah * 0.2, 1380, cab, false);
    draw_rectangle(1590, cay + cah * 0.2, 1610, cab, false);
    draw_rectangle(1358, cay + cah * 0.2, 1612, cay + cah * 0.22, false);
    // Humid green tint (lighter)
    draw_set_alpha(0.12);
    draw_set_color(make_color_rgb(55, 110, 65));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    cs_box("HAYES", make_color_rgb(100, 180, 100),
           "Rest up, Danilo.",
           "You owe me a debt now.",
           "Don't forget that.");
    draw_set_alpha(0.75);
    draw_set_color(make_color_rgb(8,6,4));
    draw_rectangle(70, cay+14, 820, cay+70, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(170,140,80));
    draw_text_transformed(90, cay+18, "He carried you two miles through the paddies.", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(140,112,64));
    draw_text_transformed(90, cay+42, "You were awake for every step.", 1.0, 1.0, 0);
    break;

// ───────────────────────────────────────────────────────────
case 6: // THE NIGHTMARES — black panel, Hayes haunting the dark
// ───────────────────────────────────────────────────────────
    // Pure black — only text
    // Silhouette of Hayes (very faint, far right)
    draw_set_alpha(0.08);
    cs_hayes(gw - 200, gy, -1, true);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    var ty = cay + cah * 0.18;
    var tg = 48;  // line gap

    draw_set_color(make_color_rgb(155, 120, 50));
    draw_text_transformed(mid, ty,        "The nightmares started three months later.", 1.2, 1.2, 0);

    draw_set_color(make_color_rgb(90, 78, 55));
    draw_rectangle(mid - 200, ty + tg * 1.6 + 8, mid + 200, ty + tg * 1.6 + 10, false);

    draw_set_color(make_color_rgb(180, 145, 60));
    draw_text_transformed(mid, ty + tg * 2.5, "Always the same bunker.", 1.35, 1.35, 0);
    draw_set_color(make_color_rgb(200, 160, 66));
    draw_text_transformed(mid, ty + tg * 3.6, "Always Hayes.", 1.35, 1.35, 0);

    draw_set_color(make_color_rgb(90, 78, 55));
    draw_rectangle(mid - 200, ty + tg * 5.0 + 8, mid + 200, ty + tg * 5.0 + 10, false);

    draw_set_color(make_color_rgb(130, 100, 42));
    draw_text_transformed(mid, ty + tg * 5.8, "Every night.  For fifteen years.", 1.05, 1.05, 0);

    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 7: // KILLED IN ACTION — the river at night, memorial card
// ───────────────────────────────────────────────────────────
    // Near-black night over the river
    draw_set_color(make_color_rgb(6, 10, 10));
    draw_rectangle(0, cay, gw, cab, false);
    // Dark river band across the lower third
    draw_set_color(make_color_rgb(12, 26, 26));
    draw_rectangle(0, cay + cah * 0.66, gw, cab, false);
    // Slow moonlight glints drifting on the water
    for (var _kg = 0; _kg < 7; _kg++) {
        var _ka = 0.10 + 0.08 * abs(sin(current_time * 0.004 + _kg * 1.3));
        draw_set_alpha(_ka);
        draw_set_color(make_color_rgb(120, 160, 150));
        draw_ellipse(_kg * 290 + 40 + sin(current_time * 0.003 + _kg) * 24,
                     cay + cah * 0.70 + (_kg mod 3) * 22,
                     _kg * 290 + 220 + sin(current_time * 0.003 + _kg) * 24,
                     cay + cah * 0.72 + (_kg mod 3) * 22, false);
    }
    draw_set_alpha(1);
    // Far treeline silhouette above the water
    draw_set_color(make_color_rgb(4, 8, 6));
    draw_rectangle(0, cay + cah * 0.58, gw, cay + cah * 0.67, false);
    // Memorial text
    draw_set_halign(fa_center);
    var _ky = cay + cah * 0.14;
    var _kt = 48;
    draw_set_color(make_color_rgb(155, 120, 50));
    draw_text_transformed(mid, _ky,            "Sgt. Hayes was declared Killed in Action.", 1.15, 1.15, 0);
    draw_set_color(make_color_rgb(180, 145, 60));
    draw_text_transformed(mid, _ky + _kt,      "March 3rd, 1969.", 1.3, 1.3, 0);
    draw_set_color(make_color_rgb(90, 78, 55));
    draw_rectangle(mid - 200, _ky + _kt * 2 + 8, mid + 200, _ky + _kt * 2 + 10, false);
    draw_set_color(make_color_rgb(150, 170, 160));
    draw_text_transformed(mid, _ky + _kt * 2.8, "The river took him.", 1.25, 1.25, 0);
    draw_set_color(make_color_rgb(95, 105, 95));
    draw_text_transformed(mid, _ky + _kt * 3.8, "The body was never recovered.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 8: // 1983 — THE LETTERS — a lamplit room, fifteen years later
// ───────────────────────────────────────────────────────────
    // Dark room, cold lamp glow left side
    draw_set_color(make_color_rgb(12, 12, 16));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(0.4 + abs(sin(current_time * 0.008)) * 0.1);
    draw_set_color(make_color_rgb(170, 150, 90));
    draw_ellipse(-60, cay + cah * 0.28, 320, cab + 60, false);
    draw_set_alpha(1);
    // Cigarette-smoke wisps
    for (var _sm = 0; _sm < 5; _sm++) {
        draw_set_alpha(0.14);
        draw_set_color(make_color_rgb(80, 80, 88));
        draw_circle(240 + _sm * 340 + sin(current_time * 0.006 + _sm) * 18,
                    cay + cah * 0.25 - _sm * 10, 22 + _sm * 9, false);
    }
    draw_set_alpha(1);
    // Era card
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(150, 150, 170));
    draw_text_transformed(mid, cay + 10, "FIFTEEN YEARS LATER   ·   1983", 1.15, 1.15, 0);
    draw_set_halign(fa_left);
    // The letter (plain paper, center-screen)
    var _dx  = mid - 265;
    var _dw  = 530;
    var _dy  = cay + cah * 0.12;
    var _dh  = cah * 0.62;
    // Paper shadow
    draw_set_color(make_color_rgb(6, 6, 8));
    draw_rectangle(_dx + 8, _dy + 8, _dx + _dw + 8, _dy + _dh + 8, false);
    // Paper body
    draw_set_color(make_color_rgb(218, 205, 175));
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, false);
    // Handling stains — corners
    draw_set_color(make_color_rgb(150, 132, 100));
    draw_ellipse(_dx + _dw - 55, _dy + _dh - 45, _dx + _dw + 20, _dy + _dh + 22, false);
    draw_set_color(make_color_rgb(160, 142, 108));
    draw_ellipse(_dx - 20, _dy + 20, _dx + 45, _dy + 90, false);
    // Letter text
    draw_set_color(make_color_rgb(28, 18, 10));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, _dy + 14, "NO RETURN ADDRESS", 0.82, 0.82, 0);
    draw_text_transformed(mid, _dy + 30, "POSTMARK:  [ ILLEGIBLE ]", 0.72, 0.72, 0);
    draw_rectangle(_dx + 18, _dy + 46, _dx + _dw - 18, _dy + 48, false);
    draw_text_transformed(mid, _dy + 60,  "You still dream about", 1.2, 1.2, 0);
    draw_text_transformed(mid, _dy + 90,  "the river, don't you?", 1.2, 1.2, 0);
    draw_rectangle(_dx + 18, _dy + 116, _dx + _dw - 18, _dy + 118, false);
    draw_text_transformed(mid, _dy + 130, "You still owe a debt.", 1.0, 1.0, 0);
    draw_text_transformed(mid, _dy + 158, "Signed:  \"H\"", 1.2, 1.2, 0);
    draw_set_halign(fa_left);
    // Narration
    cs_narrate("The letters started arriving last year.  Signed only:  \"H\".",
               "Someone has been engineering your breakdown.");
    break;

// ───────────────────────────────────────────────────────────
case 9: // THE QUESTION — who really walked away from the bunker?
// ───────────────────────────────────────────────────────────
    // Slow red pulse over black
    var _alp = 0.10 + abs(sin(current_time * 0.004)) * 0.08;
    draw_set_alpha(_alp);
    draw_set_color(make_color_rgb(120, 12, 12));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Faint Hayes silhouette, dead center, watching
    draw_set_alpha(0.10 + abs(sin(current_time * 0.003)) * 0.05);
    cs_hayes(mid, gy, -1, true);
    draw_set_alpha(1);
    // Text
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(200, 60, 60));
    draw_text_transformed(mid, cay + cah * 0.20, "Someone who knows exactly what happened", 1.15, 1.15, 0);
    draw_set_color(make_color_rgb(220, 70, 70));
    draw_text_transformed(mid, cay + cah * 0.30, "at that river.", 1.15, 1.15, 0);
    draw_set_color(make_color_rgb(90, 78, 55));
    draw_rectangle(mid - 200, cay + cah * 0.44, mid + 200, cay + cah * 0.44 + 2, false);
    draw_set_color(make_color_rgb(210, 175, 90));
    draw_text_transformed(mid, cay + cah * 0.56, "Who really walked away", 1.6, 1.6, 0);
    draw_text_transformed(mid, cay + cah * 0.68, "from the bunker?", 1.6, 1.6, 0);
    draw_set_halign(fa_left);
    break;

} // end switch

// ─────────────────────────────────────────────────────────────
// HUMID JUNGLE TINT (Vietnam flashback panels only — not 7-9)
// ─────────────────────────────────────────────────────────────
if (panel != 3 && panel != 6 && panel < 7) {
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(45, 105, 55));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
}

// ─────────────────────────────────────────────────────────────
// LETTERBOX BARS
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, lb, false);
draw_rectangle(0, gh - lb, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// CONTINUE PROMPT (pulsing, bottom letterbox)
// ─────────────────────────────────────────────────────────────
if (fade <= 5) {
    var pa = 0.45 + sin(current_time * 0.008) * 0.3;
    draw_set_alpha(pa);
    draw_set_color(make_color_rgb(190, 165, 90));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, gh - lb + 22, "SPACE / A  to continue", 0.88, 0.88, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1);
}

// ─────────────────────────────────────────────────────────────
// PANEL LABEL (top bar)
// ─────────────────────────────────────────────────────────────
draw_set_color(make_color_rgb(80, 65, 38));
draw_set_halign(fa_right);
draw_text_transformed(gw - 24, 22, string(panel + 1) + " / " + string(panels), 0.82, 0.82, 0);
draw_set_halign(fa_left);

// ─────────────────────────────────────────────────────────────
// FADE OVERLAY
// ─────────────────────────────────────────────────────────────
if (fade > 0) {
    draw_set_alpha(fade / 60.0);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);
    draw_set_alpha(1);
}

// Reset draw state
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
