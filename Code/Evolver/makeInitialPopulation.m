function [initial_pop] = makeInitialPopulation(input, db_data, config)

n_seeds = config.Simulation_parameters.evolver.seed_points;


n_DOF = num_struct_members_full(db_data.DOF, 'DOF');
%disp(input)
initial_pop = struct();
for i=1:size(input.Satellite_parameters.input_case,2)
  for j=1:n_seeds
    %TODO: do try of field existance first
    initial_pop(i,j).mass=input.Satellite_parameters.input_case{i}.totalmass;
    initial_pop(i,j).totalimpulse=input.Satellite_parameters.input_case{i}.totalimpulse;
    initial_pop(i,j).dv=input.Satellite_parameters.input_case{i}.deltav;
    initial_pop(i,j).P_prop=input.Satellite_parameters.input_case{i}.P_propulsion;
    %determine random case DOF parameters
    [initial_pop(i,j).propulsion_type  initial_pop(i,j).propellant  initial_pop(i,j).c_e  initial_pop(i,j).thrust initial_pop(i,j).p_thruster initial_pop(i,j).p_jet initial_pop(i,j).eff_PPU initial_pop(i,j).eff_thruster]  = set_random_case_parameters(db_data, initial_pop(i,j).P_prop);
  end
end

initial_pop(i,j).subsystem_masses = mass_budget_propulsion(initial_pop(i,j));

initial_pop(i,j).mission_parameters = mission_parameters(initial_pop(i,j));
% add mission scenario parameter calculations


% add mass fraction 
end


function [mission_parameters] =  mission_parameters(data)  
  mission_parameters = struct();
  mission_parameters.maneuver_duration = maneuver_duration(data);

end  

function [time] = maneuver_duration(data)
    massflow=(data.thrust/data.c_e);
    time = data.subsystem_masses.propellant/massflow;
end

function [mass_propulsion] = mass_budget_propulsion(data)
  mass_propulsion = struct();

  mass_propulsion.propellant = m_scale_propellant(data.mass, data.dv, data.c_e);
  mass_propulsion.tank       = m_scale_tank(mass_propulsion.propellant, data.propellant); 
  mass_propulsion.thruster   = m_scale_thruster(data.p_thruster, data.propulsion_type);
  
  mass_propulsion.PPU        = m_scale_PPU(data.p_thruster, data.eff_PPU, data.propulsion_type);
  mass_propulsion.structure  = m_scale_structure(data.propulsion_type);
  
  % in the end goes to mass scale power system
  mass_propulsion.PV         = m_scale_PV(data.P_prop);
  
  % todo: add total mass

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
    % TODO: likely inconsistent results?
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

function [m_PPU_out] = m_scale_PPU(P_in,eta_PPU,type)

    if strcmp(type,'arcjet')
% Ref:BB28 report for scaling of PPU mass
    m_0     = 1.011;
    slope   = 2.465/1000;
    
    elseif strcmp(type,'gridionthruster')
            m_0     = 1.5;       % DCIU % AIAA-2006-5 162  Mission Benefits of Gridded Ion and Hall Thruster Hybrid Propulsion Systems
            slope   = 2.5/1000;
        
    else
        disp('Unknown thruster - no PPU scaling available in m_scale_PPU')
    end
    
    m_PPU_out = m_0+slope.*P_in./eta_PPU;
end

function [m_Panel_out] = m_scale_PV(P_out)
%currently scaled for requested output power
    m_0     = 0;
    slope   = 1/64.242; % W/kg Ref:http://dhvtechnology.com/wp-content/uploads/2017/07/Datasheet-Julio-v1-front-back.pdf

    m_Panel_out = m_0+ slope.*P_out;

end

function [m_Tank_out] = m_scale_tank(m_prop, type)

%https://www.orbitalatk.com/commerce/Data_Sheet_Index_Diaphragm-VOL.aspx
m_0_set =   [];
slope_set = [];
rho_p_set = [];
%https://www.orbitalatk.com/commerce/Data_Sheet_Index_Diaphragm-VOL.aspx
for i=1:size(m_prop,2)

    if strcmp(type,'He') % Helium
        m_0     = 2.77;
        slope   = 250.8;
        rho_p   = 43.14;    % at 300 bar 20°C https://www.wolframalpha.com/input/?i=density+of+helium+at+300+bar
    end

    if strcmp(type,'NH3') % Ammonia
        m_0     = 1.45;
        slope   = 282.; 
        rho_p   = 681.9;
    end
    
    if strcmp(type,'Xe') % Xenon at 20°C https://www.wolframalpha.com/input/?i=xenon+density+at+300+bar+at+20+%C2%B0C
        m_0     = 2.77;
        slope   = 250.8;
        rho_p   = 2300;
    end
    m_0_set     =   [m_0_set m_0];
    slope_set   =   [slope_set slope];
    rho_p_set   =   [rho_p_set rho_p];

end
    m_Tank_out = m_0_set+ slope_set.*(m_prop./rho_p_set).^(3/2);

end

function [m_Thruster_out] = m_scale_thruster(P_thruster, type)

m_0_set = [];
slope_set = [];

for i=1:size(P_thruster,2)
    
    if strcmp(type,'arcjet')
    
        if P_thruster(i) <= 300
            m_0     = 0.3;        % Velarc mass
            slope   = 0;        % constant for P <300 W
        end
        if ((P_thruster(i)>= 300) && (P_thruster(i) < 1500))
            m_0     = 0.2;        % ATOS/ARTUS 0.7 kg at 1500 W
            slope   = 0.00033333333333333333;

        end
        if ((P_thruster(i) >= 1500) && (P_thruster(i) < 10000))
            m_0     = 0.4882352941176471;        % MARC
            slope   = 0.00014117647058823529;
        end

        if P_thruster(i) >= 10000
            m_0     = 0.0196581196581199205;        % HIPARC
            slope   = 0.00018803418803418803;  
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    elseif strcmp(type,'gridionthruster')       % http://www.space-propulsion.com/brochures/electric-propulsion/electric-propulsion-thrusters.pdf
            
        if P_thruster(i) <= 50                            % RIT μX
            m_0     =0.44;    
            slope   =0;             
        end
        
        if ((P_thruster(i)>= 50) && (P_thruster(i) < 2000))     %RIT 10 EVO
            m_0     =0.027;    
            slope   =0.0034;       
        end
        
        if P_thruster(i) >= 2000                          % RIT 2X
            m_0     =0.027;    
            slope   =0.0034;    
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    else
        disp('This type of thruster not yet implemented');
    end
end
    m_Thruster_out = m_0_set + slope_set.*P_thruster;
end

function [m_propellant_out] = m_scale_propellant(mass, dv, c_e)
    I_tot = c_e.*mass.*(1-exp(-dv./c_e));
    m_propellant_out = I_tot./c_e;
end

function [m_struct_out] = m_scale_structure(type)
% elaborate further?
    if strcmp(type,'arcjet')
           m_struct_out=  0.493;
    elseif strcmp(type,'gridionthruster')
            m_struct_out=  2;
    else
         disp('no struct mass available')
         m =0;
    end
end
