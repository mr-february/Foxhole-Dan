// === CRUMBLE TIMER ===
if (crumble_timer < 0) {
    // Trigger when Dan is standing on top (his feet touch our top edge)
    if (global.game_state == 0 && place_meeting(x, y - 1, obj_dan)) {
        crumble_timer = 40;
        audio_play_sound(snd_bullet_impact, 4, false);   // crack!
    }
} else {
    crumble_timer--;
    if (crumble_timer <= 0) {
        global.shake_mag = max(global.shake_mag, 1.5);
        instance_destroy();
    }
}
