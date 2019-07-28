function output_XML_best_candidates(config, evolution_data)
  %XML file generation of the optimal candidates
  for j=1:size(evolution_data{1},1)
    solution_list = [];
    for i=1:size(evolution_data{1},2)
          solution_list = [solution_list , evolution_data{end}(j,i).mass_fractions.total];
    end

    [solution_list, idx] = sort(solution_list); % sort index gives the good candidates
    
    %produce the reduced optimal index list
    for k=1:config.Simulation_parameters.output.xml.optimal_candidates
      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))) =  evolution_data{end}(j,idx(k));
    end
    
    
  end
  struct2xml(optimal_solution, 'Output/ESDC_best_candidates');
end