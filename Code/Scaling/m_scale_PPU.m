function [m_PPU] = m_scale_PPU(P_thruster, propulsion_type)
% Generates PPU mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

%Generate appropriate filename
  filename = strcat("Database/Scaling/scaling_propulsion_system_",propulsion_type, "_ppu_mass_to_power.csv");
  if exist(filename)
    data = dlmread(filename,",");

  data(1:2,:) = [data(2,:);data(1,:)];
  data(3:4,:) = [data(4,:);data(3,:)];
  
%  data = [data(2,:);data(1,:)];
  m_PPU = scaling_linear(P_thruster,data);
  endif
end