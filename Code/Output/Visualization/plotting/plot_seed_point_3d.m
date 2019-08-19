function graphics_handles_seed_point = plot_seed_point_3d(plot_case, lineage, n_gen)
  [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
  sizedata = plot_case.seed_points.sizedata;
  graphics_handles_seed_point{1} = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
  if are_subsystems_bars_active(plot_case)
    graphics_handles = plot_bar_3d(plot_case, lineage, n_gen);
    graphics_handles_seed_point = [graphics_handles_seed_point, graphics_handles];
  end
end