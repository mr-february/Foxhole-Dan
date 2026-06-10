life--;
if (life <= 0) { instance_destroy(); exit; }

vspd  += 0.6;
x     += hspd;
y     += vspd;
angle += spin;

if (place_meeting(x, y + sign(vspd), obj_platform)) {
    if (abs(vspd) > 1.5) vspd *= -0.42;
    else vspd = 0;
    hspd *= 0.55;
    spin *= 0.45;
}
