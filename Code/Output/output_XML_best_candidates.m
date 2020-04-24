function output_XML_best_candidates(config, evolution_data)
  %XML file generation of the optimal candidates
  for j=1:size(evolution_data{1},1)
    solution_list = [];
    
    %disp(evolution_data{end}(1,1).subsystem_masses.m_margin)
    %disp(evolution_data{end}(1,1).subsystem_masses.m_margin.Text)
    %disp(str2num(evolution_data{end}(1,1).subsystem_masses.m_margin.Text))
    %disp(str2num(evolution_data{end}(1,1).subsystem_masses.m_margin.Text))
    for i=1:size(evolution_data{1},2)
    %TODO replace here?  % appended here mass.fractions.total - former EP system mass fraction total
    %      solution_list = [solution_list , evolution_data{end}(j,i).mass_fractions.total];
    solution_list = [solution_list , str2num(evolution_data{end}(j,i).subsystem_masses.m_margin.Text)];
    end
  
    [solution_list, idx] = sort(solution_list, 'descend'); % sort index gives the good candidates
    
    %produce the reduced optimal index list
    
    optimal_solution.best_solutions.Attributes.show ="true";
    optimal_solution.best_solutions.Attributes.version=num2str(ceil(now));
    
    
    optimal_solution.best_solutions.(strcat('case_',num2str(j))).Attributes.show ="true";
    optimal_solution.best_solutions.(strcat('case_',num2str(j))).Attributes.version=num2str(ceil(now));
    for k=1:config.Simulation_parameters.output.xml.optimal_candidates
      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))) =  evolution_data{end}(j,idx(k));
      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).Attributes.show ="true";
      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).Attributes.version=num2str(ceil(now));
    end
    
    
  end
  struct2xml(optimal_solution, 'Output/ESDC_best_candidates');
end