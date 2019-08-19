function plot_case = add_max_number_of_generations(plot_case, evolution_data, n_input_case)
  num_gens = get_number_of_generations_per_lineage(evolution_data, n_input_case);
  min_gens = 1;
  max_gens = max(num_gens);
  plot_case.("x").min_value = min_gens;
  plot_case.("x").max_value = max_gens;
end