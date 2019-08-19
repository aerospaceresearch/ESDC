function num_gens = get_number_of_visualized_generations_per_lineage(graphics_handles)
  num_lineages = numel(graphics_handles);
  for n_lineage = 1:num_lineages
    num_gens(n_lineage) = numel(graphics_handles{n_lineage});
  end
end