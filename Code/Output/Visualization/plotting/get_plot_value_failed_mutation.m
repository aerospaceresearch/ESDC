function plot_value = get_plot_value_failed_mutation(plot_case, lineage, n_gen, plot_dof)
  if strcmp(plot_dof,"x") || strcmp(plot_dof,"y") || strcmp(plot_dof,"z")
    plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
  elseif strcmp(plot_dof,"line_type") || strcmp(plot_dof,"line_color") || strcmp(plot_dof,"marker_type") || strcmp(plot_dof,"marker_color")
    if use_custom_plot_values_for_failed_mutations(plot_case, plot_dof)
      plot_value = plot_case.failed_mutations.custom_plot_values.(plot_dof).custom_plot_value;
    else
      plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
    end
  end
end