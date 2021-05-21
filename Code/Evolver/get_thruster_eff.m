function eff_thruster = get_thruster_eff(data, propellant)
  %TODO: update this function for correct effieciency scaling!
  %returns the efficiency of a certain thruster type for a specific propellant
  %disp(data)
    n_thruster = size(data,2);
  if n_thruster==1            %assuming only thruster has correct effciency for applied propellant
    if isfield(data,'efficiency')
      eff_thruster= data.efficiency;
    else
      efficiency_calculated = calculate_thruster_efficiency(data);
      eff_thruster= efficiency_calculated;% if no efficiency available caluclate here , if not possible, use efficiency correlation
    end
  else
    eff_thruster_list = [];
    for i=1:n_thruster
      if strcmp(data{i}.propellant, propellant)
        
      if isfield(data{i},'efficiency')
        eff_thruster_list = [eff_thruster_list; data{i}.efficiency]; 
      else
        efficiency_calculated = calculate_thruster_efficiency(data{i});
        eff_thruster_list = [eff_thruster_list; efficiency_calculated]; 
      end
      endif
    end
      eff_thruster = average_array(eff_thruster_list);      % TOTHINK: why average why not correlate?
  end
end



function efficiency = calculate_thruster_efficiency(data)
  %disp('Inside')
  %disp(data)
  if isfield(data,'power')
    P_in = data.power;
  else
    disp('Error: no input power of thruster given')
  endif
  
  if isfield(data,'power_jet')
    P_jet = data.power_jet;
  elseif (isfield(data,'thrust') && isfield(data,'c_e'))
    F= data.thrust;
    c_e = data.c_e;
    P_jet = 1/2*F*c_e;
  
  elseif (isfield(data,'thrust') && isfield(data,'massflow'))
    F= data.thrust;
    m_dot = data.massflow;
    P_jet = 1/2*F^2/massflow;
  endif
  
  
  efficiency = P_jet/P_in;
  
  efficiency = efficiency';  % TODO: check if correct really??
endfunction
