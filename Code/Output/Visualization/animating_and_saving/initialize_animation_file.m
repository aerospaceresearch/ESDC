function [] = initialize_animation_file(filename, fig, plot_case)
  time_step = get_animation_time_step(plot_case);
  [A, map] = get_indexed_image(fig);
  if is_animation_compression_active(plot_case)
    imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',time_step,'Compression','lzw');
  else
    imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',time_step);
  end
end