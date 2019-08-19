function [min_value, max_value] = get_visualization_min_max_dof_value(plot_case, evolution_data, n_input_case, dof)
  lineages = get_visualization_lineages(plot_case);
  lineage_idx = 0;
  for n_lineage = lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    lineage_idx = lineage_idx + 1;
    num_gens = numel(lineage);
    gen_idx = 0;
    dof_values = [];
    for n_gen = 1:num_gens
      if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
        gen_idx = gen_idx + 1;
        dof_values(gen_idx) = get_dof_value(lineage, n_gen, dof);
      end
    end
    min_values(lineage_idx) = min(dof_values);
    max_values(lineage_idx) = max(dof_values);
  end
  min_value = min(min_values);
  max_value = max(max_values);
end