var cx  = camera_get_view_x(view_camera[0]);
var cy  = camera_get_view_y(view_camera[0]);
var vw  = camera_get_view_width(view_camera[0]);
var vh  = camera_get_view_height(view_camera[0]);
var tt  = current_time * 0.001;
var gnd = 490; // ground line y

// =========================================================
// SKY — apocalyptic crimson / charcoal (20-band gradient)
// =========================================================
for (var si = 0; si < 20; si++) {
    var sf = si / 20.0;
    draw_set_color(make_color_rgb(
        round(lerp(4,   115, sf)),
        round(lerp(2,    28, sf)),
        round(lerp(10,   12, sf))
    ));
    draw_rectangle(cx, cy + si * (gnd / 20.0), cx + vw, cy + (si + 1) * (gnd / 20.0), false);
}

// =========================================================
// BLOOD MOON — half-occluded, atmospheric smoke tint
// =========================================================
var moon_x = cx + 1400;
var moon_y = cy + 80;
// Outer glow halo
draw_set_alpha(0.14 + 0.07 * sin(tt * 0.35));
draw_set_color(make_color_rgb(255, 180, 80));
draw_circle(moon_x, moon_y, 74, false);
draw_set_alpha(0.22);
draw_circle(moon_x, moon_y, 56, false);
draw_set_alpha(1);
// Moon disc (blood orange — atmospheric scattering through smoke)
draw_set_color(make_color_rgb(238, 165, 60));
draw_circle(moon_x, moon_y, 42, false);
draw_set_color(make_color_rgb(255, 200, 95));
draw_circle(moon_x, moon_y, 35, false);
// Shadowing — left half darker (makes it feel like a partial eclipse)
draw_set_alpha(0.5);
draw_set_color(make_color_rgb(160, 55, 15));
draw_ellipse(moon_x - 42, moon_y - 42, moon_x + 8, moon_y + 42, false);
draw_set_alpha(1);

// Smoke clouds drifting across the moon (time-animated)
for (var mc = 0; mc < 4; mc++) {
    var mcf = ((tt * 0.035 + mc * 0.25) mod 1.0);
    var mcx = cx + mcf * (vw + 400) - 200 + mc * 160;
    var mcy = cy + moon_y - cy - 20 + mc * 12;
    draw_set_alpha(0.6 + mc * 0.08);
    draw_set_color(make_color_rgb(14, 10, 8));
    draw_ellipse(mcx - 90, mcy - 24, mcx + 80, mcy + 24, false);
    draw_ellipse(mcx + 20, mcy - 16, mcx + 160, mcy + 18, false);
    draw_set_alpha(1);
}

// =========================================================
// STORM CLOUDS — rolling dark masses with fire glow underneath
// =========================================================
var cbase_cols = [
    make_color_rgb(22, 14, 10),
    make_color_rgb(34, 20, 14),
    make_color_rgb(16, 10, 8),
];
for (var cl = 0; cl < 3; cl++) {
    var cp = tt * (9.0 + cl * 5.5);
    var cw = 400 + cl * 100;
    var cbase = cy + cl * 52;
    for (var ci = 0; ci < 12; ci++) {
        var cbx = cx + ci * cw - (cp mod cw);
        var ch  = 72 + (ci * 53 + cl * 37) mod 78;
        draw_set_color(cbase_cols[cl]);
        draw_set_alpha(0.88);
        draw_ellipse(cbx - 24, cbase, cbx + cw * 0.56, cbase + ch, false);
        draw_ellipse(cbx + cw * 0.28, cbase + 10, cbx + cw * 0.9, cbase + ch * 0.78, false);
        // Orange fire-lit underbelly
        draw_set_alpha(0.09 + 0.08 * abs(sin(tt * 0.9 + ci * 1.5)));
        draw_set_color(make_color_rgb(220, 80, 10));
        draw_ellipse(cbx, cbase + ch * 0.68, cbx + cw * 0.72, cbase + ch, false);
        draw_set_alpha(1);
    }
}

