function eff_thruster = get_thruster_eff(data, propellant)
  %returns the efficiency of a certain thruster type for a specific propellant
    n_thruster = size(data,2);
  if n_thruster==1            %assuming only thruster has correct effciency for applied propellant
    eff_thruster= data.efficiency;
  else
    eff_thruster_list = [];
    for i=1:n_thruster
      if strcmp(data{i}.propellant, propellant)
      eff_thruster_list = [eff_thruster_list; data{i}.efficiency];
      end
    end
      eff_thruster = average_array(eff_thruster_list);
  end
end
