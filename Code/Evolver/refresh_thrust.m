function thrust = refresh_thrust(individual_data)
  power_jet   = individual_data.power_jet;
  c_e         = individual_data.c_e;
  
  if size(c_e,2)>1    % this might catch a bug to resolve, rarely error here because c_e is large i.e. 88
    c_e
  end
  thrust      = 2*power_jet/c_e; 
end