// =========================================================
// DEEP BACKGROUND — distant suburb silhouettes (parallax 0.05)
// =========================================================
var p0 = cx * 0.05;
for (var bk = 0; bk < 22; bk++) {
    var bkx = cx + bk * 280 - (p0 mod 280);
    var bkh = 52 + (bk * 67 + 11) mod 68;
    var bkw = 54 + (bk * 43 + 17) mod 48;
    draw_set_color(make_color_rgb(15, 9, 6));
    // House body
    draw_rectangle(bkx, cy + gnd - 62 - bkh, bkx + bkw, cy + gnd - 62, false);
    // Peaked roof
    draw_triangle(bkx - 4, cy + gnd - 62 - bkh,
                  bkx + bkw + 4, cy + gnd - 62 - bkh,
                  bkx + bkw * 0.5, cy + gnd - 62 - bkh - 28, false);
    // Chimney
    if (bk mod 3 != 0) {
        draw_rectangle(bkx + bkw * 0.65, cy + gnd - 62 - bkh - 40,
                       bkx + bkw * 0.65 + 8, cy + gnd - 62 - bkh, false);
    }
    // Fire inside — everything burning
    var bkf = 0.4 + 0.5 * abs(sin(tt * 2.6 + bk * 2.1));
    draw_set_alpha(bkf * 0.72);
    draw_set_color(make_color_rgb(230, 95, 12));
    draw_rectangle(bkx + 4, cy + gnd - 62 - bkh + 14, bkx + bkw - 4, cy + gnd - 62, false);
    draw_set_alpha(bkf * 0.4);
    draw_set_color(make_color_rgb(255, 200, 55));
    draw_rectangle(bkx + 10, cy + gnd - 62 - bkh + 22, bkx + bkw - 10, cy + gnd - 62, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(15, 9, 6));
}

// =========================================================
// ENEMY ARTILLERY HORIZON — constant orange pulse + gun positions
// =========================================================
var hg = 0.48 + 0.44 * abs(sin(tt * 1.1)) * abs(sin(tt * 0.72 + 0.9));
draw_set_alpha(hg * 0.82);
draw_set_color(make_color_rgb(215, 85, 10));
draw_rectangle(cx, cy + gnd - 115, cx + vw, cy + gnd - 82, false);
draw_set_alpha(hg * 0.58);
draw_set_color(make_color_rgb(255, 165, 38));
draw_rectangle(cx, cy + gnd - 94, cx + vw, cy + gnd - 82, false);
draw_set_alpha(1);
// Gun silhouettes on horizon (every 300px)
draw_set_color(make_color_rgb(12, 8, 5));
for (var gs = 0; gs < 7; gs++) {
    var gsx = cx + 120 + gs * 270;
    // Gun barrel pointing right-upward
    draw_rectangle(gsx, cy + gnd - 104, gsx + 14, cy + gnd - 92, false);
    draw_line_width(gsx + 7, cy + gnd - 104, gsx + 50, cy + gnd - 116, 4);
    // Wheel
    draw_circle(gsx + 4, cy + gnd - 92, 7, true);
    draw_circle(gsx + 14, cy + gnd - 92, 7, true);
}

// =========================================================
// ARTILLERY FLASH — incoming shell bursts
// =========================================================
if (flash_timer > 0) {
    var fa = min(flash_timer / 8.0, 1.0);
    draw_set_alpha(fa * 0.95);
    draw_set_color(make_color_rgb(255, 245, 175));
    draw_ellipse(flash_x - flash_size * 1.15, flash_y - flash_size * 0.65,
                 flash_x + flash_size * 1.15, flash_y + flash_size * 0.32, false);
    draw_set_alpha(fa * 0.80);
    draw_set_color(c_white);
    draw_circle(flash_x, flash_y, flash_size * 0.38, false);
    // Shockwave ring
    draw_set_alpha(fa * 0.35);
    draw_set_color(make_color_rgb(255, 200, 100));
    draw_circle(flash_x, flash_y, flash_size * 0.9, true);
    draw_set_alpha(1);
}

