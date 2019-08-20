function bool = is_mutation_successful(lineage, n_gen)
  bool = lineage{n_gen}.evolution_success;
end