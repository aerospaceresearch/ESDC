function individual_data = mutate_propulsion_system(individual_data, db_data)
  %disp('attempt propulsion system mutation')
  list_propulsion_systems=fieldnames(db_data.reference_data.propulsion_system);
  while 1
    n_propulsion_system = randi(numel(list_propulsion_systems));
    propulsion_system_new =list_propulsion_systems{n_propulsion_system,1};
  if !isequal(propulsion_system_new,individual_data.propulsion_system) && !strcmp(propulsion_system_new,'tank')
  %disp('New propulsion systems selected!')
    individual_data.propulsion_system = propulsion_system_new;
    break
  end
end

%todo: bug propulsion system tank/vessel wrongly declared
individual_data.propellant = get_random_propellant(db_data.reference_data.propulsion_system, individual_data.propulsion_system);

[c_e_min c_e_max] = search_min_max(db_data.reference_data.propulsion_system.(individual_data.propulsion_system).thruster, individual_data, 'c_e', 'propellant');

%Lower cap new c_e
if c_e_min > individual_data.c_e
  individual_data.c_e = c_e_min;
end
%Upper cap new c_e
if c_e_max < individual_data.c_e
  individual_data.c_e = c_e_max;
end
%disp(individual_data)

if isfield(db_data.reference_data.propulsion_system.(individual_data.propulsion_system),'ppu')
  individual_data.eff_PPU = get_ppu_eff(db_data.reference_data.propulsion_system.(individual_data.propulsion_system).ppu);
end
%update efficiency of thruster for new propellant
individual_data.eff_thruster = get_thruster_eff(db_data.reference_data.propulsion_system.(individual_data.propulsion_system).thruster, individual_data.propellant);

% update jet power
individual_data.power_jet = refresh_power_jet(individual_data);

%calculate thrust for new propellant
individual_data.thrust = refresh_thrust(individual_data);

end