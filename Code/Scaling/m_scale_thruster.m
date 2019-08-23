function [m_thruster] = m_scale_thruster(P_thruster, propulsion_type, propellant, db_data)
% Generates thruster mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

%Generate appropriate filename
filename = strcat("Database/Scaling/scaling_data_mass_to_power_",propulsion_type,"_propellant_",propellant, ".csv");

%Use lookup file when available
if exist(filename)
  data = dlmread(filename,",");
  
else
  %Collect db_data for case, sort, pad out and write to file.

  %Define arrays
  arr_pow = [];
  arr_mass = [];
  
  %Walk db for cases
  for i=1:numel(db_data.reference_data.propulsion_system.(propulsion_type).thruster)
    %Shortcut to relevant data
    data_point =db_data.reference_data.propulsion_system.(propulsion_type).thruster{1,i};
    %test for relevant field existance
    if isfield(data_point, "mass") && isfield(data_point, "efficiency") && isfield(data_point, "thrust") &&  isfield(data_point, "c_e")
      %test for propellant case - changes efficiency and power demand
      if strcmp(propellant, data_point.propellant)
  
          %Short descriptors
          eta = data_point.efficiency;
          F = data_point.thrust;
          c_e = data_point.c_e;
          
          %calculate and colelct data
          arr_pow = [arr_pow F*c_e/(2*eta)];
          arr_mass = [arr_mass data_point.mass];
      endif
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
  m_thruster = interp1(data(1,:),data(2,:),P_thruster,"linear");
else
  m_thruster = interp1([data(1,1) data(1,end)],[data(2,1) data(2,end)],P_thruster,"extrap");
end

end