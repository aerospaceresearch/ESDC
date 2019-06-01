function [mass_propulsion] = mass_budget_propulsion(data)
  mass_propulsion = struct();

  mass_propulsion.propellant = m_scale_propellant(data.mass, data.dv, data.c_e);
  mass_propulsion.tank       = m_scale_tank(mass_propulsion.propellant, data.propellant); 
  mass_propulsion.thruster   = m_scale_thruster(data.p_thruster, data.propulsion_type);
  
  mass_propulsion.PPU        = m_scale_PPU(data.p_thruster, data.eff_PPU, data.propulsion_type);
  mass_propulsion.structure  = m_scale_structure(data.propulsion_type);
  
  % in the end goes to mass scale power system
  mass_propulsion.PV         = m_scale_PV(data.P_prop);
  
  mass_total=0;
  % todo: add total mass
  for i=1:numel(mass_propulsion)
      mass_total= mass_total+mass_propulsion.(fieldnames(mass_propulsion){i}); 
  end
  mass_propulsion.total=mass_total;

end