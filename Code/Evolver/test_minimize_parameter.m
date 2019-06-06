function result = test_minimize_parameter(new_data, lineage_data, parameter_list)
  %tests whether a field specified in the parameter list of new_data is minimal to all the respective fields in lineage_data  
  
  %walk down the field tree to find relevant comparison value of the new data
   new_val=new_data;
   for i=1:numel(parameter_list)  
     new_val = new_val.(parameter_list{i});
   end
   
  %walk down the field tree of the gen data to find minimum value
  value_list = zeros(numel(lineage_data),1);
  for j=1:numel(lineage_data)
   gen_val=lineage_data{j};
   for i=1:numel(parameter_list)  
     gen_val = gen_val.(parameter_list{i});
   end
   value_list(j)=gen_val;
  end  
  
  min_val = min(value_list); % get minimum of current list

    if new_val < min_val % TODO here should be a leq instead of eq .... but becomes a problem with convergence when declearing identity with success !
      result = 1;
    else
      result = 0;
    end
end