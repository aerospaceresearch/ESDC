function graphics_handles_n_gen = plot_generation_2d(plot_case, lineage, n_gen)
  graphics_handles_n_gen = {};
  if is_plot_line_active(plot_case)
    [x_plt, y_plt, line_type, line_color] = get_plot_data(plot_case, lineage, n_gen);
    graphic_handle = plot(x_plt, y_plt, "linestyle", line_type, "color", line_color);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphic_handle];
  end
  if is_scatter_active(plot_case)
    [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen);
    graphic_handle = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphic_handle];
  end
  if are_subsystems_bars_active(plot_case)
    graphics_handles = plot_bar_2d(plot_case, lineage, n_gen);
    graphics_handles_n_gen = [graphics_handles_n_gen, graphics_handles];
  end
end