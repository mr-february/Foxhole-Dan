var gw  = display_get_gui_width();
var gh  = display_get_gui_height();
var lb  = 82;
var cay = lb;
var cab = gh - lb;
var cah = cab - cay;
var mid = gw * 0.5;

// ─────────────────────────────────────────────────────────────
// BLACK BASE
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// PANEL CONTENT
// ─────────────────────────────────────────────────────────────
var gy = cab - 16;

switch (panel) {

// ───────────────────────────────────────────────────────────
case 0: // THE SNAP-BACK — 1983, night, the building burning behind Dan
// ───────────────────────────────────────────────────────────
    // Night sky gradient
    for (var si = 0; si < 10; si++) {
        var t = si / 10.0;
        draw_set_color(make_color_rgb(
            round(lerp(4,  18, t)),
            round(lerp(8,  28, t)),
            round(lerp(18, 52, t))
        ));
        draw_rectangle(0, cay + t * cah, gw, cay + (t + 0.1) * cah, false);
    }
    // Stars
    draw_set_color(make_color_rgb(200, 200, 210));
    for (var st = 0; st < 40; st++) {
        var stx = (st * 487) mod gw;
        var sty = cay + (st * 311) mod (cah * 0.55);
        var sta = 0.4 + sin(current_time * 0.01 + st) * 0.3;
        draw_set_alpha(sta);
        draw_circle(stx, sty, 1, false);
    }
    draw_set_alpha(1);
    // Distant skyline silhouette (low 1983 cityscape)
    draw_set_color(make_color_rgb(12, 10, 18));
    for (var sk = 0; sk < 18; sk++) {
        var bx  = sk * 110 + 20;
        var bh2 = 30 + (sk * 53) mod 60;
        var bw2 = 50 + (sk * 31) mod 40;
        draw_rectangle(bx, gy - bh2, bx + bw2, gy, false);
        // Window lights
        draw_set_color(make_color_rgb(220, 200, 140));
        for (var wn = 0; wn < 3; wn++) {
            if ((sk + wn) mod 3 != 0) {
                draw_rectangle(bx + 8 + wn * 14, gy - bh2 + 8 + (sk mod 3) * 12,
                               bx + 18 + wn * 14, gy - bh2 + 18 + (sk mod 3) * 12, false);
            }
        }
        draw_set_color(make_color_rgb(12, 10, 18));
    }
    // Fire glow (right side — Dan's building, burning)
    var eg = 0.55 + abs(sin(current_time * 0.028)) * 0.3;
    draw_set_alpha(eg);
    draw_set_color(make_color_rgb(230, 95, 18));
    draw_ellipse(gw - 200, cay + cah * 0.4, gw + 120, gy, false);
    draw_set_alpha(eg * 0.5);
    draw_set_color(make_color_rgb(255, 200, 60));
    draw_ellipse(gw - 160, cay + cah * 0.5, gw + 60, gy, false);
    draw_set_alpha(1);
    // Orange sky glow from explosion
    draw_set_alpha(0.22 + abs(sin(current_time * 0.025)) * 0.12);
    draw_set_color(make_color_rgb(200, 70, 10));
    draw_rectangle(gw * 0.55, cay, gw, cay + cah * 0.6, false);
    draw_set_alpha(1);
    // Ground / road
    draw_set_color(make_color_rgb(18, 14, 10));
    draw_rectangle(0, gy - 30, gw, gy, false);
    draw_set_color(make_color_rgb(28, 22, 16));
    draw_rectangle(0, gy - 32, gw, gy - 28, false);
    // Dan's jeep silhouette (simplified, center-left)
    var jx = mid - 320;
    var jy = gy;
    draw_set_color(make_color_rgb(38, 50, 28));
    draw_rectangle(jx - 42, jy - 24, jx + 42, jy - 6, false);  // chassis
    draw_rectangle(jx - 4,  jy - 36, jx + 30, jy - 24, false); // cab
    draw_rectangle(jx + 26, jy - 20, jx + 52, jy - 8,  false); // hood
    draw_set_color(make_color_rgb(22, 18, 12));
    draw_circle(jx - 24, jy, 12, false);
    draw_circle(jx + 24, jy, 12, false);
    // Location card
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(190, 170, 130));
    draw_text_transformed(mid, cay + cah * 0.12, "1983", 2.2, 2.2, 0);
    draw_set_color(make_color_rgb(140, 120, 90));
    draw_text_transformed(mid, cay + cah * 0.26, "0247 HRS", 1.1, 1.1, 0);
    // Narration strip
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_text_transformed(mid, cab - 78, "The flashback breaks.", 1.05, 1.05, 0);
    draw_text_transformed(mid, cab - 52, "It's 1983.  And the danger is real.", 1.05, 1.05, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 1: // THE THREAT — inside, everything Dan owns is burning
// ───────────────────────────────────────────────────────────
    // Dark interior
    draw_set_color(make_color_rgb(16, 10, 8));
    draw_rectangle(0, cay, gw, cab, false);
    // Fire glow from multiple sources
    for (var _f1 = 0; _f1 < 5; _f1++) {
        var _f1a = 0.45 + abs(sin(current_time * 0.022 + _f1 * 1.1)) * 0.3;
        draw_set_alpha(_f1a);
        draw_set_color(make_color_rgb(210, 80 + _f1 * 14, 15));
        draw_ellipse(_f1 * 380 + 60, cay + cah * 0.52, _f1 * 380 + 280, cab + 40, false);
    }
    draw_set_alpha(1);
    // Ceiling beams / door frames silhouette
    draw_set_color(make_color_rgb(12, 8, 6));
    draw_rectangle(0,       cay + cah * 0.1, 60, cay + cah * 0.9, false);
    draw_rectangle(gw - 60, cay + cah * 0.1, gw, cay + cah * 0.9, false);
    for (var _f1b = 0; _f1b < 6; _f1b++) {
        draw_rectangle(0, cay + _f1b * (cah / 5.5), gw, cay + _f1b * (cah / 5.5) + 8, false);
    }
    // Rising embers
    draw_set_color(make_color_rgb(255, 170, 60));
    for (var _f1e = 0; _f1e < 22; _f1e++) {
        var _f1x = (_f1e * 173) mod gw + sin(current_time * 0.004 + _f1e) * 26;
        var _f1y = cab - ((current_time * 0.06 + _f1e * 97) mod cah);
        draw_set_alpha(0.25 + (_f1e mod 4) * 0.12);
        draw_circle(_f1x, _f1y, 1 + (_f1e mod 3), false);
    }
    draw_set_alpha(1);
    // Heat pulse
    var _f1p = 0.14 + sin(current_time * 0.03) * 0.10;
    draw_set_alpha(_f1p);
    draw_set_color(make_color_rgb(220, 60, 10));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Big text
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(255, 130, 60));
    draw_text_transformed(mid + 3, cay + cah * 0.20 + 3, "THEY SET THE FIRE WHILE YOU SLEPT", 1.7, 1.7, 0);
    draw_set_color(make_color_rgb(255, 190, 120));
    draw_text_transformed(mid,     cay + cah * 0.20,     "THEY SET THE FIRE WHILE YOU SLEPT", 1.7, 1.7, 0);
    draw_set_halign(fa_left);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "This is not a nightmare.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "This one is real.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 2: // THE DOSSIER — a folder that survived the fire
