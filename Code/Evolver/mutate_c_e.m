function [individual_data] = mutate_c_e(individual_data, db_data, evolver_config)
propulsion_system = individual_data.propulsion_system;
propellant = individual_data.propellant;

[c_e_min c_e_max] = search_min_max(db_data.reference_data.propulsion_system.(propulsion_system).thruster, individual_data, 'c_e', 'propellant');
individual_data.c_e = mutator_default(individual_data.c_e, c_e_min, c_e_max, evolver_config);

[individual_data.thrust] = refresh_thrust(individual_data);
end