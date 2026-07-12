// === scr_net — global online leaderboard client (Phase 4b) ===
// Talks to /api/scores on the same Vercel deployment. Offline-safe: if the
// request fails, the game keeps its local high scores and just shows a status.

/// Make sure the persistent networking object exists.
function scr_net_ensure() {
    if (!variable_global_exists("lb_status")) {
        global.lb_status = "";
        global.lb_list   = [];
    }
    if (!instance_exists(obj_net)) {
        instance_create_layer(0, 0, "Instances", obj_net);
    }
}

/// Submit a run to the leaderboard. Board is e.g. "endless".
function scr_lb_submit(_board, _initials, _score, _wave) {
    scr_net_ensure();
    global.lb_status = "submitting...";
    var _body = json_stringify({
        board:    _board,
        initials: _initials,
        score:    _score,
        wave:     _wave
    });
    var _headers = ds_map_create();
    ds_map_add(_headers, "Content-Type", "application/json");
    obj_net.req_submit = http_request("/api/scores", "POST", _headers, _body);
    ds_map_destroy(_headers);
}

/// Fetch the current top-100 for a board into global.lb_list.
function scr_lb_fetch(_board) {
    scr_net_ensure();
    global.lb_status = "loading...";
    obj_net.req_fetch = http_get("/api/scores?board=" + string(_board));
}
