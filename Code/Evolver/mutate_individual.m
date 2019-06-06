function [individual_new] = mutate_individual(input, db_data, config, individual_old)
  
  individual_new= individual_old;
  
  % stop running in circles when convergence is met
  if individual_new.convergence ==1
    return
  end
  %consider the number of DOF within the current propulsion type case
  n_DOF = num_struct_members_full(db_data.DOF.propulsion_system.(individual_old.propulsion_system), 'DOF');
  
  cases = db_data.DOF.propulsion_system.(individual_old.propulsion_system).DOF;
  %if more propulsion systems are available consider mutating the propulsion system as well.
  if numel(fieldnames(db_data.DOF.propulsion_system))>1
    n_DOF = n_DOF+1;
    cases{1,end+1}='propulsion_system';
  end

  %determine the parameter to be mutated
  n_mutation_case = randi(n_DOF);
  
  evolver_config = config.Simulation_parameters.evolver;

  switch cases{1,n_mutation_case}
    case 'c_e'
      [individual_new] = mutate_c_e(individual_old, db_data, evolver_config);

    case 'thrust'
      [individual_new] = mutate_thrust(individual_old, db_data, evolver_config);

    case 'propellant'
      [individual_new] = mutate_propellant(individual_old, db_data);

    case  'propulsion_system'
      [individual_new] = mutate_propulsion_system(individual_old, db_data);

    otherwise
      disp('Mutation laws not found.');
  end

end