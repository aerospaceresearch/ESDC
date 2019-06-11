function evolution_data = evolver(input, db_data, config)
  generation = {};
  n_gen = 1;
  % use input to seed the parameter space
  generation{n_gen} = make_population(input, db_data, config);

  %disp(generation)
  %disp(generation{1}.population(1,1).mass_fractions)

  convergence = 0;
  while !(convergence)
    n_gen=n_gen+1;
    [generation{n_gen}, convergence]= evolve_population(input, db_data, config, generation);
    if !(mod(n_gen,10))
      disp(sprintf('Iterated generations: %d', n_gen))
      fflush(stdout);
    end
  end
  
  disp('')
  disp(sprintf('Success: Evolver has converged at %d generations', n_gen))
  disp('')
  fflush(stdout);
  evolution_data = generation;
end