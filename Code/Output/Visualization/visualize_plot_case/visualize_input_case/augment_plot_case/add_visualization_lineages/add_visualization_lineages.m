function plot_case = add_visualization_lineages(evolution_data, plot_case, n_input_case)
  dof = get_sorting_dof(plot_case);  
  dof_values = get_all_dof_values(evolution_data, n_input_case, dof);
  
  if strcmp(plot_case.lineages.sorting_direction,"increasing")
    lineages_values = min(dof_values);
    sorting_column = 2;
  elseif strcmp(plot_case.lineages.sorting_direction,"decreasing")
    lineages_values = max(dof_values);
    sorting_column = -2;
  end
  
  lineages_indexes = 1:get_number_of_lineages(evolution_data, n_input_case);
  sorted_indexes_values = sortrows([lineages_indexes', lineages_values'], sorting_column);
  
  sorted_indexes = sorted_indexes_values(:,1)';
  lineages = eval(sprintf("sorted_indexes(%s)", get_lineages_indexes(plot_case)));
  plot_case.visualization_lineages = lineages; 
end