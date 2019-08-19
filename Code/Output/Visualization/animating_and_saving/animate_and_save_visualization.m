function [] = animate_and_save_visualization(plot_case, fig, graphics_handles)
  if is_animate_and_save_active(plot_case)
    hide_all_graphics(graphics_handles);
    filename = get_visualization_filename(plot_case);
    folder = "Output/";
    if strcmp(get_animation_order(plot_case), "by_lineage")
      filename_with_path = strcat(folder, filename, "_animation_by_lineage.gif");
      animate_and_save_visualization_by_lineage(plot_case, fig, graphics_handles, filename_with_path);
    elseif strcmp(get_animation_order(plot_case), "by_generation")
      filename_with_path = strcat(folder, filename, "_animation_by_generation.gif");
      animate_and_save_visualization_by_generation(plot_case, fig, graphics_handles, filename_with_path);
    end 
  end
end