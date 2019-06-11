function [c_e propellant] = get_random_c_e_and_propellant(data, propulsion);
  %initialization case of unknown c_e and propellant
  n_thrusters = size(data.(propulsion).thruster,2);
  c_e_list  = [];
  propellant_list = {};
  
  if n_thrusters == 1
    c_e = data.(propulsion).thruster.c_e;
    propellant = data.(propulsion).thruster.propellant;
  else
    for i=1:n_thrusters
        c_e_list= [c_e_list , data.(propulsion).thruster{i}.c_e];
        propellant_list{1,end+1}= data.(propulsion).thruster{i}.propellant;
    end
    
    n_case=randi(n_thrusters);
    c_e = c_e_list(n_case);
    propellant = propellant_list{n_case};
    
  end
end