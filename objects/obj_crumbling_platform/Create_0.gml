// === CRUMBLING ICE LEDGE ===
// Child of obj_platform (same spr_platform mask, solid) so obj_dan's existing
// place_meeting(obj_platform) collision treats it as ground while intact.
// Once Dan stands on it, it shakes for ~40 frames and then breaks away.

crumble_timer = -1;   // -1 = intact / untriggered
