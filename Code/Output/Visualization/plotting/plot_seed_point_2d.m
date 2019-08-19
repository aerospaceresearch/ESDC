function graphics_handles_seed_point = plot_seed_point_2d(plot_case, lineage, n_gen)
  [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen);
  sizedata = plot_case.seed_points.sizedata;
  graphics_handles_seed_point = {};
  graphic_handle = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
  graphics_handles_seed_point = [graphics_handles_seed_point, graphic_handle];
  if are_subsystems_bars_active(plot_case)
    graphics_handles = plot_bar_2d(plot_case, lineage, n_gen);
    graphics_handles_seed_point = [graphics_handles_seed_point, graphics_handles];
  end
end