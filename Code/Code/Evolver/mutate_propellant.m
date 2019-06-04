function individual_data = mutate_propellant(individual_data, db_data)
  propulsion_system = individual_data.propulsion_system;
  %get a random available propellant type for this propulsion type 
  while 1
  [propellant_type_new n_propellant] =get_random_propellant(db_data.reference_data.propulsion_system, individual_data.propulsion_system);
    if n_propellant==1
      %disp('No alternative propellants available!');
      break
    end
    if !isequal(propellant_type_new,individual_data.propellant)
      %disp('New propellant selected!')
      individual_data.propellant = propellant_type_new;
      break
    end
  end

  %adapt c_e for new propellant - look up c_e min max for the new propellant 
  [c_e_min c_e_max] = search_min_max(db_data.reference_data.propulsion_system.(individual_data.propulsion_system).thruster, individual_data, 'c_e', 'propellant');

  %Lower cap new c_e
  if c_e_min > individual_data.c_e
    individual_data.c_e = c_e_min;
  end
  %Upper cap new c_e
  if c_e_max < individual_data.c_e
    individual_data.c_e = c_e_max;
  end
  % else keep c_e constant

  %update efficiency of thruster for new propellant
  individual_data.eff_thruster = get_thruster_eff(db_data.reference_data.propulsion_system.(individual_data.propulsion_system).thruster, individual_data.propellant);

  % update jet power
  individual_data.power_jet = refresh_power_jet(individual_data);

  %calculate thrust for new propellant
  individual_data.thrust = refresh_thrust(individual_data);
end