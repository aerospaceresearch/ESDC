function DOF_return = get_random_propulsion_DOF_float(data, propulsion, propellant, DOF)
    % get a randomized number of a float degree of freedom from the propulsion system , applicable for c_e and F floats currently
    DOF_list=[];
    n_thruster_entries = size(data.(propulsion).thruster,2);
      for i=1:n_thruster_entries
        if n_thruster_entries==1
          sub_data = data.(propulsion).thruster;
        else
          sub_data = data.(propulsion).thruster{i};
        end 
        if strcmp(sub_data.propellant, propellant)
            DOF_list = [DOF_list; sub_data.(DOF)];
        end
      end
      
      DOF_return =   rand_range(min(DOF_list),max(DOF_list));
end