// ───────────────────────────────────────────────────────────
    // Dark room, fire glow bleeding in from the left
    draw_set_color(make_color_rgb(14, 10, 6));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(0.35 + abs(sin(current_time * 0.02)) * 0.15);
    draw_set_color(make_color_rgb(190, 80, 15));
    draw_ellipse(-80, cay + cah * 0.3, 300, cab + 40, false);
    draw_set_alpha(1);
    // Dossier held up — center of frame
    var _dx  = mid - 260;
    var _dw  = 520;
    var _dy  = cay + cah * 0.06;
    var _dh  = cah * 0.72;
    // Shadow
    draw_set_color(make_color_rgb(8, 5, 3));
    draw_rectangle(_dx + 10, _dy + 10, _dx + _dw + 10, _dy + _dh + 10, false);
    // Folder body (manila)
    draw_set_color(make_color_rgb(210, 190, 150));
    draw_rectangle(_dx, _dy, _dx + _dw, _dy + _dh, false);
    // Burn corner top-right
    draw_set_color(make_color_rgb(70, 44, 16));
    draw_ellipse(_dx + _dw - 45, _dy - 18, _dx + _dw + 18, _dy + 50, false);
    // Cover content
    draw_set_color(make_color_rgb(22, 14, 8));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, _dy + 12, "DEPARTMENT OF DEFENSE — SPECIAL PROGRAMS", 0.8, 0.8, 0);
    draw_text_transformed(mid, _dy + 28, "CLASSIFICATION: ULTRA — EYES ONLY", 0.7, 0.7, 0);
    draw_rectangle(_dx + 16, _dy + 44, _dx + _dw - 16, _dy + 46, false);
    draw_text_transformed(mid, _dy + 58,  "PROJECT FOXHOLE", 1.55, 1.55, 0);
    draw_text_transformed(mid, _dy + 88,  "CRYPTONYM:  MK-ECHO", 1.0,  1.0,  0);
    draw_rectangle(_dx + 16, _dy + 108, _dx + _dw - 16, _dy + 110, false);
    draw_text_transformed(mid, _dy + 122, "SUBJECT:  DANILO", 1.25, 1.25, 0);
    draw_text_transformed(mid, _dy + 150, "VETERAN ID:  44-7821", 0.85, 0.85, 0);
    draw_rectangle(_dx + 16, _dy + 170, _dx + _dw - 16, _dy + 172, false);
    draw_text_transformed(mid, _dy + 185, "PROGRAM DIRECTOR:  [ REDACTED ]", 1.0,  1.0,  0);
    draw_set_halign(fa_left);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "A dossier, left where the fire couldn't reach it.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "Someone wanted you to read it.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 3: // PHASE 3 — the page with Dan's name on it
