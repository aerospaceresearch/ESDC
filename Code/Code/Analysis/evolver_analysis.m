function [data] = evolver_analysis(input, data, config) % todo more configs with respect to evolver
disp('Evolver analysis starting...');
disp(' ');

%landscape =  make3DFitnesslandscape(input, data, config);

%make population
population = struct();
[population.initial] = makeInitialPopulation(input, config);

%make fitness landscapes todo here
%TODO landscape each case and resulting min landscape

%evolve
evolutionaryConverger(population, data, config);

end
