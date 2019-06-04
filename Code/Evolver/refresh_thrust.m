function thrust = refresh_thrust(individual_data)
  power_jet= individual_data.power_jet;
  c_e=individual_data.c_e;
  thrust = 2*power_jet/c_e; 
end
