function [m_PV] = m_scale_PV(P_out, db_data)
 filename = strcat("Database/Scaling/scaling_power_generator_mass_to_power.csv");

  % Use lookup file when available
  if exist(filename)
    data = dlmread(filename,",");
    
  else
    % Collect db_data for case, sort, pad out and write to file.

    % Define arrays
    arr_pow = [];
    arr_mass = [];
    
    % Walk db for cases
    for i=1:numel(db_data.reference_data.power_generation.photovoltaic.cell)       %change here if non PV is implemented
      % Shortcut to relevant data
      data_point =db_data.reference_data.power_generation.photovoltaic.cell{1,i};
      % test for relevant field existance
      if isfield(data_point, "mass") && isfield(data_point, "power_max")
        % test for propellant case - changes efficiency and power demand
            % Calculate and colelct data
            arr_pow = [arr_pow data_point.power_max];
            arr_mass = [arr_mass data_point.mass];
      endif
    end
    
    % Sort data to power 
    [sorted_pow idx] = sort(arr_pow);
    
    % Arranged related data
    for i=1:numel(arr_pow)
     sorted_mass(i) = arr_mass(idx(i));
    endfor
    
    % Pad cases for P = 0 W for minimal mass of lightest known piece of hardware
    sorted_pow = [0 sorted_pow];
    sorted_mass = [sorted_mass(1) sorted_mass];
    data = [sorted_pow; sorted_mass];
    
    % Write file  
    dlmwrite(filename, data, ",");
  end
  m_PV = scaling_linear(P_out,data);
  
end
