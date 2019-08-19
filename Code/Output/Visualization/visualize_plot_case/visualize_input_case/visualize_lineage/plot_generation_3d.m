function graphics_handles_n_gen = plot_generation_3d(plot_case, lineage, n_gen)  
  graphics_handles_n_gen = {};
  if is_plot_line_active(plot_case)
    [x_plt3, y_plt3, z_plt3, line_type, line_color] = get_plot3_data(plot_case, lineage, n_gen);
    graphic_handle = plot3(x_plt3, y_plt3, z_plt3, "linestyle", line_type, "color", line_color);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphic_handle];
  end
  if is_scatter_active(plot_case)
    [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
    graphic_handle = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphic_handle];
  end
  if are_subsystems_bars_active(plot_case)
    graphics_handles = plot_bar_3d(plot_case, lineage, n_gen);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphics_handles];
  end
end