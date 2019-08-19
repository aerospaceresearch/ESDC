function plot_value = get_plot_value(plot_case, lineage, n_gen, plot_dof)
  if is_mutation_successful(lineage, n_gen)
    plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
  else
    plot_value = get_plot_value_failed_mutation(plot_case, lineage, n_gen, plot_dof);
  end
end