function [thrust power_thruster power_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_thrust(data, propulsion, propellant, c_e, power_propulsion)
  % returns thrust, jet oiwer and efficiencies for given propulsion+propellant case for a specific c_e
  eff_ppu= get_ppu_eff(data.(propulsion).ppu);
  eff_thruster = get_thruster_eff(data.(propulsion).thruster, propellant);
  power_thruster = power_propulsion*eff_ppu;
  power_jet = power_thruster*eff_thruster;
  thrust = 2*power_jet/c_e; 
end