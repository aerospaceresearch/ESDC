function [mass_ep_propulsion ] = mass_budget_propulsion(data,db_data, mass_propellant)
  %generates masses of the implemented system and calculates the mass total
  
  mass_ep_propulsion = struct();

  

  mass_ep_propulsion.tank       = m_scale_tank(mass_propellant, data.propellant); %TODO add margin to tank sizing
  mass_ep_propulsion.thruster   = m_scale_thruster(data.power_thruster, data.propulsion_system, data.propellant, db_data);
  mass_ep_propulsion.PPU        = m_scale_PPU(data.power_thruster, data.propulsion_system, db_data);
  %mass_propulsion.structure  = m_scale_structure(data.propulsion_system);
  
  % in the end goes to mass scale power system
  %mass_propulsion.PV         = m_scale_PV(data.power_propulsion, db_data);

  mass_total=0;
  for i=1:  numel(fieldnames(mass_ep_propulsion))
      mass_total= mass_total+mass_ep_propulsion.(fieldnames(mass_ep_propulsion){i});
  end
  mass_ep_propulsion.total=mass_total;

end