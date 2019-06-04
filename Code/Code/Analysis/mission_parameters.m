function [mission_parameters] =  mission_parameters(data)  
  mission_parameters = struct();
  mission_parameters.maneuver_duration = maneuver_duration(data);
end  

function [time] = maneuver_duration(data)
    massflow=(data.thrust/data.c_e);
    time = data.subsystem_masses.propellant/massflow;
end