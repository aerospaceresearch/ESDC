function [c_e power_thruster power_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_c_e(data, propulsion, propellant, F, power_propulsion)
  % returns c_e input thruster of power jet power and efficiences for a propulsion+propellant case with thrust
  eff_ppu= get_ppu_eff(data.(propulsion).ppu);
  eff_thruster = get_thruster_eff(data.(propulsion).thruster, propellant);
  power_thruster = power_propulsion*eff_ppu;
  power_jet = power_thruster*eff_thruster;
  c_e = 2*power_jet/F; 
end