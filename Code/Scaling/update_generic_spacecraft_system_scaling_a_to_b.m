function [] = update_generic_spacecraft_system_scaling_a_to_b (data, orbit_type, field_x,field_y)
  path = "Database/Scaling/";
  
  x = [];
  y = [];
  name = {};
  for i=1:numel(data)
        if strcmp(data{1,i}.orbit_type,orbit_type) && isfield(data{1,i},field_x)  && isfield(data{1,i},field_y) && not(isempty(data{1,i}.(field_x))) && not(isempty(data{1,i}.(field_y))) % consider data only when orbit type of object is correct and the respective field exists
              x = [x data{1,i}.(field_x)];
              y = [y data{1,i}.(field_y)];
              if isfield(data{1,i},"name")
                name{1,numel(x)} = data{1,i}.name;
              else
                name{1,numel(x)} = {};
              end
        end
  end
  filename = strcat(path,"scaling_spacecraft_",orbit_type,"_parameter_",field_x,"_to_",field_y,".csv");
  if numel(x)>0 && numel(y)>0
    write_selected_data_to_file(x,y,filename,0); % TODO param names here
  end
end