function [F propellant] = get_random_thrust_and_propellant(data, propulsion)
  %initialization case of unknown thrust and propellant
  n_thrusters = size(data.(propulsion).thruster,2);
  F_list  = [];
  propellant_list = {};
  
  if n_thrusters == 1
    F = data.(propulsion).thruster.thrust;
    propellant = data.(propulsion).thruster.propellant;
  else
    for i=1:n_thrusters
        F_list= [F_list , data.(propulsion).thruster{i}.thrust];
        propellant_list{1,end+1}= data.(propulsion).thruster{i}.propellant;
    end
    
    n_case=randi(n_thrusters);
    F = F_list(n_case);                     
    propellant = propellant_list{n_case};
  end
  
end