// ───────────────────────────────────────────────────────────
    // Near-black with subtle blue cast — cold, cerebral
    draw_set_color(make_color_rgb(8, 10, 18));
    draw_rectangle(0, cay, gw, cab, false);
    // Classified document fragments floating in frame
    var _frags = [
        "PROJECT FOXHOLE  —  CRYPTONYM: MK-ECHO",
        "PHASE 3 — PSYCHOLOGICAL DISMANTLEMENT",
        "TARGET:  SUBJECT DAN  [ VET ID 44-7821 ]",
        "METHOD:  MEMORY INDUCTION / SLEEP DISRUPTION",
        "LETTERS SCHEDULE:  SEE ATTACHMENT H-7",
        "AUTHORIZATION:  [ REDACTED ]",
        "HANDLER:  H",
    ];
    for (var _fr = 0; _fr < array_length(_frags); _fr++) {
        var _fy   = cay + cah * 0.10 + _fr * (cah * 0.11);
        var _fade = 0.25 + 0.65 * (_fr / (array_length(_frags) - 1));
        draw_set_alpha(_fade);
        if (_fr == array_length(_frags) - 1) {
            draw_set_color(make_color_rgb(220, 80, 60));
        } else {
            draw_set_color(make_color_rgb(155, 135, 100));
        }
        draw_set_halign(fa_center);
        draw_text_transformed(mid, _fy, _frags[_fr], 0.88, 0.88, 0);
    }
    draw_set_alpha(1);
    draw_rectangle(mid - 220, cay + cah * 0.10 + 3 * cah * 0.11 - 2,
                   mid + 220, cay + cah * 0.10 + 3 * cah * 0.11, false);
    draw_set_halign(fa_left);
    // Narration
    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(6, 4, 2));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, false);
    draw_set_alpha(0.4);
    draw_set_color(make_color_rgb(180, 140, 50));
    draw_rectangle(70, cab - 90, gw - 70, cab - 8, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(200, 178, 118));
    draw_set_halign(fa_center);
    draw_text_transformed(mid, cab - 78, "Fifteen years of nightmares, itemized.", 1.0, 1.0, 0);
    draw_text_transformed(mid, cab - 52, "Filed.  Stamped.  Approved.", 1.0, 1.0, 0);
    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 4: // THE REALIZATION — Dan alone with the pages, fire closing in
