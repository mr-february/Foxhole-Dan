// === GRAVITY ===
vspd += 0.6;
if (vspd > 20) vspd = 20;

var grounded = place_meeting(x, y + 1, obj_platform);
if (grounded && vspd > 0) vspd = 0;

// === FIND PLAYER ===
var p    = noone;
var dist = 9999;
if (instance_exists(obj_dan)) {
    p    = instance_find(obj_dan, 0);
    dist = point_distance(x, y, p.x, p.y);
}

if (p != noone && dist < flee_range) {
    // === FLEE — run directly away from Dan ===
    var flee_dir = sign(x - p.x);
    if (flee_dir == 0) flee_dir = facing;
    // Don't sprint off a ledge
    if (grounded && !place_meeting(x + flee_dir * 16, y + 2, obj_platform)) flee_dir = 0;
    hspd   = flee_dir * move_spd * 1.4;
    facing = (flee_dir != 0) ? flee_dir : facing;

} else {
    // === PATROL — drift between wounded ===
    patrol_timer--;
    if (patrol_timer <= 0) {
        patrol_dir   *= -1;
        patrol_timer  = irandom(90) + 60;
    }
    hspd   = patrol_dir * move_spd * 0.5;
    facing = patrol_dir;
}

// === HEAL PULSE — every heal_cd frames, mend nearby wounded enemies ===
if (heal_timer > 0) heal_timer--;
if (heal_timer <= 0) {
    with (par_enemy) {
        if (id != other.id && object_index != obj_boss
        &&  point_distance(x, y, other.x, other.y) < other.heal_radius
        &&  variable_instance_exists(id, "max_hp") && hp < max_hp) {
            hp = min(hp + other.heal_amt, max_hp);
        }
    }
    heal_fx    = 22;
    heal_timer = heal_cd;
}

image_xscale = facing;

// === COLLISION - HORIZONTAL ===
if (place_meeting(x + hspd, y, obj_platform)) {
    hspd = 0;
    patrol_dir *= -1;
}
if (grounded && hspd != 0 && !place_meeting(x + sign(hspd) * 16, y + 2, obj_platform)) {
    hspd = 0;
    patrol_dir *= -1;
}
x += hspd;

// === COLLISION - VERTICAL ===
if (place_meeting(x, y + vspd, obj_platform)) {
    while (!place_meeting(x, y + sign(vspd), obj_platform)) y += sign(vspd);
    vspd = 0;
}
y += vspd;

if (heal_fx > 0) heal_fx--;
if (hit_flash > 0) hit_flash--;
if (i_frames > 0) i_frames--;
