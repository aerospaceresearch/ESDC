function output_XML_best_candidates(config, evolution_data,runID)
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

    %optimal_solution.best_solutions.dcep_info.dcep_show ="false";
    %optimal_solution.best_solutions.dcep_info.dcep_version=20200428;


   if j==1
   %optimal_solution.best_solutions.(strcat('case_',num2str(j))).dcep_info.dcep_show ="false";
   else
   %optimal_solution.best_solutions.(strcat('case_',num2str(j))).dcep_info.dcep_show ="false";
   end

    for k=1:config.Simulation_parameters.output.xml.optimal_candidates
      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))) =  evolution_data{end}(j,idx(k));

        if k==1 && j==1
         % optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).dcep_info.dcep_show ="false";
        else
         % optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).dcep_info.dcep_show ="false";
        end

    end

end

  folderPath = strcat('Output/',num2str(runID));
  xml_FileName = fullfile(folderPath, 'ESDC_best_candidates');
    struct2xml(optimal_solution,xml_FileName);
end

##
##  %here attempt to fit new DCEP interface requirements
##
##
##  for all case_
##    for all best_
##      for all sub_
##
##      endfor
##    endfor
##  endfor
##
##  "if attribute" then
##
##  if
##
##
##endif
##
##  function attribute_processing (in_struct)
##
##  %name case
##    if isfield(param_Attributes,'dcep_name')
##      dcep_name = in_struct.Attributes.dcep_name;
##      out_struct.dcep_info.dcep_name = dcep_name;
##    endif
##
##  %description case
##    if isfield(param_Attributes,'dcep_description')
##      dcep_description = in_struct.Attributes.dcep_description;
##      out_struct.dcep_info.dcep_description = dcep_description;
##    endif
##
##  %unit case
##    if isfield(param_Attributes,'dcep_unit')
##      dcep_unit = in_struct.Attributes.dcep_unit;
##      out_struct.dcep_info.dcep_unit = dcep_unit;
##    end
##
##  endfunction
##
##  optimal_solution_DCEP_IO=struct;
##  optimal_solution_DCEP_IO.best_solution=struct;
##
##  % Extract the necessary data
##  dcep_name = xml_data.mass.Attributes.dcep_name;
##  dcep_description = xml_data.mass.Attributes.dcep_description;
##  dcep_unit = xml_data.mass.Attributes.dcep_unit;
##  mass_value = xml_data.mass.Text;
##
##  % Create a new XML struct with the desired structure
##  new_xml_data = struct('mass', struct('dcep_info', struct()));
##  new_xml_data.mass.dcep_info.dcep_name = dcep_name;
##  new_xml_data.mass.dcep_info.dcep_description = dcep_description;
##  new_xml_data.mass.dcep_info.dcep_unit = dcep_unit;
##  new_xml_data.mass.Text = mass_value;
##
##  struct2xml(optimal_solution_DCEP_IO,'Output/ESDC_best_candidates');
##
##
##end
##
##<best_solutions>
##    <case_1>
##        <best_1>
##            <mass>
##                <dcep_info>
##                       <dcep_name>total system mass</dcep_name>
##                       <dcep_description> Input: Total system mass wet including margins</dcep_description>
##                       <dcep_unit>kg</dcep_unit>
##                </dcep_info>
##            <dv>

##
##function output_XML_best_candidates(config, evolution_data)
##  %XML file generation of the optimal candidates
##  for j=1:size(evolution_data{1},1)
##    solution_list = [];
##
##    %disp(evolution_data{end}(1,1).subsystem_masses.m_margin)
##    %disp(evolution_data{end}(1,1).subsystem_masses.m_margin.Text)
##    %disp(str2num(evolution_data{end}(1,1).subsystem_masses.m_margin.Text))
##    %disp(str2num(evolution_data{end}(1,1).subsystem_masses.m_margin.Text))
##    for i=1:size(evolution_data{1},2)
##    %TODO replace here?  % appended here mass.fractions.total - former EP system mass fraction total
##    %      solution_list = [solution_list , evolution_data{end}(j,i).mass_fractions.total];
##    solution_list = [solution_list , str2num(evolution_data{end}(j,i).subsystem_masses.m_margin.Text)];
##    end
##
##    [solution_list, idx] = sort(solution_list, 'descend'); % sort index gives the good candidates
##
##    %produce the reduced optimal index list
##
##    optimal_solution.best_solutions.Attributes.dcep_show ="false";
##    optimal_solution.best_solutions.Attributes.dcep_version=20200428;
##
##
##   if j==1
##   optimal_solution.best_solutions.(strcat('case_',num2str(j))).Attributes.dcep_show ="false";
##   else
##   optimal_solution.best_solutions.(strcat('case_',num2str(j))).Attributes.dcep_show ="false";
##   end
##
##    for k=1:config.Simulation_parameters.output.xml.optimal_candidates
##      optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))) =  evolution_data{end}(j,idx(k));
##
##        if k==1 && j==1
##          optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).Attributes.dcep_show ="false";
##        else
##          optimal_solution.best_solutions.(strcat('case_',num2str(j))).(strcat('best_',num2str(k))).Attributes.dcep_show ="false";
##        end
##
##    end
##
##  end
##
##  struct2xml(optimal_solution, 'Output/ESDC_best_candidates');
##end
