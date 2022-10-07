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
   systemmasses.m_dry_nomargin  = determine_m_dry(data);          
   
   systemmasses.m_margin        = m_margin(systemmasses.m_dry_nomargin, sc_type);   
   systemmasses.m_dry_margin    = systemmasses.m_dry_nomargin - systemmasses.m_margin;
   
   systemmasses.m_propellant    = data.mass - systemmasses.m_dry_nomargin;
   
   %TODO: AUTOMATE THIS IN A LOOP
   systemmasses.m_payload       = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "m_payload");
   systemmasses.m_structmech    = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_structmech")*systemmasses.m_dry_margin;
   systemmasses.m_thermal       = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_thermal")*systemmasses.m_dry_margin;
   systemmasses.m_power         = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_power")*systemmasses.m_dry_margin;  
   systemmasses.m_ttc           = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_TTC")*systemmasses.m_dry_margin;
   systemmasses.m_adc           = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_ADC")*systemmasses.m_dry_margin;
   systemmasses.m_propulsion    = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_propulsion")*systemmasses.m_dry_margin;
   systemmasses.m_other         = scale_SMAD_parameter(systemmasses.m_dry_margin, sc_type, "m_total", "fraction_m_other")*systemmasses.m_dry_margin;

%   
   %Check for remaining mass difference
   checksum =  systemmasses.m_margin +systemmasses.m_propellant+systemmasses.m_payload+systemmasses.m_structmech +systemmasses.m_thermal+ systemmasses.m_power+ systemmasses.m_ttc+ systemmasses.m_adc+systemmasses.m_propulsion+ systemmasses.m_other;
   
   %Add discrepancy to margin
   systemmasses.m_margin= systemmasses.m_margin+ data.mass-checksum;
   
   if systemmasses.m_margin<0
      disp('No system margin left');
   end
   if isfield(data,'p_total')
    systempowers.p_total = data.p_total;
   else
    systempowers.p_total = p_tot_average(systemmasses.m_dry_nomargin, sc_type);
   end
   
   systempowers.p_payload       = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_payload")*systempowers.p_total;
   systempowers.p_structmech     = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_structmech")*systempowers.p_total;
   systempowers.p_thermal       = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_thermal")*systempowers.p_total;
   systempowers.p_power         = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_power")*systempowers.p_total;  
   systempowers.p_ttc           = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_TTC")*systempowers.p_total;
   systempowers.p_adc           = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_ADC")*systempowers.p_total;
   systempowers.p_propulsion    = scale_SMAD_parameter(systempowers.p_total, sc_type, "p_total", "fraction_p_propulsion")*systempowers.p_total;
   
endfunction



function [m_dry] = determine_m_dry(data)
    if isfield(data,'dv') && isfield(data,'c_e')
      m_dry = exp(-data.dv/data.c_e)*data.mass;
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
