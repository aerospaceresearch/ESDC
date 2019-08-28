function graphics_handles = plot_seed_point_3d(plot_case, lineage, n_gen)
  graphics_handles = {};
  [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
  if is_scatter_active(plot_case)
    if are_seed_points_active(plot_case)
      sizedata = plot_case.seed_points.sizedata;
      graphic_handle = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
      graphics_handles = [graphics_handles, graphic_handle];
    else
      graphic_handle = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color);
      graphics_handles = [graphics_handles, graphic_handle];
    end
  end
  if are_subsystems_bars_active(plot_case)
    graphics_handles_bar = plot_bar_3d(plot_case, lineage, n_gen);
    graphics_handles = [graphics_handles, graphics_handles_bar];
  end
end