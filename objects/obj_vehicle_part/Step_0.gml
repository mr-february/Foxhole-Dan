life--;
if (life <= 0) { instance_destroy(); exit; }
alpha = clamp(life / 20.0, 0.0, 1.0);
vspd += 0.55;
x    += hspd;
y    += vspd;
angle += spin;
if (place_meeting(x, y + sign(vspd), obj_platform)) {
    if (abs(vspd) > 1.5) vspd *= -0.38;
    else vspd = 0;
    hspd *= 0.60;
    spin *= 0.50;
}
