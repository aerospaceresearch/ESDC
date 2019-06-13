function output = evolution_data_preprocessing(input)
%make evolution history data into a true xml compliant structure
output =struct;
n_case =size(input{1,1},1);
n_lineage =size(input{1,1},2);
n_generation =size(input,2);
  for j=1:n_case 
    case_name=strcat('case_',num2str(j));
    for k=1:n_lineage
      lineage_name=strcat('lineage_',num2str(k));
      for i=1:n_generation
        generation_name=strcat('generation_',num2str(i));
        output.(case_name).(lineage_name).(generation_name) = input{i}(j, k);
      end
    end
  end
end