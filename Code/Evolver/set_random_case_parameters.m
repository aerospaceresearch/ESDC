function [propulsion propellant c_e F p_thr p_jet eff_ppu eff_thruster] = set_random_case_parameters(db_data, power_propulsion)
  n_DOF = num_struct_members_full(db_data.DOF, 'DOF');
  n_random_case = randi(n_DOF);

  %determine the type of respective propulsion system
  propulsion_systems =db_data.DOF.propulsion_system;
  index_low =0;
  names=fieldnames(propulsion_systems);

  for i=1:numel(names)
      n_sub = num_struct_members_full(propulsion_systems.(names{i}),'DOF');
      index_up=index_low+n_sub;
      % associate the correct DOF random case to the correct propulsion system one level above in XML file.
      if( index_low<= n_random_case &&  n_random_case <= index_up)
        propulsion = names{i};
        case_instance = propulsion_systems.(propulsion).DOF(n_random_case-index_low);
        %here get case param
        break
      end
      index_low = index_up;
  end

% switch for initalization differences  
  switch case_instance{1,1}
    case 'propellant'
      %disp('Considering differing propellants')
      propellant = get_random_propellant(db_data.reference_data.propulsion_system, propulsion);
      c_e = get_random_propulsion_DOF_float(db_data.reference_data.propulsion_system, propulsion, propellant, 'c_e');
      %no random because function of given parameters
      [F p_thr p_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_thrust(db_data.reference_data.propulsion_system, propulsion, propellant, c_e, power_propulsion);

    case 'thrust'
      %disp('Considering thrust variation')
      %propulsion type already defined
      [F propellant]= get_random_thrust_and_propellant(db_data.reference_data.propulsion_system, propulsion);
      % calculate c_e and propulsion system performance data 
      [c_e p_thr p_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_c_e(db_data.reference_data.propulsion_system, propulsion, propellant, F, power_propulsion); 
      % TODO: likely inconsistent results?
    case 'c_e'
      %disp('Considering c_e variation') %maybe redundant
      
      [c_e propellant]=get_random_c_e_and_propellant(db_data.reference_data.propulsion_system, propulsion);
      [F p_thr p_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_thrust(db_data.reference_data.propulsion_system, propulsion, propellant, c_e, power_propulsion);

      % function to look up relevant c_e s from DB, select 1 randomly from available span 
    otherwise
      disp('DOF case laws not found. Check spelling') 
  end
end
