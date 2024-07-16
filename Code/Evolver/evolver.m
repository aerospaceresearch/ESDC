% Main evolutionary algorithm function
% Initializes generations and iterates them until convergence is reached
%
% Parameters:
%   input: Structure containing input parameters for the evolutionary algorithm
%   db_data: Database data required for population initialization and evolution
%   config: Configuration parameters for the evolutionary algorithm
%   runID: Identifier for the current run of the program
%
% Returns:
%   evolution_data: Cell array containing data for all generations

function evolution_data = evolver(input, db_data, config,runID)
  disp('Starting Evolution ...');
  disp(' ');
  fflush(stdout);
  %outermost shell of the evolutionary algorithm. Initializes first generation according to data and iterates generations until convergence is met.
  generation        = {};                                                       % Initialize cell array for generations, TO THINK: is this incosistent?

  %First gen
  n_gen             = 1;                                                        % Initialize generation number
  generation{n_gen} = make_population(input, db_data, config);                  % Create the first generation

  convergence       = 0;                                                        % Initialize all generations as not converged
  while ~convergence                                                          % Iterate until convergence is reached
    n_gen=n_gen+1;                                                              % Increment generation number

    [generation{n_gen}, convergence]= evolve_population(input, db_data, config, generation,runID);  % Add new generational data, potentially update convergence

    if ~mod(n_gen,config.Simulation_parameters.output.CLI.n_verbosity)        % CLI Output according to frequency, might be used for completition time prediction
      fprintf('Iterated generations: %d\n', n_gen);
      fflush(stdout);
    end
  end

  % CLI output
  % CLI output
  fprintf('\nSuccess: Evolver has converged at %d generations\n', n_gen);
  fflush(stdout);

  evolution_data = generation;                                                  % Assign data of all generations as evolution data to prepare output data of full evolutionary history
end
