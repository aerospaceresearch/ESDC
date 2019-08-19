function time_step = get_animation_time_step(plot_case)
  fps = get_fps(plot_case);
  time_step = 1/fps;
end