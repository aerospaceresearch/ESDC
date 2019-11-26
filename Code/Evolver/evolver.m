function evolution_data = evolver(input, db_data, config)
  %outermost shell of the evolutionary algorithm. Initializes first generation according to data and iterates generations until convergence is met.
  generation = {};
  n_gen = 1;
  generation{n_gen} = make_population(input, db_data, config);

  %Initialize convergence as negative
  convergence = 0;
  while !(convergence)
    n_gen=n_gen+1;
    [generation{n_gen}, convergence]= evolve_population(input, db_data, config, generation);
    if !(mod(n_gen,config.Simulation_parameters.output.CLI.n_verbosity))
      disp(sprintf('Iterated generations: %d', n_gen))
      fflush(stdout);
    end
  end
  
  disp('')
  disp(sprintf('Success: Evolver has converged at %d generations', n_gen))
  disp('')
  fflush(stdout);
  
  %prepare output data of full evolutionary history
  evolution_data = generation;
end