// ───────────────────────────────────────────────────────────
    // Smoke-black room, ember glow on the horizon line
    draw_set_color(make_color_rgb(12, 10, 12));
    draw_rectangle(0, cay, gw, cab, false);
    // Floor
    draw_set_color(make_color_rgb(22, 18, 14));
    draw_rectangle(0, gy - 35, gw, gy, false);
    draw_set_color(make_color_rgb(30, 24, 18));
    draw_rectangle(0, gy - 37, gw, gy - 33, false);
    // Fire glow behind him
    draw_set_alpha(0.35 + abs(sin(current_time * 0.02)) * 0.18);
    draw_set_color(make_color_rgb(200, 80, 15));
    draw_ellipse(mid - 400, cay + cah * 0.55, mid + 400, gy + 30, false);
    draw_set_alpha(1);
    // Drifting smoke
    draw_set_alpha(0.2);
    draw_set_color(make_color_rgb(70, 65, 60));
    for (var _rv = 0; _rv < 25; _rv++) {
        var _rox = (_rv * 78 + current_time * 0.5) mod gw;
        var _roy = cay + (_rv * 97) mod cah;
        draw_circle(_rox, _roy, 14 + (_rv mod 4) * 6, false);
    }
    draw_set_alpha(1);
    // Dan silhouette — standing, pages in hand
    var _sx = 520;
    var _sy = gy - 4;
    draw_set_color(make_color_rgb(42, 55, 30));   // torso
    draw_rectangle(_sx - 14, _sy - 46, _sx + 14, _sy - 6, false);
    draw_set_color(make_color_rgb(185, 130, 80));  // face
    draw_rectangle(_sx - 8,  _sy - 60, _sx + 8,  _sy - 46, false);
    draw_set_color(make_color_rgb(48, 62, 28));    // hair/brow shadow
    draw_rectangle(_sx - 12, _sy - 68, _sx + 12, _sy - 56, false);
    // Pages in his hand (pale rectangle catching the light)
    draw_set_color(make_color_rgb(205, 195, 165));
    draw_rectangle(_sx + 16, _sy - 44, _sx + 40, _sy - 26, false);
    // Narration box
    var _bx1 = 70;
    var _by1 = cab - 138;
    var _bx2 = gw - 70;
    var _by2 = cab - 8;
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(6, 5, 3));
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(80, 160, 80));
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(100, 180, 100));
    draw_set_halign(fa_left);
    draw_text_transformed(_bx1 + 16, _by1 + 8, "", 1.05, 1.05, 0);
    draw_set_color(c_white);
    draw_text_transformed(_bx1 + 16, _by1 + 30, "Your nightmares didn't come from the war.", 0.95, 0.95, 0);
    draw_text_transformed(_bx1 + 16, _by1 + 52, "Someone built them.", 0.95, 0.95, 0);
    draw_text_transformed(_bx1 + 16, _by1 + 74, "Someone with a plan.", 0.95, 0.95, 0);
    break;

