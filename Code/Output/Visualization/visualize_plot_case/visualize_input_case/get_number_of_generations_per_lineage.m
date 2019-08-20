function num_gens = get_number_of_generations_per_lineage(evolution_data, n_input_case)
  num_lineages = get_number_of_lineages(evolution_data, n_input_case);
  for n_lineage = 1:num_lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    num_gens(n_lineage) = numel(lineage);
  end
end