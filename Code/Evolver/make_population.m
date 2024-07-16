function initial_population = make_population(input, database_data, configuration)
% make_population generates a randomized initial population for the evolutionary algorithm function.
%
% This function produces a randomized initial population from different starting cases.
% The initial population is created based on input parameters, database data, and configuration settings.
%
% Parameters:
%   input (struct): Structure containing input parameters for the evolutionary algorithm.
%   database_data (struct): Database data required for population initialization and evolution.
%   configuration (struct): Configuration parameters for the evolutionary algorithm.
%
% Returns:
%   initial_population (struct): Structure containing the initial population with various properties.
%
% The function performs the following steps:
%   1. Initializes the number of seeds and degrees of freedom.
%   2. Iterates over each input case and each seed to generate initial population members.
%   3. Assigns mass, total impulse, delta-v, and propulsion power values based on the input case.
%   4. Sets random case parameters for each population member.
%   5. Calculates system masses, mission parameters, mass fractions, and evolution relevant parameters.
%   6. Calculates the power system and assigns the orbit for each population member.
%
% Example:
%   initial_population = make_population(input, database_data, configuration);
%
% See also: set_random_case_parameters, SMAD_scalings, mission_parameters, mass_fractions, analysis_power_system



% Number of members of each case population.
number_of_seeds = configuration.Simulation_parameters.evolver.seed_points;

% Number of degrees of freedom.
number_of_DOF = num_struct_members_full(database_data.DOF, 'DOF');

% Initialize the initial population structure.
initial_population = struct();

% Iterate over each input case.
for i = 1:numel(input.Satellite_parameters.input_case)
      % Iterate over the number of seeds.
    for j = 1:number_of_seeds
        case_parameters = input.Satellite_parameters.input_case{i};

        % Create a temporary structure for the population member.
        population_member = struct();

        % Mass assignment with fallback.
        if isfield(case_parameters, 'mass_total')
            population_member.mass = case_parameters.mass_total;
        else
            population_member.mass = case_parameters.derived{2}.mass.mass_total;
        end

        % Conditional assignments if parameters are part of the input
        population_member.totalimpulse = get_field_safe(case_parameters, 'totalimpulse');
        population_member.deltav = get_field_safe(case_parameters, 'deltav');
        population_member.propulsion_power = get_field_safe(case_parameters, 'propulsion_power');

      

      % determine respective random case DOF parameters
      %disp(input)
      %here issue with fractions later...
      [population_member.propulsion_system, population_member.propellant, population_member.c_e, population_member.thrust, population_member.power_thruster, population_member.power_jet, population_member.eff_PPU, population_member.eff_thruster]  = set_random_case_parameters( database_data, population_member.propulsion_power);
      
      %calculate system masses and mission parameters
%     population_member.subsystem_masses = mass_budget_propulsion(population_member);
      %disp(input)
      

      [population_member.subsystem_masses,population_member.subsystemass_powers] = SMAD_scalings(population_member);
      
      
     population_member.mission_parameters = mission_parameters(population_member);
      
      % add mission scenario parameter calculations
     population_member.mass_fractions= mass_fractions(population_member);
      
      % calculate evolution relevant parameters  
     population_member.evolution_success=1; % if first - then 1 , else compare old to new , potentially reiterate over full lineage
     population_member.n_success =1;
     population_member.convergence=0;
      
     population_member.system.power = analysis_power_system(population_member, input.Satellite_parameters.input_case{i},  database_data, configuration);
     population_member.orbit = input.Satellite_parameters.input_case{i}.orbit;
     
     % Assign the temporary structure to the initial population array.
      initial_population(i,j) = population_member;
      
      disp(population_member); % Debugging only
    end
  end
end

function value = get_field_safe(struct, field)
% Helper function to safely get a field value. Serving as a shortcut to avoid excessive isfield checking.
  if isfield(struct, field)
    value = struct.(field);
  else
    value = [];
  end
end