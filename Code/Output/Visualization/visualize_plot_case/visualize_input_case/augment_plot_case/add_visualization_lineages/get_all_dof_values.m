function dof_values = get_all_dof_values(evolution_data, n_input_case, dof)
  num_lineages = get_number_of_lineages(evolution_data, n_input_case);
  for n_lineage = 1:num_lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    num_gens = numel(lineage);
    for n_gen = 1:num_gens
      dof_values(n_gen, n_lineage) = get_dof_value(lineage, n_gen, dof);
    end
  end
end