function [m_thruster] = m_scale_thruster(P_thruster, propulsion_type, propellant) 
% Generates thruster mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

% Generate appropriate filename
  %filename = strcat("Database/Scaling/scaling_thruster_mass_to_power_",propulsion_type,"_propellant_",propellant, ".csv");
  filename = strcat("Database/Scaling/scaling_propulsion_system_",propulsion_type, "_thruster_with_propellant_",propellant,"_mass_to_power_jet.csv");
  
  if exist(filename)
    data = dlmread(filename,",");
    if size(data,2)==1                  %linear scaling when only single data point available
      data = [data(:,1), 2.*data(:,1)];
    end
  

  data(1:2,:) = [data(2,:);data(1,:)];
  data(3:4,:) = [data(4,:);data(3,:)];
  
  
  
    % Interpolate for known data, extrapolate beyond.
    m_thruster = scaling_linear(P_thruster,data);
  else % regenerate missing data 
      [data] = read_reference_data();   
      update_generic_component_scaling_a_to_b(data, "propulsion_system", propulsion_type, "thruster", "mass", "power_jet", "propellant");
      m_thruster= m_scale_thruster(P_thruster, propulsion_type, propellant, some_data);
     
  end
end