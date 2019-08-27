function dof_names = get_dof_names(plot_case, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if plot_case.appearance.custom_display_names.(plot_dof).active
      dof_names = plot_case.appearance.custom_display_names.(plot_dof).name;
    else
      dof_names = plot_case.(plot_dof).dof_values;
    end
    if strcmp(plot_dof, "line_color") || strcmp(plot_dof, "marker_color")
      dof_names = strcat(dof_names, sprintf(" [%.2f,%.2f]", plot_case.(plot_dof).min_value, plot_case.(plot_dof).max_value));
    end
  else
    dof_names = {};
  end
end
