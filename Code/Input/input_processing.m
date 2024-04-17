function [mission_parameters database simulation_parameters]= input_processing()
 %InputReading
    % Mission Parameters
    [mission_parameters] =  read_input_mission_parameter();
    
    % Database     % THIS WILL BE OBSOLETE SOON check by hash for diff-> update DB scaling model functions automatically
    [database]    =  read_reference_data();
    database.DOF  =  read_DOF();
    
    % Simulation Parameters
    [simulation_parameters] = read_input_simulation_parameter();
    
    disp(' ')
    disp('Input Reading complete')
    disp(' ')
    
    disp('Adaptive Input Preprocessing')
    disp(' ')
    
    % Add derived parameters to input case
    
    %TODO add loop for multiple cases
    input_cases = mission_parameters.Satellite_parameters.input_case;
    for i= 1:size(input_cases,2)
      mission_parameters.Satellite_parameters.input_case{i}(1,1).derived = system_completion_estimation(mission_parameters.Satellite_parameters.input_case{i}(1,1));
      mission_parameters.Satellite_parameters.input_case{i}(1,1).orbit = orbit_initialize(mission_parameters.Satellite_parameters.input_case{i}(1,1), simulation_parameters);
    end
    
    
    %disp(mission_parameters.Satellite_parameters)
end

function [derived_parameters]   = system_completion_estimation(inputs)
  %disp(inputs)
  %disp(inputs.totalmass) // field accessing example
  derived_parameters = struct;
  
  %Available mass fields          %may or may not be defineable in external file
  masses = {
  'totalmass'
  %'m_propellant'
  'm_payload'
  'm_structmech'
  'm_thermal'
  'm_power'
  'm_TTC'
  'm_ADC'
  'm_propulsion'
  'm_other'
  };
  
  %Available power fields
  powers = {
  'p_total'
  'p_payload'
  'p_structmech'
  'p_thermal'
  'p_power'
  'p_TTC'
  'p_ADC'
  'p_propulsion'
  };
  
  % Create structures for known and unknown data
  known = struct();
  unknown = struct();
  
  % Make structures for known and unknown inputs masses
  for i=1:numel(masses)
    if isfield(inputs,cellstr(masses{i}))
      known.mass.(masses{i})=inputs.(masses{i});
    else
      unknown.mass.(masses{i})=0;
    end
  endfor
  
  % Make structure for known and unknown input powers
  for i=1:numel(powers)
    if isfield(inputs,cellstr(powers{i}))
      known.power.(powers{i})=inputs.(powers{i});
    else
      unknown.power.(powers{i})=0;
    end
  endfor

   %disp(known)
  
% spacecraft type derivation 
  if isfield(inputs, 'deltav')
    data.dv=inputs.deltav;
    sc_type =  determine_sc_type(data);
  else
    sc_type =1;
  endif
  derived_parameters.sc_type= sc_type;
  
  %if no knowns, nothing to do
  if not(isfield(known,'power')) && not(isfield(known,'mass'))
    disp(' ')
    disp('If anything would be known - yeah - that d great');
    disp('Define at least one system or mass - quitting ESDC');
    error('Insufficient knowns');
  endif
  
  margin = 0.3; %TODO config parameter
  
  if isfield(known,'mass') && isfield(known.mass,'totalmass')
    [known unknown]  = system_with_known_totalmass(known, unknown, margin, sc_type);
  elseif isfield(known,'power') &&isfield(known.power,'p_total')
    [known unknown] = system_with_known_totalpower(known, unknown, margin, sc_type);
  elseif isfield(unknown.mass,'totalmass') && isfield(unknown.power,'p_total')
    [known unknown] = system_with_unknown_totals(known, unknown, margin, sc_type);
  endif
  
  %disp(unknown);
  %disp(known);
  
  derived_parameters.known = known;
  derived_parameters.unknown = unknown;
endfunction

