// type: 0=wheel chunk  1=armor plate  2=engine piece  3=barrel fragment  4=cab panel
part_type = irandom(4);
hspd  = random_range(-7, 7);
vspd  = random_range(-11, -3);
angle = random(360);
spin  = random_range(-18, 18);
life  = irandom_range(80, 140);
alpha = 1.0;
depth = -95;

switch (part_type) {
    case 0: pw = 12; ph = 12; break;
    case 1: pw = 14; ph =  7; break;
    case 2: pw =  9; ph =  9; break;
    case 3: pw = 16; ph =  3; break;
    case 4: pw = 11; ph =  8; break;
}
