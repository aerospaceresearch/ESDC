function [m_PPU] = m_scale_PPU(P_thruster, propulsion_type, db_data)
% Generates PPU mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

%Generate appropriate filename
  filename = strcat("Database/Scaling/scaling_PPU_mass_to_power_",propulsion_type, ".csv");

  %Use lookup file when available
  if exist(filename)
    data = dlmread(filename,",");
  else
    %Collect db_data for case, sort, pad out and write to file.

    %Define arrays
    arr_pow = [];
    arr_mass = [];
    
    %Walk db for cases
    n_cases = numel(db_data.reference_data.propulsion_system.(propulsion_type).ppu);
    for i=1:n_cases
      %Shortcut to relevant data
      if n_cases == 1
         data_point =db_data.reference_data.propulsion_system.(propulsion_type).ppu;
      else
        data_point =db_data.reference_data.propulsion_system.(propulsion_type).ppu{1,i};
      endif

      %test for relevant field existance
      if isfield(data_point, "mass") && isfield(data_point, "power")
            %calculate and collect data
            arr_pow = [arr_pow data_point.power];
            arr_mass = [arr_mass data_point.mass];
      endif
    end
    
    %Sort data to power 
    [sorted_pow idx] = sort(arr_pow);
    
    %arranged related data
    for i=1:numel(arr_pow)
     sorted_mass(i) = arr_mass(idx(i));
    endfor
    
    %Pad cases for P = 0 W for minimal mass of lightest known piece of hardware
    sorted_pow = [0 sorted_pow];
    sorted_mass = [sorted_mass(1) sorted_mass];
    data = [sorted_pow; sorted_mass];
    
    %write file  
    dlmwrite(filename, data, ",");
  end

  %Interpolate for known data, extrapolate beyond.
  if P_thruster<=data(1,end)
    m_PPU = interp1(data(1,:),data(2,:),P_thruster,"linear");
  else
    m_PPU = interp1([data(1,1) data(1,end)],[data(2,1) data(2,end)],P_thruster,"extrap");
    if numel(data(1,:)==1)
      disp(strcat("Warning: Insufficent PPU mass extrapolation data:  ", propulsion_type, " at ", num2str(P_thruster), " W." ));
    endif
  end

end