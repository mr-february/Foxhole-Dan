x    += hspd;
y    += vspd;
vspd += 0.35;
hspd *= 0.90;
life--;
alpha = life / max_life;
if (life <= 0) instance_destroy();