// ───────────────────────────────────────────────────────────
case 5: // ONE NAME — Harrington
// ───────────────────────────────────────────────────────────
    // Pure black with a faint looming silhouette
    draw_set_alpha(0.06);
    // Tall shadow, center
    draw_set_color(make_color_rgb(80, 80, 120));
    draw_rectangle(mid - 55, cay, mid + 55, cab, false);
    draw_set_alpha(1);

    draw_set_halign(fa_center);
    var _ty  = cay + cah * 0.08;
    var _gap = 52;

    draw_set_color(make_color_rgb(100, 95, 70));
    draw_text_transformed(mid, _ty, "ONE  NAME", 2.2, 2.2, 0);

    draw_set_color(make_color_rgb(205, 185, 110));
    draw_text_transformed(mid, _ty + _gap * 1.2, "HARRINGTON.   \"H\".", 1.6, 1.6, 0);

    draw_set_color(make_color_rgb(80, 75, 55));
    draw_rectangle(mid - 200, _ty + _gap * 2.1, mid + 200, _ty + _gap * 2.1 + 2, false);

    draw_set_color(make_color_rgb(140, 120, 80));
    draw_text_transformed(mid, _ty + _gap * 2.5, "The letters. The fire. The program.", 1.0, 1.0, 0);

    draw_set_color(make_color_rgb(100, 88, 60));
    draw_text_transformed(mid, _ty + _gap * 3.3, "All of it signed by the same hand.", 1.0, 1.0, 0);

    draw_set_color(make_color_rgb(80, 75, 55));
    draw_rectangle(mid - 200, _ty + _gap * 4.1, mid + 200, _ty + _gap * 4.1 + 2, false);

    draw_set_color(make_color_rgb(180, 50, 50));
    draw_text_transformed(mid, _ty + _gap * 4.6, "Midnight.  Come alone.", 1.2, 1.2, 0);

    draw_set_halign(fa_left);
    break;

// ───────────────────────────────────────────────────────────
case 6: // FIND A WAY OUT — the fire owns the stairwell
// ───────────────────────────────────────────────────────────
    // Red alarm flash
    var _alp2 = 0.55 + sin(current_time * 0.045) * 0.38;
    draw_set_alpha(_alp2);
    draw_set_color(make_color_rgb(165, 12, 12));
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(_alp2 * 0.4);
    draw_set_color(c_white);
    draw_rectangle(0, cay, gw, cab, false);
    draw_set_alpha(1);
    // Falling debris / crack lines
    draw_set_color(make_color_rgb(30, 20, 12));
    for (var _cr2 = 0; _cr2 < 10; _cr2++) {
        var _crx2 = _cr2 * (gw / 9.0);
        var _cry2 = cay + (_cr2 * 47) mod (cah - 40);
        draw_line_width(_crx2, cay, _crx2 - 30 + (_cr2 * 23) mod 60, cab, 2 + (_cr2 mod 3));
        draw_rectangle(_crx2 + 10, _cry2, _crx2 + 28, _cry2 + 14, false);
    }
    // Big warning text
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(255, 255, 255));
    draw_text_transformed(mid + 5, cay + cah * 0.28 + 5, "FIND A WAY OUT", 4.5, 4.5, 0);
    draw_set_color(make_color_rgb(255, 40, 20));
    draw_text_transformed(mid,     cay + cah * 0.28,     "FIND A WAY OUT", 4.5, 4.5, 0);
    draw_set_color(c_white);
    draw_text_transformed(mid, cay + cah * 0.60, "The fire has taken the stairwell.", 1.05, 1.05, 0);
    draw_set_color(make_color_rgb(255, 160, 120));
    draw_text_transformed(mid, cay + cah * 0.73, "The only way out is up.  NOW.", 1.2, 1.2, 0);
    draw_set_halign(fa_left);
    break;

} // end switch

// ─────────────────────────────────────────────────────────────
// LETTERBOX BARS
// ─────────────────────────────────────────────────────────────
draw_set_alpha(1);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, lb, false);
draw_rectangle(0, gh - lb, gw, gh, false);

// ─────────────────────────────────────────────────────────────
// CONTINUE PROMPT
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
// PANEL LABEL
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

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
