%Space Mission Engineering - The New SMAD
% Author(s): James Wertz, David Everett, Jeffery Puschell
% Series: Space Technology Library, Vol. 28
% Publisher: Microcosm Press, Year: 2011
% ISBN: 978-1881883159

%Page 422 Tab 14-18 Average Mass by System as a Percentage of Dry Mass for 4 Types of Spacecraft

%Factor - 1 no propulsion , 2  LEO up to 1000 km, 3 - above 1000, 4 - planetary probe

function [systemmasses systempowers] = SMAD_scalings(data)
  
  %disp(data)

   systemmasses                 = struct;
   systempowers                 = struct;
   
   sc_type                      = determine_sc_type(data);
   systemmasses.m_dry_nomargin  = determine_m_dry(data);                                 % total mass of system without considering any margin
   
   systemmasses.m_margin        = m_margin(systemmasses.m_dry_nomargin, sc_type);       % obtain typical margin mass to be applied to such a system
   systemmasses.m_dry_margin    = systemmasses.m_dry_nomargin - systemmasses.m_margin;  % calculate new maximum mass available when subtracting the margin mass
   
   systemmasses.mass_propellant    = data.mass - systemmasses.m_dry_nomargin;              % calculate the propellant mass by difference of total mass to dry mass
  
  
   %Scale subsystem masses accordingly
   systemmasses.mass_payload       = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_payload")*systemmasses.m_dry_margin;;
   systemmasses.mass_structmech    = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_structmech")*systemmasses.m_dry_margin;
   systemmasses.mass_thermal       = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_thermal")*systemmasses.m_dry_margin;
   systemmasses.mass_power         = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_power")*systemmasses.m_dry_margin;  
   systemmasses.m_ttc           = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_TTC")*systemmasses.m_dry_margin;
   systemmasses.m_adc           = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_ADC")*systemmasses.m_dry_margin;
   systemmasses.mass_propulsion    = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_propulsion")*systemmasses.m_dry_margin;
   systemmasses.mass_other         = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_mass_other")*systemmasses.m_dry_margin;

%   
   %Check for remaining mass difference
   %checksum = systemmasses.mass_propellant+systemmasses.mass_payload+systemmasses.mass_structmech +systemmasses.mass_thermal+ systemmasses.mass_power+ systemmasses.m_ttc+ systemmasses.m_adc+systemmasses.mass_propulsion+ systemmasses.mass_other;
   systemmasses.m_dry_margin = systemmasses.mass_payload+systemmasses.mass_structmech +systemmasses.mass_thermal+ systemmasses.mass_power+ systemmasses.m_ttc+ systemmasses.m_adc+systemmasses.mass_propulsion+ systemmasses.mass_other;

   %Add discrepancy to margin

   systemmasses.m_margin= systemmasses.m_dry_nomargin -systemmasses.m_dry_margin;

   
   if systemmasses.m_margin<0
      disp('No system margin left');
   end
   if isfield(data,'power_total')
    systempowers.power_total = data.power_total;
   else
    systempowers.power_total = p_tot_average(systemmasses.m_dry_nomargin, sc_type);
   end
   
   systempowers.power_payload       = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_payload")*systempowers.power_total;
   systempowers.power_structmech    = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_structmech")*systempowers.power_total;
   systempowers.power_thermal       = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_thermal")*systempowers.power_total;
   systempowers.power_power         = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_power")*systempowers.power_total;  
   systempowers.p_ttc           = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_TTC")*systempowers.power_total;
   systempowers.p_adc           = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_power_ADC")*systempowers.power_total;
   systempowers.propulsion_power    = scale_SMAD_parameter(systempowers.power_total, sc_type, "power_total", "fraction_propulsion_power")*systempowers.power_total;
   
endfunction



function [m_dry] = determine_m_dry(data)
    if isfield(data,'dv') && isfield(data,'c_e')
      m_dry = exp(-data.dv/data.c_e)*data.mass;
    elseif isfield(data,'mass_propellant')
      m_dry = data.mass - data.mass_propellant;
    else
      m_dry = data.mass; %
    endif
endfunction



function m = m_margin(m_dry, sc_type)       %TODO: config parameter
  %Mass budget margin
  factor=[.25 .25 .25 .25];         % https://standards.nasa.gov/standard/gsfc/gsfc-std-1000 
  m = m_dry*(factor(sc_type));   
end

%Power Scaling
%Page 423 Tab 14-20 Average Mass by System as a Percentage of Dry Mass for 4 Types of Spacecraft

%Factor - 1 no propulsion , 2  LEO up to 1000 km, 3 - above 1000, 4 - planetary probe

function P = p_tot_average(mass_dry, sc_type)
  power_factor=[299 794 691 749];
  mass_factor = mass_dry./[1497 2344 1258 888];
  P= mass_factor(sc_type)^(2/3)*power_factor(sc_type); % continue here with better data from 966 new SMAD
end
