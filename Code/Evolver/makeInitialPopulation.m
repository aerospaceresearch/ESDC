function [initial_pop] = makeInitialPopulation(input, db_data, config)

n_seeds = config.Simulation_parameters.evolver.seed_points;


n_DOF = num_struct_members_full(db_data.DOF, 'DOF');
%disp(input)
initial_pop = struct();
for i=1:size(input.Satellite_parameters.input_case,2)
  for j=1:n_seeds
    initial_pop(i,j).mass=input.Satellite_parameters.input_case{i}.totalmass;
    initial_pop(i,j).totalimpulse=input.Satellite_parameters.input_case{i}.totalimpulse;
    initial_pop(i,j).dv=input.Satellite_parameters.input_case{i}.deltav;
    initial_pop(i,j).P_prop=input.Satellite_parameters.input_case{i}.P_propulsion;
    %determine random case DOF parameters
    [initial_pop(i,j).propulsion_type  initial_pop(i,j).propellant  initial_pop(i,j).c_e  initial_pop(i,j).thrust initial_pop(i,j).p_thruster initial_pop(i,j).p_jet initial_pop(i,j).eff_PPU initial_pop(i,j).eff_thruster]  = set_random_case_parameters(db_data, initial_pop(i,j).P_prop);
  end
end

% add mission scenario parameter calculations
% add mass scaling of subsystems
% add mass fraction 

disp(initial_pop);
end

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

  case 'c_e'
    %disp('Considering c_e variation') %maybe redundant
    
    [c_e propellant]=get_random_c_e_and_propellant(db_data.reference_data.propulsion_system, propulsion);
    [F p_thr p_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_thrust(db_data.reference_data.propulsion_system, propulsion, propellant, c_e, power_propulsion);

    % function to look up relevant c_e s from DB, select 1 randomly from available span 
  otherwise
    disp('DOF case laws not found. Check spelling') 
end

%dont forget efficiency from P_el to P_jet
end

function [c_e power_thruster power_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_c_e(data, propulsion, propellant, F, power_propulsion)
  % returns thrust and 
  eff_ppu= get_ppu_eff(data.(propulsion).ppu);
  eff_thruster = get_thruster_eff(data.(propulsion).thruster, propellant);
  power_thruster = power_propulsion*eff_ppu;
  power_jet = power_thruster*eff_thruster;
  c_e = 2*power_jet/F; 
end

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

function propellant = get_random_propellant(data, propulsion)
  %returns one propellant from the number of relevant propellants available in the db defined by the propulsion type
  propellant_list={};
  
  n_thruster_entries = size(data.(propulsion).thruster,2);
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
  n_case= randi(size(propellant_list,2));

  propellant = propellant_list{1,n_case};
end

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

function [thrust power_thruster power_jet eff_ppu eff_thruster] = get_propulsion_system_performance_data_wo_thrust(data, propulsion, propellant, c_e, power_propulsion)
  % returns thrust and 
  eff_ppu= get_ppu_eff(data.(propulsion).ppu);
  eff_thruster = get_thruster_eff(data.(propulsion).thruster, propellant);
  power_thruster = power_propulsion*eff_ppu;
  power_jet = power_thruster*eff_thruster;
  thrust = 2*power_jet/c_e; 
end

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

function eff_ppu = get_ppu_eff(data)
  n_ppu = size(data,2);
  if n_ppu==1
    eff_ppu= data.efficiency;
  else
    eff_ppu_list = [];
    for i=1:n_ppu
      eff_ppu_list = [eff_ppu_list;data{i}.efficiency];
    end
      eff_ppu = average_array(eff_ppu_list);
  end
end

function val = average_array(in)
val = sum(in)/numel(in);
end


