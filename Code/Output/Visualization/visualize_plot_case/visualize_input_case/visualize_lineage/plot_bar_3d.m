function graphics_handles = plot_bar_3d(plot_case, lineage, n_gen)
  graphics_handles = {};
  num_subsystems = get_number_of_subsystems(plot_case);
  subsystems_fieldnames = get_subsystems_fieldnames(plot_case);
  container_field = get_container_field(plot_case);
  line_type = get_subsystems_line_type(plot_case);
  line_colors = get_subsystems_line_colors(plot_case);
  line_width = get_subsystems_line_width(plot_case);
  [x_sctr3, y_sctr3, dum_z_sctr3, dum_marker_type, dum_marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
  x_plt3 = [x_sctr3, x_sctr3];
  y_plt3 = [y_sctr3, y_sctr3];
  prev_sum_mass_frac = 0;
  sum_mass_frac = 0;
  for n_subsystem = 1:num_subsystems
    dof = {container_field, subsystems_fieldnames{n_subsystem}};
    n_subsystem_mass_frac = get_dof_value(lineage, n_gen, dof);
    sum_mass_frac = sum_mass_frac + n_subsystem_mass_frac;
    z_plt3 = [prev_sum_mass_frac, sum_mass_frac];
    graphic_handle = plot3(x_plt3, y_plt3, z_plt3, "linestyle", line_type, "color", line_colors(n_subsystem,:), "linewidth", line_width);
    graphics_handles = [graphics_handles, graphic_handle];
    prev_sum_mass_frac = sum_mass_frac;
  end
end