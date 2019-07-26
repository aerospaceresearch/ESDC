function output_XML_generation(input, db_data, config, evolution_data)
%Pre-Processing data to lineages
output_struct=struct;
output_struct.evolution_lineage_history = evolution_data_preprocessing(evolution_data);

% Producing full output
if config.Simulation_parameters.output.xml.full_history
   output_XML_full_history(output_struct);
end

%Producing optimal output
if config.Simulation_parameters.output.xml.optimal_candidates
  output_XML_best_candidates(config, evolution_data);
end

%completing program
disp('XML Output complete')
disp(' ')

end