function [known unknown]        = system_with_unknown_totals(known, unknown, margin, sc_type)
  %known processing

  if isfield(known,'mass')
    unknown_parameters = fieldnames(unknown.mass);
    known_parameters = fieldnames(known.mass);
    
    all_known_masses = 0;
    fracs = [];
    for i=1:numel(known_parameters)
    fracs = [fracs scale_SMAD_parameter_inverse_fraction(known.mass.(known_parameters{i}), sc_type, 'm_total',strcat('fraction_', known_parameters{i}))];
    all_known_masses = all_known_masses +known.mass.(known_parameters{i});
    end
    
    all_known_fractions = sum(fracs);
    
    %get mass estimates 
    unknown.mass.m_total_margin = all_known_masses/all_known_fractions;
    unknown.mass.totalmass = unknown.mass.m_total_margin/(1-margin);
    unknown.mass.m_margin = unknown.mass.totalmass-unknown.mass.m_total_margin;
    
    %get all system estimates
    for i=1:numel(unknown_parameters)
      if not(strcmp(unknown_parameters{i},'totalmass'))
        unknown.mass.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*unknown.mass.m_total_margin;
      endif
    endfor
    
    unknown_parameters = fieldnames(unknown.power);
    %get all system powerset
    power_tot_relevant = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total','p_total');

    for i=1:numel(fieldnames(unknown.power))
        if not(strcmp(unknown_parameters{i},'p_total'))
        unknown.power.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*power_tot_relevant;
        end
    endfor
    
    %restablish sum of total power
    new_power_tot = sum_powers(known.power, unknown.power);
    
     %update total power
    if isfield(unknown.power, 'p_total')
      unknown.power.p_total = new_power_tot;
    elseif isfield(known.power, 'p_total')
      if new_power_tot >  known.power.p_total
        disp('')
        disp((strcat('Info: Total power estimate increased to',{' '}, num2str(new_power_tot), ' W')){1});
        disp('')
        known.power.p_total = new_power_tot;
      else 
        known.power.p_margin = known.power.p_total-new_power_tot;
        known.power.p_total_margin = new_power_tot;
      end
    end
    unknown.mass.m_power = scale_SMAD_parameter(new_power_tot, sc_type, 'p_total','fraction_m_power')*unknown.mass.m_total_margin;
    
    [unknown.mass.totalmass unknown.mass.m_margin unknown.mass.m_total_margin] = mass_validate(known.mass,unknown.mass);
  else
    % go from powers to total power to total mass to masses  
    
    unknown_parameters = fieldnames(unknown.power);
    known_parameters = fieldnames(known.power);
    
    all_known_powers = 0;
    fracs = [];
    for i=1:numel(known_parameters)
    fracs = [fracs scale_SMAD_parameter_inverse_fraction(known.power.(known_parameters{i}), sc_type, 'p_total',strcat('fraction_', known_parameters{i}))];
    all_known_powers = all_known_powers +known.power.(known_parameters{i});
    end
    
    all_known_fractions = sum(fracs);
    
    unknown.power.p_total = all_known_powers/(all_known_fractions);
    
    unknown_parameters = fieldnames(unknown.power);
    for i=1:numel(fieldnames(unknown.power))
        if not(strcmp(unknown_parameters{i},'p_total'))
        unknown.power.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.power.p_total, sc_type, 'p_total',strcat('fraction_',unknown_parameters{i}))*unknown.power.p_total;
        end   
    endfor
    
    new_power_tot = sum_powers(known.power, unknown.power);
    
    if new_power_tot >  unknown.power.p_total
        disp('')
        disp((strcat('Info: Total power estimate increased to',{' '}, num2str(new_power_tot), ' W')){1});
        disp('')
        unknown.power.p_total = new_power_tot;
        unknown.power.p_margin = 0;
        unknown.power.p_total_margin = unknown.power.p_total;
      else 
        unknown.power.p_margin = unknown.power.p_total-new_power_tot;
        unknown.power.p_total_margin = new_power_tot;
      end
    
    %do mass total 
      unknown.mass.totalmass= scale_SMAD_parameter(unknown.power.p_total,sc_type,'p_total', 'm_total');
      unknown_parameters = fieldnames(unknown.mass);
      unknown.mass.m_margin = unknown.mass.totalmass*margin;
      unknown.mass.m_total_margin = unknown.mass.totalmass-unknown.mass.m_margin;
      
      
     for i=1:numel(unknown_parameters)
      if not(strcmp(unknown_parameters{i},'totalmass'))
       unknown.mass.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*unknown.mass.m_total_margin;
      endif
     endfor
     
     mass_new=0;
    for i=1:numel(unknown_parameters)
      if not(strcmp(unknown_parameters{i},'totalmass'))
      mass_new = mass_new +unknown.mass.(unknown_parameters{i});
      endif
    endfor
    unknown.mass.m_total_margin = mass_new;
    unknown.mass.totalmass = unknown.mass.m_total_margin*(1+margin);
    unknown.mass.m_margin = unknown.mass.totalmass-unknown.mass.m_total_margin;
    

  end
  % cases for zero known masses and zero known powerset
endfunction 

