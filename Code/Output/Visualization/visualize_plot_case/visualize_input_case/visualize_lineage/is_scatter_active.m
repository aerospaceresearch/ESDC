function bool = is_scatter_active(plot_case)
  bool = is_plot_dof_active(plot_case, "marker_type") || is_plot_dof_active(plot_case, "marker_color");
end