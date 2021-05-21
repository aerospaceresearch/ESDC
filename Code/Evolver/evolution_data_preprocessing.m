%This function shapes the evolution history data into an xml compliant structure for  writing into an .xml file
function output = evolution_data_preprocessing(input)                           % output, xml compliant structure, input, octave evolution data
output        = struct;                                                         % Main output structure

n_case        = size(input{1,1},1);                                             % Determine number of input cases
n_lineage     = size(input{1,1},2);                                             % Determine number of lineages
n_generation  = size(input,2);                                                  % Determine number of generations of lineages

  for j=1:n_case                                                                % Outer shell structure is number input cases
    case_name=strcat('case_',num2str(j));                                 
    for k=1:n_lineage                                                           % 1st shell is each lineage of seed points
      lineage_name=strcat('lineage_',num2str(k));
      for i=1:n_generation                                                      % 2nd shell is generational data of each data 
        generation_name=strcat('generation_',num2str(i));
        output.(case_name).(lineage_name).(generation_name) = input{i}(j, k);   % assign respective data generation i, with lineage k for case j
      end
    end
  end
end