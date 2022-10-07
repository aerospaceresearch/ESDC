function [initial_pop] = make_population(input, db_data, config)
%function to oroduce a randomized initial population from differing starting cases

%number of members of each case population
n_seeds = config.Simulation_parameters.evolver.seed_points;

%number of degrees of freedom
n_DOF = num_struct_members_full(db_data.DOF, 'DOF');

initial_pop = struct();
  for i=1:size(input.Satellite_parameters.input_case,2)
    for j=1:n_seeds
      if isfield(input.Satellite_parameters.input_case{i},'totalmass')
        initial_pop(i,j).mass = input.Satellite_parameters.input_case{i}.totalmass;
      else
        initial_pop(i,j).mass = input.Satellite_parameters.input_case{i}.derived{2}.mass.totalmass;
       % initial_pop(i,j).mass = input.Satellite_parameters.input_case{i}.derived.
      end
      if isfield(input.Satellite_parameters.input_case{i},'totalimpulse')
      initial_pop(i,j).totalimpulse=input.Satellite_parameters.input_case{i}.totalimpulse;
      end
      if isfield(input.Satellite_parameters.input_case{i},'deltav')
      initial_pop(i,j).dv=input.Satellite_parameters.input_case{i}.deltav;
      end
      if isfield(input.Satellite_parameters.input_case{i},'p_propulsion')
      initial_pop(i,j).p_propulsion=input.Satellite_parameters.input_case{i}.p_propulsion;
      end
      % determine respective random case DOF parameters
      %disp(input)
      %here issue with fractions later...
      [initial_pop(i,j).propulsion_system  initial_pop(i,j).propellant  initial_pop(i,j).c_e  initial_pop(i,j).thrust initial_pop(i,j).power_thruster initial_pop(i,j).power_jet initial_pop(i,j).eff_PPU initial_pop(i,j).eff_thruster]  = set_random_case_parameters(db_data, initial_pop(i,j).p_propulsion);
      
      %calculate system masses and mission parameters
 %     initial_pop(i,j).subsystem_masses = mass_budget_propulsion(initial_pop(i,j));
      %disp(input)
      

      [initial_pop(i,j).subsystem_masses initial_pop(i,j).subsystem_powers] = SMAD_scalings(initial_pop(i,j));
      
      
      initial_pop(i,j).mission_parameters = mission_parameters(initial_pop(i,j));
      
      % add mission scenario parameter calculations
      initial_pop(i,j).mass_fractions= mass_fractions(initial_pop(i,j));
      
      % calculate evolution relevant parameters  
      initial_pop(i,j).evolution_success=1; % if first - then 1 , else compare old to new , potentially reiterate over full lineage
      initial_pop(i,j).n_success =1;
      initial_pop(i,j).convergence=0;
      
      initial_pop(i,j).system.power = analysis_power_system( initial_pop(i,j), input.Satellite_parameters.input_case{i}, db_data, config);
      initial_pop(i,j).orbit = input.Satellite_parameters.input_case{i}.orbit;
      
      %disp(initial_pop(i,j));
    end
  end
end

