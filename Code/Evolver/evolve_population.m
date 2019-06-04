function [generation_new, convergence] = evolve_population(input, db_data, config, generation_data)
  convergence = 0  % this is just for testing 
  population = struct();
  for i=1:size(input.Satellite_parameters.input_case,2)
    for j=1:config.Simulation_parameters.evolver.seed_points
      
      population(i,j) = mutate_individual(input, db_data, config, generation_data{1,end}(i,j));
      %refresh other system data
      population(i,j).subsystem_masses = mass_budget_propulsion(population(i,j));
      population(i,j).mass_fractions= mass_fractions(population(i,j));
      population(i,j).mission_parameters = mission_parameters(population(i,j));

      %test for improvement of pop member

      
      %test for improvement here, maybe add index of improved version
    %  population(i,j).evolution_success=1; % if first - then 1 , else compare old to new , potentially reiterate over full lineage
      
      %test for convergence here, maybe add number of non convergence gere
     % population(i,j).convergence=0;
      
    end
  end
  generation_new = population;
end