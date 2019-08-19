function bool = use_custom_plot_values_for_failed_mutations(plot_case, plot_dof)
  bool = plot_case.failed_mutations.custom_plot_values.(plot_dof).active;
end