// =========================================================
// MID BURNING NEIGHBORHOOD — closer suburb on fire (parallax 0.15)
// =========================================================
var p1 = cx * 0.15;
for (var nh = 0; nh < 14; nh++) {
    var nhx = cx + nh * 340 - (p1 mod 340);
    var nhh = 66 + (nh * 59 + 7) mod 78;
    var nhw = 70 + (nh * 37 + 23) mod 58;
    draw_set_color(make_color_rgb(18, 11, 7));
    // House body
    draw_rectangle(nhx, cy + gnd - 78 - nhh, nhx + nhw, cy + gnd - 78, false);
    // Peaked roof
    draw_triangle(nhx - 5, cy + gnd - 78 - nhh,
                  nhx + nhw + 5, cy + gnd - 78 - nhh,
                  nhx + nhw * 0.5, cy + gnd - 78 - nhh - 34, false);
    // Chimney with ash
    draw_rectangle(nhx + nhw * 0.7, cy + gnd - 78 - nhh - 46,
                   nhx + nhw * 0.7 + 10, cy + gnd - 78 - nhh, false);
    // Window frames (dark cutouts)
    draw_set_color(make_color_rgb(12, 7, 4));
    draw_rectangle(nhx + nhw * 0.12, cy + gnd - 78 - nhh + 20,
                   nhx + nhw * 0.34, cy + gnd - 78 - nhh + 42, false);
    draw_rectangle(nhx + nhw * 0.62, cy + gnd - 78 - nhh + 20,
                   nhx + nhw * 0.84, cy + gnd - 78 - nhh + 42, false);
    // Flames bursting from roof
    var nhf = 0.55 + 0.4 * sin(tt * 3.2 + nh * 1.8);
    draw_set_alpha(nhf * 0.92);
    draw_set_color(make_color_rgb(240, 95, 12));
    draw_ellipse(nhx + 6, cy + gnd - 78 - nhh - 36, nhx + nhw - 6, cy + gnd - 78 - nhh + 22, false);
    draw_set_alpha(nhf * 0.65);
    draw_set_color(make_color_rgb(255, 200, 55));
    draw_ellipse(nhx + 18, cy + gnd - 78 - nhh - 24, nhx + nhw - 18, cy + gnd - 78 - nhh + 12, false);
    draw_set_alpha(1);
    draw_set_color(make_color_rgb(18, 11, 7));
}

// =========================================================
// THICK SMOKE COLUMNS rising from burning neighborhood
// =========================================================
for (var sc = 0; sc < 12; sc++) {
    var scx = cx + 50 + sc * 162;
    var sc_rise = 260 + (sc * 47) mod 140;
    for (var sm = 0; sm < 9; sm++) {
        var smf = ((tt * 0.20 + sm * 0.11 + sc * 0.19) mod 1.0);
        var smy = cy + gnd - 78 - smf * sc_rise;
        if (smy < cy || smy > cy + gnd) continue;
        draw_set_alpha(0.30 * (1.0 - smf));
        draw_set_color(make_color_rgb(40, 32, 24));
        draw_circle(scx + sin(smf * 9 + sm + sc) * 16, smy, 9 + smf * 36, false);
    }
}
draw_set_alpha(1);

// =========================================================
// PARACHUTE ILLUMINATION FLARES — slowly descending, cast light cones
// =========================================================
for (var fl = 0; fl < array_length(flare_x); fl++) {
    var fy2 = cy + flare_y[fl];
    var fx2 = cx + flare_x[fl] + sin(tt * 0.85 + fl * 2.2) * 14;
    if (fy2 < cy - 10 || fy2 > cy + gnd + 10) continue;

    // Light cone below flare (reaches toward ground)
    var cone_bot = min(fy2 + 180, cy + gnd);
    var cone_len = cone_bot - fy2;
    if (cone_len > 4) {
        draw_set_alpha(0.13 + 0.05 * sin(tt * 2.2 + fl));
        draw_set_color(make_color_rgb(255, 240, 180));
        draw_triangle(fx2, fy2,
                      fx2 - 70, cone_bot,
                      fx2 + 70, cone_bot, false);
        draw_set_alpha(1);
    }
    // Flare halo
    draw_set_alpha(0.28 + 0.14 * sin(tt * 3.1 + fl));
    draw_set_color(make_color_rgb(255, 220, 100));
    draw_circle(fx2, fy2, 24, false);
    // Flare core
    draw_set_alpha(0.80 + 0.18 * sin(tt * 4.4 + fl));
    draw_set_color(make_color_rgb(255, 252, 200));
    draw_circle(fx2, fy2, 7, false);
    draw_set_alpha(1);
    // Parachute canopy
    draw_set_color(make_color_rgb(185, 175, 145));
    draw_ellipse(fx2 - 12, fy2 - 28, fx2 + 12, fy2 - 6, false);
    // Suspension lines
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(160, 150, 125));
    draw_line(fx2 - 9, fy2 - 10, fx2, fy2);
    draw_line(fx2 + 9, fy2 - 10, fx2, fy2);
    draw_set_alpha(1);
}

