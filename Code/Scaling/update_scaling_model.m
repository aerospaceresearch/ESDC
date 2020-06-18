function [scaling_model_struct] = update_scaling_model()
  disp('Database check:');
  
  [data] = read_reference_data(); 
  update_generic_scaling_model(data);
  
  if exist("Database/ESDC_Reference_Data_hash")
    
    hash_file = fopen('Database/ESDC_Reference_Data_hash', "r");
    hash_val = fgetl(hash_file);
    fclose(hash_file);
    current_hash = hash('md5', fileread('Database/ESDC_Reference_Data.xml'));
 
    if (hash_val == current_hash)
      disp('No updates to database detected.');
      else
      disp('Updates to database detected.');
        [data] = read_reference_data();                    % add output here
        hash_file= fopen('Database/ESDC_Reference_Data_hash', "w");
        fprintf(hash_file, hash('md5', fileread('Database/ESDC_Reference_Data.xml')));
        fclose(hash_file);
        update_generic_scaling_model(data);
        disp('Updates complete.');
      end
  else
    disp('No database hash file found');
    disp('Creating hash file');
    hash_file= fopen('Database/ESDC_Reference_Data_hash', "a");
    disp('Write hash');
    fprintf(hash_file, hash('md5', fileread('Database/ESDC_Reference_Data.xml')));
    fclose(hash_file);
  end
end


function [] = update_generic_scaling_model(data)
disp('Starting updating of scaling data');
disp('');
system_type_names=fieldnames(data.reference_data);        % System loop - e.g. propulsion, power etc.
for k=1:numel(system_type_names)
  
  technology_type_names=fieldnames(data.reference_data.(char(system_type_names(k))));
  for i=1:numel(technology_type_names)                    % Technology loop - e.g. arcjet, GIT etc.
    component_type_names=fieldnames(data.reference_data.(char(system_type_names(k))).(char(technology_type_names(i))))
    for j=1:numel(component_type_names)                   % Component loop - e.g. thruster, ppu, solar cell, etc.
      
      if not(isstruct(data.reference_data.(char(system_type_names(k))).(char(technology_type_names(i))).(char(component_type_names(j))))) % HERE single field will not be considered
        parameter_names=fieldnames(data.reference_data.(char(system_type_names(k))).(char(technology_type_names(i))).(char(component_type_names(j))){1,i});
      else
        parameter_names=fieldnames(data.reference_data.(char(system_type_names(k))).(char(technology_type_names(i))).(char(component_type_names(j))));
      end
      
      if strcmp(parameter_names,"system") 
        break;
      end
        for l=1:numel(parameter_names)                      % Parameter loop - e.g. mass, power, etc 
          if strcmp(char(component_type_names(j)),'thruster')     % Case distinction of scaling parameters of thrusters being propellant dependent
          update_generic_component_scaling_a_to_b(data,char(system_type_names(k)),char(technology_type_names(i)),char(component_type_names(j)),'mass',char(parameter_names(l)), 'propellant')
          else                                                    % Generic correlation of two parameters
          update_generic_component_scaling_a_to_b(data,char(system_type_names(k)),char(technology_type_names(i)),char(component_type_names(j)),'mass',char(parameter_names(l)))
          end
        
        end

    end
  end
  
%update_generic_component_scaling_a_to_b(data,'propulsion_system','arcjet','ppu','mass','power')
end
disp('');
disp('Updating scaling data complete');
disp('');

end

function [] = update_generic_component_scaling_a_to_b(db_data, system_type, technology_type, component_type, field_x, field_y, varargin)

%Exclusion of certain y-fields that can not be sorted , non int
if strcmp(field_y,'type') ||  strcmp(field_y,'name') ||  strcmp(field_y,'source') ||  strcmp(field_y,'propellant') 
  return
end

if strcmp(field_x, field_y)
 return
end
%filename = strcat("Database/Scaling/scaling_PPU_mass_to_power_",propulsion_type, ".csv");
path = "Database/Scaling/";


%CASE FOR ADDITIONAL SUB DIMENSIONS - currently only one more implemented

add_dim=char(varargin);  % could add here check for for size 1,1
if nargin==7
    distinct_cases  = {};
      n_cases = numel(db_data.reference_data.(system_type).(technology_type).(component_type));
    for i=1:n_cases
      distinct_cases{i}  = db_data.reference_data.(system_type).(technology_type).(component_type){1,i}.(add_dim);
    end
      distinct_cases= unique(distinct_cases);

    for j=1:numel(distinct_cases) 

      x = [];
      y = [];
      data_point =db_data.reference_data.(system_type).(technology_type).(component_type){1,j};
      for i=1:numel(data_point)
        if isfield(data_point, field_x) && isfield(data_point, field_y) && isfield(data_point, add_dim) %&& strcmp(data_point.(add_dim),distinct_cases(j))
            %calculate and collect data
            x = [x data_point.(field_x)];
            y = [y data_point.(field_y)];
            %maybe add here name ?
        endif
      end
        filename = strcat(path,"scaling_",system_type,"_",technology_type,"_",component_type,"_with_",add_dim,"_",char(distinct_cases(j)),"_",field_x,"_to_",field_y,".csv");
        write_selected_data_to_file(x,y, filename);
    endfor


else % generic case handling
    x = [];
    y = [];
    


    %Walk db for case instances
    n_cases = numel(db_data.reference_data.(system_type).(technology_type).(component_type));
    for i=1:n_cases
      %Shortcut to relevant data
      if n_cases == 1
         data_point =db_data.reference_data.(system_type).(technology_type).(component_type);
      else
        data_point =db_data.reference_data.(system_type).(technology_type).(component_type){1,i};
      endif

      %test for relevant field existance
      if isfield(data_point, field_x) && isfield(data_point, field_y)
            %calculate and collect data
            x = [x data_point.(field_x)];
            y = [y data_point.(field_y)];
            %maybe add here name ?
      endif
    end
      filename = strcat(path,"scaling_",system_type,"_",technology_type,"_",component_type,"_",field_x,"_to_",field_y,".csv");
      write_selected_data_to_file(x,y,filename)
end


end

function [] = write_selected_data_to_file(x,y, filename)   %function to write 
  
    data = sort_data(x,y);
    %write file  
    dlmwrite(filename, data, ",");
    disp(strcat(filename, " updated"));
  
 endfunction
 
 function [data] = sort_data(x,y)
       %Sort data according dim_y
    [sorted_y idx] = sort(y);
    
    %arranged related data
    for i=1:numel(y)
     sorted_x(i) = x(idx(i));
    endfor
    %Pad cases for y 0 for minimal mass of lightest known piece of hardware % likely questionsbale for some cases
    sorted_y = [0 sorted_y];
    sorted_x = [sorted_x(1) sorted_x];
    data = [sorted_y; sorted_x];
 endfunction