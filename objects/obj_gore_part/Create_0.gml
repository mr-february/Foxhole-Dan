// type: 0=head  1=arm  2=leg  3=torso chunk  4=boot
part_type = irandom(4);
hspd  = random_range(-8, 8);
vspd  = random_range(-12, -4);
angle = random(360);
rot   = random_range(-20, 20);
life  = irandom_range(100, 180);
alpha = 1.0;
depth = -90;

switch (part_type) {
    case 0: pw = 6;  ph = 8;  break;   // head
    case 1: pw = 3;  ph = 11; break;   // arm
    case 2: pw = 3;  ph = 12; break;   // leg
    case 3: pw = 9;  ph = 8;  break;   // torso
    case 4: pw = 6;  ph = 4;  break;   // boot
}