// =========================================================
// SEARCHLIGHT BEAMS — from defense positions, sweeping sky
// =========================================================
var sl1a = sin(tt * 0.75) * 36 - 82;
var sl2a = sin(tt * 0.52 + 1.6) * 30 - 98;
// Beam 1
draw_set_alpha(0.11 + 0.04 * sin(tt * 0.75));
draw_set_color(make_color_rgb(235, 235, 210));
draw_triangle(cx + 190, cy + gnd + 40,
    cx + 190 + lengthdir_x(720, sl1a) - 44, cy + gnd + 40 + lengthdir_y(720, sl1a),
    cx + 190 + lengthdir_x(720, sl1a) + 44, cy + gnd + 40 + lengthdir_y(720, sl1a), false);
// Beam 2
draw_triangle(cx + vw - 190, cy + gnd + 40,
    cx + vw - 190 + lengthdir_x(720, sl2a) - 38, cy + gnd + 40 + lengthdir_y(720, sl2a),
    cx + vw - 190 + lengthdir_x(720, sl2a) + 38, cy + gnd + 40 + lengthdir_y(720, sl2a), false);
draw_set_alpha(1);
// Searchlight lamp fixtures
draw_set_color(make_color_rgb(200, 195, 170));
draw_circle(cx + 190, cy + gnd + 40, 9, false);
draw_set_color(make_color_rgb(255, 252, 220));
draw_circle(cx + 190, cy + gnd + 40, 5, false);
draw_set_color(make_color_rgb(200, 195, 170));
draw_circle(cx + vw - 190, cy + gnd + 40, 9, false);
draw_set_color(make_color_rgb(255, 252, 220));
draw_circle(cx + vw - 190, cy + gnd + 40, 5, false);

// =========================================================
// GROUND — scorched, cratered, smoldering
// =========================================================
draw_set_color(make_color_rgb(25, 18, 11));
draw_rectangle(cx, cy + gnd, cx + vw, cy + vh, false);
// Charred variation strips
for (var di = 0; di < 24; di++) {
    var dx = cx + di * 95;
    draw_set_color(make_color_rgb(36 + di mod 6 * 4, 27 + di mod 4 * 3, 15 + di mod 3 * 2));
    draw_rectangle(dx, cy + gnd, dx + 52 + di mod 6 * 10, cy + gnd + 5, false);
}
// Shell craters — large, deep, some still smoking
for (var cr = 0; cr < 14; cr++) {
    var crx = cx + 50 + cr * 138;
    var crr = 18 + (cr * 31) mod 20;
    draw_set_color(make_color_rgb(14, 9, 5));
    draw_ellipse(crx - crr, cy + gnd - 2, crx + crr, cy + gnd + crr * 0.55, false);
    // Crater rim (raised dirt)
    draw_set_color(make_color_rgb(52, 42, 28));
    draw_ellipse(crx - crr - 5, cy + gnd - 4, crx + crr + 5, cy + gnd + 2, false);
    // Smoldering embers inside
    var crf = 0.25 + 0.3 * sin(tt * 2.5 + cr * 1.9);
    draw_set_alpha(crf * 0.6);
    draw_set_color(make_color_rgb(200, 75, 8));
    draw_ellipse(crx - 7, cy + gnd + 2, crx + 7, cy + gnd + 9, false);
    draw_set_alpha(1);
}

// =========================================================
// ENEMY TANK COLUMN — large imposing silhouettes advancing
// =========================================================
var trow_y   = [cy + gnd - 88, cy + gnd - 70, cy + gnd - 50];
var trow_sc  = [0.45, 0.63, 0.86];
var trow_col = [
    make_color_rgb(20, 15, 10),
    make_color_rgb(30, 22, 15),
    make_color_rgb(40, 30, 20),
];

