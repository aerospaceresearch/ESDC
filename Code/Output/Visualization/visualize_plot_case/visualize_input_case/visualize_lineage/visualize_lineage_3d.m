function graphics_handles = visualize_lineage_3d(plot_case, lineage)
  num_gens = numel(lineage);
  if is_scatter_active(plot_case) && are_seed_points_active(plot_case)
    n_gen = 1;
    graphics_handles{n_gen} = plot_seed_point_3d(plot_case, lineage, n_gen);
  end
  for n_gen = 2:num_gens
    if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
      graphics_handles{n_gen} = plot_generation_3d(plot_case, lineage, n_gen);
    end
  end
end