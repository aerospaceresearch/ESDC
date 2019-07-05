function [mass_propulsion] = mass_budget_propulsion(data)
  %generates masses of the implemented system and calculates the mass total
  
  mass_propulsion = struct();

  mass_propulsion.propellant = m_scale_propellant(data.mass, data.dv, data.c_e);
  mass_propulsion.tank       = m_scale_tank(mass_propulsion.propellant, data.propellant); 
  mass_propulsion.thruster   = m_scale_thruster(data.power_thruster, data.propulsion_system);
  
  mass_propulsion.PPU        = m_scale_PPU(data.power_thruster, data.eff_PPU, data.propulsion_system);
  mass_propulsion.structure  = m_scale_structure(data.propulsion_system);
  
  % in the end goes to mass scale power system
  mass_propulsion.PV         = m_scale_PV(data.power_propulsion);

  mass_total=0;
  for i=1:  numel(fieldnames(mass_propulsion))
      mass_total= mass_total+mass_propulsion.(fieldnames(mass_propulsion){i});
  end
  mass_propulsion.total=mass_total;

end