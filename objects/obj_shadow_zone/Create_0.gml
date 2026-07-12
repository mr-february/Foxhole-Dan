// === obj_shadow_zone — a dark hiding region for the stealth level ===
// Guards can't see Dan while he overlaps a shadow zone (checked in obj_guard).
// Size is set here; place instances in the room creation code and override zw/zh if wanted.
zw = 220;   // half-width
zh = 200;   // half-height (from y upward)
depth = 200; // draw behind actors
