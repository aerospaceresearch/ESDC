function n_last_sucessful_gen = get_last_sucessful_gen(lineage, n_gen)
  candidate_last_sucessful_gen = n_gen - 1;
  while ~is_mutation_successful(lineage, candidate_last_sucessful_gen)
    candidate_last_sucessful_gen = candidate_last_sucessful_gen - 1;
  end
  n_last_sucessful_gen = candidate_last_sucessful_gen;
end