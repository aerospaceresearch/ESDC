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

%CASE FOR ADDITIONAL n SUB DIMENSIONS - currently only one more implemented e.g. propellant

add_dim=char(varargin);  % could add here check for size 1,1
  if nargin==7
      distinct_cases  = {};
        n_cases = numel(db_data.reference_data.(system_type).(technology_type).(component_type));
       % disp(db_data.reference_data.(system_type).(technology_type).(component_type))
      for i=1:n_cases
        if n_cases==1
          distinct_cases{i}  = db_data.reference_data.(system_type).(technology_type).(component_type).(add_dim);
        else
          distinct_cases{i}  = db_data.reference_data.(system_type).(technology_type).(component_type){1,i}.(add_dim);
        endif

      end
        distinct_cases= unique(distinct_cases);

      for j=1:numel(distinct_cases) 

        x = [];
        y = [];
        if n_cases==1
          data_point =db_data.reference_data.(system_type).(technology_type).(component_type);
        else 
          data_point =db_data.reference_data.(system_type).(technology_type).(component_type){1,j};
        endif

        for i=1:numel(data_point)
          if isfield(data_point, field_x) && isfield(data_point, field_y) && isfield(data_point, add_dim) %&& strcmp(data_point.(add_dim),distinct_cases(j))
              %calculate and collect data
              x = [x data_point.(field_x)];
              y = [y data_point.(field_y)];
              %maybe add here name ?
          endif
        end
          filename = strcat(path,"scaling_",system_type,"_",technology_type,"_",component_type,"_with_",add_dim,"_",char(distinct_cases(j)),"_",field_x,"_to_",field_y,".csv");

        if not( sum(eq(size(y),[0 0]))+sum(eq(size(x),[0 0])) || iscell(y) || iscell(x))
          write_selected_data_to_file(x,y,filename,0);
         endif
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
        
        %disp(filename)
       % iscell(x)
       % iscell(y)
        if not( sum(eq(size(y),[0 0]))+sum(eq(size(x),[0 0])) || iscell(y) || iscell(x))
        %if not(or(eq(size(x),[0 0]), eq(size(y),[0         
        write_selected_data_to_file(x,y,filename,0);
        endif
       % endif
  end
end

