function [PSS_system] = analysis_power_system(design, input, db_data, config) % here the analysis of the power system is performed
  %disp('Power system analysis')
  %disp(input)
  %disp(design)
  
  %TODO: include mass relations
  
  PSS_system = struct;                                                          % overall data structure power supply system
  PSS_system.PV = struct;                                                       % data on photovoltaics
  PSS_system.battery = struct;                                                  % data on batteries
  PSS_system.converter = struct;                                                % data on power conversion units
  PSS_system.parameter = struct;                                                % data on general system parameters
  
  orbit =  input.orbit.orbit;
  height = orbit.height;

  constants = celestial_constants();                                            % use solar system and physical constants
  au = constants.au;
  solar_constant = constants.solar_constant_at_au;
  
  % area specific power available
  p_a_mean = solar_constant;
  p_a_min = solar_constant*(au/(au+height))^2;
  p_a_max = solar_constant*(au/(au-height))^2;
  

  % solar cells
  t_orbit = orbit.time.orbit;
  t_sun = orbit.time.average_light;                                                                   %considers penumbra light reduction
  fraction_sun_time_orbit = t_sun/t_orbit;
  
  %worst case power consumption full orbit
  p_consumed_max = design.subsystem_powers.p_total- design.subsystem_powers.p_propulsion+design.p_propulsion;

  
  eff_battery = 0.95;                                                                                % https://batterytestcentre.com.au/project/lithium-ion/
  eff_converter = 0.96;                                                                              % https://nanoavionics.com/cubesat-components/cubesat-electrical-power-system-eps/
  power_margin = 1.25;                                                                                % TODO: add margin definition to defaults as well as as option , currently fixed to 20 % https://standards.nasa.gov/standard/gsfc/gsfc-std-1000
  
  eff_PV = 0.4;                                                                                       % http://www.azurspace.com/images/products/0004355-00-01_3C44_AzurDesign_10x10.pdf , use adaptive values here
  PV_power_output_required =  p_consumed_max/(eff_battery*eff_converter)*power_margin;           %add losses, margin should also include inclination errors

  
  PV_eff_area_required = PV_power_output_required/(p_a_mean*eff_PV);
  
  PV_heat_from_solar = PV_eff_area_required*p_a_mean*(1-eff_PV);
  
  %m_PV =                                                                       % correlate from DB through output power
  
  % batteries                                                                                     
                                                                                                     % dependency on peak power maneuvre time is critical here 
  t_shadow = orbit.time.shadow.total;
  %worst case battery charge to be stored

  E_battery_required_max = p_consumed_max*t_shadow/eff_battery;
  P_batt_max = E_battery_required_max/t_shadow;
  Q_batt =  P_batt_max*(1- eff_battery);
  U_batt_default = 28;                                                                              % https://ntrs.nasa.gov/api/citations/20150019744/downloads/20150019744.pdf , distinction for 10 kW 70 and 100 V, ISS 160 -> 120V
  I_batt_max = P_batt_max/U_batt_default;
  n_cycles_per_year = ceil(31557600/t_orbit);
  

  % depth_of_discharge =                                                                              % TDOD definition and othres https://ntrs.nasa.gov/api/citations/20090023862/downloads/20090023862.pdf
  % m_batt =                                                                    % correlate from DB by capacity

  % converters/PDU/PSU/PPU
  I_PDU_in  = PV_power_output_required/U_batt_default;
  I_PDU_out = P_batt_max/U_batt_default*eff_converter;
  Q_PDU_max = P_batt_max*(1-eff_converter);
  

  % m_PDU =                                                                     % correlate from DB by output current
  
  %harness 
  %m_PPS = m_PDU+m_batt+m_PV;
  
  %m_harness= 0.25*m_PPS; % 10-25% according to SMAD 205 .pdf page 221, book page 423
  
  %m_PPS = m_PPS+m_harness
  
  
  PSS_system.parameter.p_a_mean       = p_a_mean;
  PSS_system.parameter.p_a_min        = p_a_min;
  PSS_system.parameter.p_a_max        = p_a_max;
  PSS_system.parameter.p_consumed_max = p_consumed_max;
  PSS_system.parameter.power_margin   = power_margin;

  PSS_system.PV.PV_power_output_required = PV_power_output_required;
  PSS_system.PV.PV_efficiency            = eff_PV ;
  PSS_system.PV.PV_eff_area_required  = PV_eff_area_required;
  PSS_system.PV.heat.Q_PV_solar_irradiance = PV_heat_from_solar;

  PSS_system.battery.E_battery_required_max = E_battery_required_max;
  PSS_system.battery.P_batt_max       = P_batt_max;
  PSS_system.battery.heat.Q_batt_max         = Q_batt;
  PSS_system.battery.voltage          = U_batt_default;
  PSS_system.battery.current_max      = I_batt_max;
  PSS_system.battery.n_cycles_per_year= n_cycles_per_year;
  PSS_system.battery.batt_efficiency       = eff_battery;

  PSS_system.converter.I_PDU_in       = I_PDU_in;
  PSS_system.converter.I_PDU_out      = I_PDU_out;
  PSS_system.converter.heat.Q_conv_max       = Q_PDU_max;
  PSS_system.converter.PDU_efficiency     = eff_converter;


end
