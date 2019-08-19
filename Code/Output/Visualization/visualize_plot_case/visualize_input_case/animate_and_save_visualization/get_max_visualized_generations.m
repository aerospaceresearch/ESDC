function max_gens = get_max_visualized_generations(graphics_handles)
  num_gens = get_number_of_visualized_generations_per_lineage(graphics_handles);
  max_gens = max(num_gens);
end