function [fraction]             = scale_SMAD_parameter_inverse_fraction(y,sc_type,x, file_parameter)
  % assemble filename
  
  orbits = {'No Propulsion','Low Earth', 'High Earth','Planetary'};
  filename = strcat('Database/Scaling/scaling_spacecraft_',orbits{sc_type},'_parameter_',x,'_to_',file_parameter,'.csv');
  
  if exist(filename)
    data = dlmread(filename,",");
    %disp(data)
  else
    disp(filename);
    error(strcat('ERROR: File not found: ', filename));
  end
  
  frac_vals =data(3,:);
  x_vals = data(4,:);
  
  non_frac_vals = frac_vals.*x_vals;
  
  x_derived= interp1(non_frac_vals,x_vals, y,'linear','extrap');
  fraction= y/x_derived;
endfunction



function [known unknown]        = system_with_known_totalpower(known, unknown, margin, sc_type)               % when only total mass is known, this. % missing case with total
    unknown_parameters = fieldnames(unknown.mass);
    
    % get unknown total mass first % inverse search here from correlation power total to total mass 
    unknown.mass.totalmass =  scale_SMAD_parameter(known.power.p_total, sc_type, 'p_total','m_total');  % redefine as unknown here
    unknown.mass.m_margin = unknown.mass.totalmass*margin;
    unknown.mass.m_total_margin = unknown.mass.totalmass- unknown.mass.m_margin;
    
    for i=1:numel(unknown_parameters)
      %known.mass.totalmass
      if not(strcmp(fieldnames(unknown.mass){i},'totalmass'))
        unknown.mass.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*unknown.mass.m_total_margin;
      end
    endfor
    
    %unknown power estimate handling
    if isfield(unknown,'power')
      unknown_parameters = fieldnames(unknown.power);
      
      % for consistence in power estimates, do not apply a given power total
      power_tot_relevant = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total','p_total');
      
      for i=1:numel(fieldnames(unknown.power))
          if not(strcmp(unknown_parameters{i},'p_total'))
          unknown.power.(unknown_parameters{i}) = scale_SMAD_parameter(unknown.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*power_tot_relevant;
          end
      endfor

      %restablish sum of total power
      new_power_tot = sum_powers(known.power, unknown.power);
      
       %update total power
      if isfield(unknown.power, 'p_total')
        unknown.power.p_total = new_power_tot;
      elseif isfield(known.power, 'p_total')
        if new_power_tot >  known.power.p_total
          disp('')
          disp((strcat('Info: Total power estimate increased to',{' '}, num2str(new_power_tot), ' W')){1});
          disp('')
          known.power.p_total = new_power_tot;
        else 
          known.power.p_margin = known.power.p_total-new_power_tot;
          known.power.p_total_margin = new_power_tot;
        end
      end
    
    %update mass of power system
    unknown.mass.m_power = scale_SMAD_parameter(new_power_tot, sc_type, 'p_total','fraction_m_power')*unknown.mass.m_total_margin;
    end
  
    % total mass check
    [known.mass.totalmass known.mass.m_margin known.mass.m_total_margin] = mass_validate(known.mass,unknown.mass);
endfunction

function [known unknown]        = system_with_known_totalmass(known, unknown, margin, sc_type)                % when only total mass is known, this. % missing case with total power?
  
    if isfield(unknown,'mass')
      %disp(unknown)
      unknown_parameters = fieldnames(unknown.mass);
      
      known.mass.m_margin = known.mass.totalmass*margin;
      known.mass.m_total_margin = known.mass.totalmass- known.mass.m_margin;
      
      for i=1:numel(fieldnames(unknown.mass))
        %known.mass.totalmass
        unknown.mass.(unknown_parameters{i}) = scale_SMAD_parameter(known.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*known.mass.m_total_margin;
      endfor
    end 
    
    
    %power handling
    if isfield(unknown,'power')
      unknown_parameters = fieldnames(unknown.power);
      
      % for consistence in power estimates, do not apply a given power total
      power_tot_relevant = scale_SMAD_parameter(known.mass.m_total_margin, sc_type, 'm_total','p_total');
      
      for i=1:numel(fieldnames(unknown.power))
          if not(strcmp(unknown_parameters{i},'p_total'))
            unknown.power.(unknown_parameters{i}) = scale_SMAD_parameter(known.mass.m_total_margin, sc_type, 'm_total',strcat('fraction_',unknown_parameters{i}))*power_tot_relevant;
          end
      endfor

      %restablish sum of total power
      if isfield(known,'power')
        new_power_tot = sum_powers(known.power, unknown.power);
      else
        standin.variable.name = 0
        new_power_tot = sum_powers(standin.variable, unknown.power);
      endif

    
    
       %update total power
      if isfield(unknown.power, 'p_total')
        unknown.power.p_total = new_power_tot;
      elseif isfield(known.power, 'p_total')
        if new_power_tot >  known.power.p_total
          disp('')
          disp((strcat('Info: Total power estimate increased to',{' '}, num2str(new_power_tot), ' W')){1});
          disp('')
          known.power.p_total = new_power_tot;
        else 
          known.power.p_margin = known.power.p_total-new_power_tot;
          known.power.p_total_margin = new_power_tot;
        end
      end
      
      %update mass of power system
      unknown.mass.m_power = scale_SMAD_parameter(new_power_tot, sc_type, 'p_total','fraction_m_power')*known.mass.totalmass;
    end
    % total mass check
    if isfield(unknown,'mass')
      [known.mass.totalmass known.mass.m_margin known.mass.m_total_margin] = mass_validate(known.mass, unknown.mass);
    end
endfunction

function [p_new]                = sum_powers(p_known, p_unknown)                                              % updates: the total system power input fields of known and unknown.power
  
  % case handling if known or unknown power total
    disp(p_known)
    disp(p_unknown)
  p_new = 0;
    %add derived system powers
    parameters= fieldnames(p_known);
    for i=1:numel(parameters)
      if not(strcmp(parameters{i},'p_total'))
      p_new = p_new+p_known.(parameters{i});
      end
    end
    
    %add known system powers
    parameters= fieldnames(p_unknown);
    for i=1:numel(parameters)
      if not(strcmp(parameters{i},'p_total'))
        p_new = p_new + p_unknown.(parameters{i});
      end
    end
    
endfunction

function [totalmass m_margin m_total_margin] = mass_validate(m_known,m_unknown);                              % checks the applicable masses of the system, recalculates the available margin
  
  
  
  
  

  m_new = 0;
  % add derived system masses
  parameters= fieldnames(m_unknown);
  for i=1:numel(parameters)
    if not(strcmp(parameters{i},'totalmass') || strcmp(parameters{i},'m_margin') || strcmp(parameters{i},'m_total_margin'))
      m_new=m_new +m_unknown.(parameters{i});
    endif
  endfor

  % add known system masses
  parameters= fieldnames(m_known);
  for i=1:numel(parameters)
    if not(strcmp(parameters{i},'totalmass') || strcmp(parameters{i},'m_margin') || strcmp(parameters{i},'m_total_margin'))
      m_new=m_new +m_known.(parameters{i});
    endif
  endfor

  if isfield(m_unknown, 'totalmass')
      m_tot         = m_unknown.totalmass;
      m_tot_margin  = m_unknown.m_total_margin;
      m_margin_old  = m_unknown.m_margin;
  elseif isfield(m_known, 'totalmass')
      m_tot         = m_known.totalmass;
      m_tot_margin  = m_known.m_total_margin;
      m_margin_old  = m_known.m_margin;
  end
  % compare sum to previous margin sum

  diff_m = m_tot_margin - m_new;
  
  %new residual margin mass 
  m_margin = m_margin_old + diff_m;
  m_total_margin = m_tot - m_margin; 

  if (m_new > m_tot || m_margin < 0)
    disp('Warning: Total mass limit exceeded!');
    totalmass = m_new;
    m_margin =0;
  else 
    totalmass  = m_tot;
  endif

endfunction


function [mission_parameters] = orbit_initialize(mission_inputs, sim)
  mission_parameters = struct;
  %disp(mission_inputs)
  %disp(sim.Simulation_parameters)
  if isfield(mission_inputs,'orbit_height')                                                                  % case for given orbit height
    if (mission_inputs.orbit_height > sim.Simulation_parameters.defaults.orbit_min)                           % compare if min is correct
      height = mission_inputs.orbit_height;
    else
      height = sim.Simulation_parameters.defaults.orbit_min;
    end
    mission_parameters.orbit =  orbit_parameters_Earth(height);
  else                                                                                                      % case for unknown orbit height, but use default from orbit type (no prop, LEO, GEO, probe)
    if mission_inputs.derived.sc_type == 1
      height = sim.Simulation_parameters.defaults.orbit.no_propulsion;
    elseif mission_inputs.derived.sc_type == 2
      height = sim.Simulation_parameters.defaults.orbit.Low_Earth;
    elseif mission_inputs.derived.sc_type == 3
      height = sim.Simulation_parameters.defaults.orbit.High_Earth;
    else
      height = sim.Simulation_parameters.defaults.orbit_min;
    end           
    mission_parameters.orbit =  orbit_parameters_Earth(height);    % missing case for space probe
  end
  %disp(height)
  %disp(mission_parameters)
  % if not, do estimate by orbit type bla 
  
endfunction
