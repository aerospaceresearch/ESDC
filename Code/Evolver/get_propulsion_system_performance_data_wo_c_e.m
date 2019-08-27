function [c_e power_thruster power_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_c_e(data, propulsion, propellant, F, power_propulsion)
  % returns c_e input thruster of power jet power and efficiences for a propulsion+propellant case with thrust
  eff_ppu= get_ppu_eff(data.(propulsion).ppu);
  eff_thruster = get_thruster_eff(data.(propulsion).thruster, propellant);
  power_thruster = power_propulsion*eff_ppu;
  power_jet = power_thruster*eff_thruster;
  c_e = 2*power_jet/F; 
  
  dummy_struct = struct;
  dummy_struct.propellant = propellant;
  
  [c_e_min c_e_max] = search_min_max(data.(propulsion).thruster, dummy_struct, 'c_e', 'propellant');

  if c_e > c_e_max
      c_e = c_e_max;
  endif
end