%this function derives time for conumsing the given propellant mass by a propulsion system  

function [mission_parameters] =  mission_parameters(data)            % use data, return refined mission parameters
  mission_parameters = struct;                                       % prepare a data structure
  mission_parameters.maneuver_duration = maneuver_duration(data);    % add calculated maneuvre time to structure
end  

function [time] = maneuver_duration(data)                            % Calculate maneuvre duration time
    massflow=(data.thrust/data.c_e);                                 % mass flow is thrust divided by effective exhaust velocity
    time = data.subsystem_masses.m_propellant/massflow;              % time is propellant mass divided by mass flow
end