function [generation_new, convergence] = evolve_population(input, db_data, config, generation_data)
  convergence = 0;  % this is just for testing 
  population = struct();
  for i=1:size(input.Satellite_parameters.input_case,2)
    for j=1:config.Simulation_parameters.evolver.seed_points
      
      n_successor = generation_data{end}(i,j).n_success;
      population(i,j) = mutate_individual(input, db_data, config, generation_data{n_successor}(i,j));
      %refresh other system data                  
      population(i,j).subsystem_masses = mass_budget_propulsion(population(i,j));
      population(i,j).mass_fractions= mass_fractions(population(i,j));
      population(i,j).mission_parameters = mission_parameters(population(i,j));
      
      %test for improvement of pop member
      lineage = get_lineage(generation_data, i, j);
      population(i,j).evolution_success = test_minimize_parameter(population(i,j), lineage, {'mass_fractions','total'}); % add this to sim parameter options 
      if population(i,j).evolution_success== 1
        population(i,j).n_success = size(generation_data,2)+1;
      end
       %test for convergence here, maybe add number of non convergence gere
      population(i,j).convergence = test_lineage_convergence_simple(population(i,j), lineage);  % add a parmeter specific epsilon convergence test
    end
  end
  generation_new = population;
  [convergence n_convergence] = test_full_convergence(population);
end






