function bool = is_plot_dof_continuous(plot_case, plot_dof)
  bool = strcmp(plot_case.(plot_dof).type, "continuous");
end