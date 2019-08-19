function graphics_handles = plot_bar_2d(plot_case, lineage, n_gen)
  graphics_handles = {};
  num_subsystems = get_number_of_subsystems(plot_case);
  subsystems_fieldnames = get_subsystems_fieldnames(plot_case);
  container_field = get_container_field(plot_case);
  line_type = get_subsystems_line_type(plot_case);
  line_colors = get_subsystems_line_colors(plot_case);
  line_width = get_subsystems_line_width(plot_case);
  x_plt = [n_gen, n_gen];
  prev_sum_mass_frac = 0;
  sum_mass_frac = 0;
  for n_subsystem = 1:num_subsystems
    dof = {container_field, subsystems_fieldnames{n_subsystem}};
    n_subsystem_mass_frac = get_dof_value(lineage, n_gen, dof);
    sum_mass_frac = sum_mass_frac + n_subsystem_mass_frac;
    y_plt = [prev_sum_mass_frac, sum_mass_frac];
    graphic_handle = plot(x_plt, y_plt, "linestyle", line_type, "color", line_colors(n_subsystem,:), "linewidth", line_width);
    graphics_handles = [graphics_handles, graphic_handle];
    prev_sum_mass_frac = sum_mass_frac;
  end
end