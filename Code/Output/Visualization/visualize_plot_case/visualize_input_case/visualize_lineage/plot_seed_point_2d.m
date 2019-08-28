function graphics_handles = plot_seed_point_2d(plot_case, lineage, n_gen)
  graphics_handles = {};
  [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen);
  if is_scatter_active(plot_case)
    if are_seed_points_active(plot_case)
      sizedata = plot_case.seed_points.sizedata;
      graphic_handle = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
      graphics_handles = [graphics_handles, graphic_handle];
    else
      graphic_handle = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color);
      graphics_handles = [graphics_handles, graphic_handle];
    end
  end
  if are_subsystems_bars_active(plot_case)
    graphics_handles_bar = plot_bar_2d(plot_case, lineage, n_gen);
    graphics_handles = [graphics_handles, graphics_handles_bar];
  end
end