// === obj_net — persistent leaderboard networking object ===
if (!variable_global_exists("lb_status")) global.lb_status = "";
if (!variable_global_exists("lb_list"))   global.lb_list   = [];
req_submit = -1;
req_fetch  = -1;
