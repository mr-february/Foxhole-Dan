x    += hspd;
y    += vspd;
vspd += 0.48;
hspd *= 0.97;
angle += rot;
life--;
alpha = clamp(life / 80.0, 0, 1);

if (place_meeting(x, y + 1, obj_platform) && vspd > 0) {
    vspd *= -0.28;
    hspd *= 0.62;
    rot  *= 0.45;
    if (abs(vspd) < 0.9) { vspd = 0; rot = 0; }
}

if (life <= 0) instance_destroy();
