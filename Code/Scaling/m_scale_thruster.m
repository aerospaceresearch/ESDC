function [m_thruster] = m_scale_thruster(P_thruster, propulsion_type, propellant) 
% Generates thruster mass estimations for set propulsion types, with predetermined propellants and total supplied power from data base2dec

% Generate appropriate filename
  %filename = strcat("Database/Scaling/scaling_thruster_mass_to_power_",propulsion_type,"_propellant_",propellant, ".csv");
  filename = strcat("Database/Scaling/scaling_propulsion_system_",propulsion_type, "_thruster_with_propellant_",propellant,"_mass_to_power_jet.csv");
  %disp(filename)
  
  if exist(filename)
    data = dlmread(filename,",");
%    if size(data,2)==1                  %linear scaling when only single data point available
%      data = [data(:,1), 2.*data(:,1)];
%    end
  data(1:2,:) = [data(2,:);data(1,:)];
  data(3:4,:) = [data(4,:);data(3,:)];
  %data = [data(2,:);data(1,:)];
    % Interpolate for known data, extrapolate beyond.
    m_thruster = scaling_linear(P_thruster,data);
  else % regenerate missing data , bs case  
      % calculate jet power?   % make if exists condition here?
      %[data] = read_reference_data(); % here bug looop 
      
      create_new_correlation_file_mass_to_power_jet(filename, propulsion_type, propellant);
      data = dlmread(filename,",");
      data(1:2,:) = [data(2,:);data(1,:)];
      data(3:4,:) = [data(4,:);data(3,:)];
      %update_generic_component_scaling_a_to_b(data, "propulsion_system", propulsion_type, "thruster", "mass", "power_jet", "propellant"); % why this?
      

      %data = [data(2,:);data(1,:)];
    % Interpolate for known data, extrapolate beyond.
      m_thruster = scaling_linear(P_thruster,data);
      
      %m_thruster= m_scale_thruster(P_thruster, propulsion_type, propellant);
     
  end
end


function  [] = create_new_correlation_file_mass_to_power_jet(filename,propulsion_type, propellant)
  %todo 
  [data] = read_reference_data();
  % read data, get calculate data points

  data_thruster =  data.reference_data.propulsion_system.(propulsion_type).thruster;
  %class(data_thruster) % has to be cell
  %size(data_thruster) % has to be 1 x n cell 
  
  %convert to single entry cell array if single element was converted to struct
  if isstruct(data_thruster)
    data_switcher= data_thruster;
    data_thruster = cell();
    data_thruster{1} = data_switcher;
  endif
  
 % disp(data_thruster)
 % class(data_thruster)
  
  n_candidates = size(data_thruster,2);
  list_mass= [];
  list_power_jet = [];

  for i=1:n_candidates
    data = data_thruster{1,i};
      if isfield(data,'mass')
      list_mass = [list_mass data_thruster{1,i}.mass];
        if isfield(data,'power_jet')
          power_jet = data.power_jet;
        elseif (isfield(data,'thrust') && isfield(data,'c_e'))
          F= data.thrust;
          c_e = data.c_e;
          power_jet = 1/2*F*c_e;
        elseif (isfield(data,'thrust') && isfield(data,'massflow'))
          F= data.thrust;
          m_dot = data.massflow;
          power_jet = 1/2*F^2/massflow;
        else
          error('Missing method for caluclating jet power with given data. Function in create_new_correlation_file_mass_to_power_jet')
        end
      list_power_jet = [list_power_jet power_jet];
    endif
  endfor
  
  if numel(list_mass) == 1
    list_mass = [list_mass list_mass(1)*2];
    list_power_jet = [list_power_jet list_power_jet(1)*2];
  endif

  write_selected_data_to_file(list_mass, list_power_jet, filename, 0);
  %list_mass
  %list_power_jet
  % fit according to algo
  
  % write .csv file for the polynomial
  

endfunction
