global.game_state = 0;
depth = -9999;              // step last every frame — camera override runs after Dan's
cam_y = 2466;  // Dan.y(2888) - cam_h*0.55(422), keeps Dan at 55% from top
camera_set_view_pos(view_camera[0], 0, 2466);  // apply immediately — don't wait for first Step
