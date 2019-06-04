function evolution_data = evolver(input, db_data, config)
  generation = {};

  % use input to seed the parameter space
  generation{1,end+1} = make_population(input, db_data, config);

  %disp(generation)
  %disp(generation{1}.population(1,1).mass_fractions)

  %Loop for mutating the the population
  convergence = 0;
  while !(convergence)
    [generation{1,end+1}, convergence]= evolve_population(input, db_data, config, generation);
  end

  % output full range of evolutionary history (configurable in the output functions)
  evolution_data = generation;
end