for (var tk = 0; tk < array_length(tank_x); tk++) {
    var tkx = cx + tank_x[tk];
    var tkr = tk mod 3;
    var tky = trow_y[tkr];
    var tks = trow_sc[tkr];
    if (tkx < cx - 120 || tkx > cx + vw + 120) continue;
    var tw2 = round(54 * tks);
    var th2 = round(18 * tks);
    draw_set_color(trow_col[tkr]);
    // Hull
    draw_rectangle(tkx - tw2, tky - th2, tkx + tw2, tky + round(10 * tks), false);
    // Turret
    draw_rectangle(tkx - round(17 * tks), tky - th2 - round(14 * tks),
                   tkx + round(22 * tks),  tky - th2, false);
    // Gun barrel
    draw_line_width(tkx + round(22 * tks), tky - th2 - round(7 * tks),
                    tkx + round(22 * tks) + round(42 * tks), tky - th2 - round(10 * tks),
                    max(1, round(3 * tks)));
    // Track skirts (darker stripe)
    draw_set_color(make_color_rgb(12, 9, 6));
    draw_rectangle(tkx - tw2 - 4, tky - round(6 * tks), tkx + tw2 + 4, tky + round(12 * tks), false);
    // Random muzzle flash
    if (irandom(160) == 0) {
        draw_set_alpha(0.92);
        draw_set_color(make_color_rgb(255, 230, 110));
        draw_circle(tkx + round(64 * tks), tky - th2 - round(10 * tks), round(11 * tks), false);
        draw_set_alpha(1);
    }
}

// =========================================================
// MARCHING ENEMY SOLDIERS — 3 depth rows, all advancing
// =========================================================
var srow_y   = [cy + gnd - 80, cy + gnd - 63, cy + gnd - 45];
var srow_sc  = [0.40, 0.58, 0.78];
var srow_col = [
    make_color_rgb(24, 27, 20),
    make_color_rgb(34, 38, 28),
    make_color_rgb(45, 51, 36),
];

for (var si2 = 0; si2 < 32; si2++) {
    var mx  = cx + march_x[si2];
    var mr  = march_row[si2];
    var my2 = srow_y[mr];
    var msc = srow_sc[mr];
    if (mx < cx - 30 || mx > cx + vw + 30) continue;

    var bob     = sin(tt * 8.5 + march_x[si2] * 0.3) * 2.0 * msc;
    var sw      = round(4  * msc);
    var sh_body = round(13 * msc);
    var sh_head = round(5  * msc);
    var sh_leg  = round(8  * msc);
    var lsway   = sin(tt * 9.5 + march_x[si2] * 0.35) * 3.5 * msc;

    draw_set_color(srow_col[mr]);
    draw_rectangle(mx - sw, my2 - sh_body + bob, mx + sw, my2 + bob, false);
    draw_set_color(make_color_rgb(26, 28, 22));
    draw_ellipse(mx - sw, my2 - sh_body - sh_head + bob, mx + sw, my2 - sh_body + bob, false);
    draw_set_color(srow_col[mr]);
    draw_rectangle(mx - sw, my2 + bob,       mx - 1,  my2 + sh_leg + lsway + bob, false);
    draw_rectangle(mx + 1,  my2 + bob,       mx + sw, my2 + sh_leg - lsway + bob, false);
    draw_set_color(make_color_rgb(46, 34, 18));
    draw_line(mx + sw + 1, my2 - sh_body * 0.5 + bob,
              mx + sw + 1 + round(10 * msc), my2 - sh_body * 0.95 + bob);
}

// =========================================================
// TRACER ROUNDS — incoming fire streaks from enemy line
// =========================================================
for (var tr2 = 0; tr2 < array_length(tracer_x); tr2++) {
    if (!tracer_active[tr2]) continue;
    var trx  = cx + tracer_x[tr2];
    var try2 = cy + tracer_y[tr2];
    if (trx < cx - 30 || trx > cx + vw + 30) continue;
    // Trail glow
    draw_set_alpha(0.38);
    draw_set_color(make_color_rgb(255, 160, 40));
    draw_line_width(trx - 28, try2, trx + 65, try2 + 4, 5);
    // Core streak
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(255, 245, 120));
    draw_line_width(trx, try2, trx + 65, try2 + 4, 2);
    draw_set_alpha(1);
}

