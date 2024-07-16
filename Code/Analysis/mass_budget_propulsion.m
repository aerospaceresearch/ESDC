% Function to derive the propulsion system mass estimate based on each component, individual component scaling is applied
% adds tank, thruster and if available PPU mass

function [mass_epropulsion_power ] = mass_budget_propulsion(data, mass_propellant)
  %generates masses of the implemented system and calculates the mass total
  
  mass_epropulsion_power = struct();                                                                                      %initialize structure
  mass_epropulsion_power.tank           = m_scale_tank(mass_propellant, data.propellant);                                 % TODO rewrite function with correlates add margin to tank sizing
  mass_epropulsion_power.thruster       = m_scale_thruster(data.power_thruster, data.propulsion_system, data.propellant); % Thruster mass estimation by correlation
  
  %only if PPU scaling exists, check for filename, if yes apply PPU scaling  
  filename                          = strcat("Database/Scaling/scaling_propulsion_system_",data.propulsion_system, "_ppu_mass_to_power.csv");
  if exist(filename)                                                                                                  % existance check
     mass_epropulsion_power.PPU         = m_scale_PPU(data.power_thruster, data.propulsion_system);              % PPU scaling
  end
  
  %To think: propulsion structure mass estimate, based on % margin?? Consider piping, valves, transducers etc 
  %mass_propulsion.structure  = m_scale_structure(data.propulsion_system);

  fields_mass = fieldnames(mass_epropulsion_power);
  mass_total = 0;                                                                                                     %initialize total mass
  for i=1:numel(fields_mass);                                                                                         % add all exisiting fields
      mass_total                    =   mass_total+mass_epropulsion_power.(fields_mass{i});
  end
  
  mass_epropulsion_power.total          = mass_total;                                                                     % assign calculated total mass
end