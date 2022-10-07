function [propellant n_propellants] = get_random_propellant(data, propulsion)
  %returns one propellant from the number of relevant propellants available in the db defined by the propulsion type
  propellant_list={};
  %disp(propulsion)
  %disp(data)
  %disp(data.(propulsion))
  if isfield(data.(propulsion),'thruster')
    n_thruster_entries = size(data.(propulsion).thruster,2); % change here how to get the data 
    for i=1:n_thruster_entries
      if n_thruster_entries==1
            propellant_data = data.(propulsion).thruster.propellant;
      else
            propellant_data = data.(propulsion).thruster{i}.propellant;
      end 
      if ~any(strcmp(propellant_list,propellant_data))
        propellant_list{1,end+1} = propellant_data;
      end
    end
    n_propellants = size(propellant_list,2);
    n_case= randi(n_propellants);
      
    %propellant_list
    propellant = propellant_list{1,n_case};
  end 
  
  %disp(propulsion)
end