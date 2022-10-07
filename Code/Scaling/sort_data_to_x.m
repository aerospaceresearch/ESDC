 function [data] = sort_data_to_x(x,y,padbit)
       %Sort data according dim_y
    [sorted_x sort_index] = sort(x);
    sorted_y = [];
   % sorted_name = {};
    %arranged related data
    %disp(sort_index)
    %disp(y)
    %disp(x)
    for i=1:numel(x)
     sorted_y(i) = y(sort_index(i));
     %sorted_name{1,i} = name{1,sort_index(i)};
    endfor

    if padbit==1
      sorted_x = [0 sorted_x];
      sorted_y = [sorted_y(1) sorted_y];
      %sorted_name = vertcat({"Zero case"}, sorted_name{1,:});     %Pad cases for y 0 for minimal mass of lightest known piece of hardware % likely questionsbale for some cases
    end
    data = [sorted_y; sorted_x];
  %  names = sorted_name;
 endfunction