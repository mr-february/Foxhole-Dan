// === Async HTTP — leaderboard responses ===
var _id     = async_load[? "id"];
var _status = async_load[? "status"];

// status 0 = finished OK; 1 = still downloading; <0 = error.
if (_status < 0) {
    global.lb_status = "offline";
    exit;
}
if (_status != 0) exit;   // partial/in-progress

var _result = async_load[? "result"];

if (_id == req_submit || _id == req_fetch) {
    var _parsed = undefined;
    try {
        _parsed = json_parse(_result);
    } catch (_e) {
        global.lb_status = "error";
        exit;
    }
    if (is_struct(_parsed) && variable_struct_exists(_parsed, "scores")) {
        global.lb_list = _parsed.scores;
        if (is_struct(_parsed) && variable_struct_exists(_parsed, "offline") && _parsed.offline) {
            global.lb_status = "offline (no board yet)";
        } else {
            global.lb_status = (_id == req_submit) ? "submitted!" : "ok";
        }
    } else {
        global.lb_status = "error";
    }
}
