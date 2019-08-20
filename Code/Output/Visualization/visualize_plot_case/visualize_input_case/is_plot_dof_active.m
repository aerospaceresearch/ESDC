function bool = is_plot_dof_active(plot_case, plot_dof)
  bool = plot_case.(plot_dof).active;
end