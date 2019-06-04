function [individual_data] = mutate_thrust(individual_data, db_data, evolver_config)

propulsion_system = individual_data.propulsion_system;
propellant = individual_data.propellant;

[thrust_min thrust_max] = search_min_max(db_data.reference_data.propulsion_system.(propulsion_system).thruster, individual_data, 'thrust', 'propellant');
individual_data.thrust = mutator_default(individual_data.thrust, thrust_min, thrust_max, evolver_config);
[individual_data.c_e] = refresh_c_e(individual_data);
end
