function [p_jet] = refresh_power_jet(individual_data)
 eff_PPU = individual_data.eff_PPU;
 eff_thruster = individual_data.eff_thruster;
 p_propulsion = individual_data.p_propulsion;
 
 p_jet = eff_PPU*eff_thruster*p_propulsion;
end