function legend_names = get_legend_names(plot_case)
  line_type_names = get_dof_names(plot_case, "line_type");
  line_color_names = get_dof_names(plot_case, "line_color");
  marker_type_names = get_dof_names(plot_case, "marker_type");
  marker_color_names = get_dof_names(plot_case, "marker_color");
  subsystems_names = get_subsystems_names(plot_case);
  legend_names = [line_type_names, marker_type_names, line_color_names, marker_color_names, subsystems_names];
end