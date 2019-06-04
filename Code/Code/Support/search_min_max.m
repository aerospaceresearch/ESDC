function [min_val max_val] = search_min_max(db_data, individual, field, required_match) % extend for potentially multiple requirements 
%function to search for the minimal and maximal values of a desired field in a given input db_data structure that matches a required field identity for a given population individual

% take direct values in case of size 1 input
if numel(db_data)==1
  min_val = db_data.(field);
  max_val = db_data.(field);
else

  min_val = Inf;        %not great init, better?
  max_val = 0;
  %loop over potentially relevant db_data entries
  for i=1:numel(db_data)

    %Check for requirement
    if strcmp(db_data{1,i}.(required_match),individual.(required_match))
      if db_data{1,i}.(field) > max_val
          max_val = db_data{1,i}.(field);
      end
      if db_data{1,i}.(field) < min_val
          min_val = db_data{1,i}.(field);
      end
    end
  end
end

end