// =========================================================
// BURNING VEHICLE WRECKS — dramatic multi-layer fire
// =========================================================
for (var bv = 0; bv < array_length(burn_x); bv++) {
    var bvx = cx + burn_x[bv];
    var bvy = cy + burn_y[bv];
    // Mangled hull
    draw_set_color(make_color_rgb(22, 16, 10));
    draw_rectangle(bvx - 44, bvy - 18, bvx + 44, bvy + 13, false);
    draw_rectangle(bvx - 32, bvy - 32, bvx + 32, bvy - 18, false);
    // Blown turret (canted)
    draw_rectangle(bvx - 20, bvy - 48, bvx + 24, bvy - 32, false);
    draw_line_width(bvx + 14, bvy - 42, bvx + 52, bvy - 48, 4);
    // Destroyed tracks
    draw_set_color(make_color_rgb(16, 11, 7));
    draw_rectangle(bvx - 48, bvy - 9, bvx + 48, bvy + 16, false);
    // Fire layers
    var bf = 0.58 + 0.36 * sin(tt * 3.5 + bv * 2.4);
    draw_set_alpha(bf * 0.92);
    draw_set_color(make_color_rgb(238, 90, 10));
    draw_ellipse(bvx - 32, bvy - 80, bvx + 32, bvy - 18, false);
    draw_set_alpha(bf * 0.70);
    draw_set_color(make_color_rgb(255, 175, 28));
    draw_ellipse(bvx - 18, bvy - 66, bvx + 18, bvy - 22, false);
    draw_set_alpha(bf * 0.50);
    draw_set_color(make_color_rgb(255, 242, 130));
    draw_ellipse(bvx - 8, bvy - 54, bvx + 8, bvy - 30, false);
    draw_set_alpha(1);
    // Flying embers
    for (var sp = 0; sp < 6; sp++) {
        var spf = ((tt * 0.85 + sp * 0.17 + bv * 0.28) mod 1.0);
        var spy = bvy - 18 - spf * 100;
        var spx = bvx + sin(spf * 12 + sp) * 22;
        draw_set_alpha((1.0 - spf) * 0.75);
        draw_set_color(make_color_rgb(255, 155, 15));
        draw_point(spx, spy);
    }
    draw_set_alpha(1);
}

// =========================================================
// GROUND FIRE PATCHES — burning fuel / napalm on the field
// =========================================================
for (var gf = 0; gf < 7; gf++) {
    var gfx = cx + 180 + gf * 248;
    var gff = 0.5 + 0.44 * sin(tt * 4.1 + gf * 2.5);
    draw_set_alpha(gff * 0.72);
    draw_set_color(make_color_rgb(225, 80, 8));
    draw_ellipse(gfx - 24, cy + gnd - 12, gfx + 24, cy + gnd + 5, false);
    draw_set_alpha(gff * 0.5);
    draw_set_color(make_color_rgb(255, 180, 38));
    draw_ellipse(gfx - 11, cy + gnd - 20, gfx + 11, cy + gnd - 2, false);
    draw_set_alpha(1);
}

// =========================================================
// BARBED WIRE FOREGROUND — defensive perimeter
// =========================================================
draw_set_color(make_color_rgb(20, 16, 12));
// Wooden stakes
for (var wf2 = 0; wf2 < 9; wf2++) {
    var wx = cx + wf2 * 222;
    draw_rectangle(wx + 10, cy + gnd + 6, wx + 14, cy + gnd + 34, false);
    draw_triangle(wx + 10, cy + gnd + 6, wx + 14, cy + gnd + 6, wx + 12, cy + gnd - 2, false);
}
// Wire strands (two lines)
draw_set_alpha(0.72);
draw_set_color(make_color_rgb(28, 22, 16));
draw_line_width(cx, cy + gnd + 14, cx + vw, cy + gnd + 16, 1);
draw_line_width(cx, cy + gnd + 22, cx + vw, cy + gnd + 21, 1);
draw_set_alpha(1);
// Barb ticks
draw_set_color(make_color_rgb(32, 26, 18));
for (var wb = 0; wb < 18; wb++) {
    var wbx = cx + 28 + wb * 108;
    var wby = cy + gnd + 14 + (wb mod 2) * 8;
    draw_line(wbx,     wby, wbx + 5, wby - 5);
    draw_line(wbx,     wby, wbx + 5, wby + 5);
    draw_line(wbx + 3, wby, wbx - 2, wby - 5);
}

// =========================================================
// ATMOSPHERIC WAR HAZE — deep red/orange, thick and dramatic
// =========================================================
draw_set_alpha(0.17);
draw_set_color(make_color_rgb(130, 52, 14));
draw_rectangle(cx, cy, cx + vw, cy + vh, false);
// Extra glow near horizon
draw_set_alpha(0.10);
draw_set_color(make_color_rgb(200, 90, 20));
draw_rectangle(cx, cy + gnd - 120, cx + vw, cy + gnd + 20, false);
draw_set_alpha(1);

draw_set_color(c_white);
