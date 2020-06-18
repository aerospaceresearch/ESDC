function [m_PPU] = m_scale_PPU(P_thruster, propulsion_type, db_data)
% Generates PPU mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

%Generate appropriate filename
  filename = strcat("Database/Scaling/scaling_propulsion_system_",propulsion_type, "_ppu_mass_to_power.csv");


  data = dlmread(filename,",");
  %Interpolate for known data, extrapolate beyond.
  m_PPU = scaling_linear(P_thruster,data);  


end