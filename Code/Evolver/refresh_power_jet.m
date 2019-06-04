function [power_jet] = refresh_power_jet(individual_data)
 eff_PPU = individual_data.eff_PPU;
 eff_thruster = individual_data.eff_thruster;
 power_propulsion = individual_data.power_propulsion;
 
 power_jet = eff_PPU*eff_thruster*power_propulsion;
end