%Space Mission Engineering - The New SMAD
% Author(s): James Wertz, David Everett, Jeffery Puschell
% Series: Space Technology Library, Vol. 28
% Publisher: Microcosm Press, Year: 2011
% ISBN: 978-1881883159

%Page 422 Tab 14-18 Average Mass by System as a Percentage of Dry Mass for 4 Types of Spacecraft

%Factor - 1 no propulsion , 2  LEO up to 1000 km, 3 - above 1000, 4 - planetary probe

function [systemmasses] = SMAD_scalings(data)
   systemmasses = struct();
   
   sc_type = determine_sc_type(data);
   systemmasses.m_dry_nomargin  = determine_m_dry(data);
   systemmasses.m_margin        = m_Margin(systemmasses.m_dry_nomargin, sc_type);
   systemmasses.m_dry_margin    = systemmasses.m_dry_nomargin - systemmasses.m_margin;
   systemmasses.m_propellant    = data.mass - systemmasses.m_dry_nomargin;
   
   systemmasses.m_payload       = m_scale_Payload(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_structure     = m_scale_StructMecha(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_thermal       = m_scale_Thermal(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_power         = m_scale_Power(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_ttc           = m_scale_TTC(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_adc           = m_scale_ADC(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_propulsion    = m_scale_Propulsion(systemmasses.m_dry_margin, sc_type);
   systemmasses.m_misc          = m_scale_Misc(systemmasses.m_dry_margin, sc_type);
   
   %Check for remaining difference
   checksum =  systemmasses.m_margin +systemmasses.m_propellant+systemmasses.m_payload+systemmasses.m_structure +systemmasses.m_thermal+ systemmasses.m_power+ systemmasses.m_ttc+ systemmasses.m_adc+systemmasses.m_propulsion+ systemmasses.m_misc;
   
   %Add discrepancy to margin
   systemmasses.m_margin= systemmasses.m_margin+ data.mass-checksum;
   
   %disp(systemmasses);
endfunction

function [sc_type] = determine_sc_type(data)
    if isfield(data,'dv') && (data.dv >0) % only type 1,2,3 when propelled
      sc_type = 2; % LEO type mission is default
      if (data.dv >2000) && (data.dv <=4300)
        sc_type = 3; % High Earth type mission like GEO
      elseif (data.dv >4300) % dv to escape earth from orbital velocity, makes planetary probe type mission (3)
        sc_type = 4;
      endif
    else 
      sc_type = 1;
    endif
endfunction

function [m_dry] = determine_m_dry(data)
  if isfield(data,'dv')
    m_dry = exp(-data.dv/data.c_e)*data.mass;
  else
    m_dry = data.mass; %
  endif
endfunction


function m = m_scale_Payload(m_dry, sc_type)
  factor=[.41 .31 .32 .15];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_StructMecha(m_dry, sc_type)
  factor=[.20 .27 .24 .25];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_Thermal(m_dry, sc_type)
  factor=[.02 .02 .04 .06];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_Power(m_dry, sc_type)
  %power including harness
  factor=[.19 .21 .17 .21];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_TTC(m_dry, sc_type)
  factor=[.02 .02 .04 .07];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_OnBoardProcessing(m_dry, sc_type)
  factor=[.05 .05 .03 .04];
  m = m_dry*(factor(sc_type));
    
end

function m = m_scale_ADC(m_dry, sc_type)
  %attitude determination and control
  factor=[.08 .06 .06 .06];
  m = m_dry*(factor(sc_type));
  
end

function m = m_scale_Propulsion(m_dry, sc_type)
  factor=[0 .03 .07 .13];
  m = m_dry*(factor(sc_type));

end

function m = m_scale_Misc(m_dry, sc_type)
  %balance+launch
  factor=[.03 .03 .03 .03];
  m = m_dry*(factor(sc_type));
end

function m = m_Margin(m_dry, sc_type)
  %Mass budget margin
  factor=[.30 .30 .30 .30];
  m = m_dry*(factor(sc_type));

end


%Power Scaling
%Page 422 Tab 14-20 Average Mass by System as a Percentage of Dry Mass for 4 Types of Spacecraft

%Factor - 1 no propulsion , 2  LEO up to 1000 km, 3 - above 1000, 4 - planetary probe
function P = p_scale_Payload(P_tot, sc_type)
  factor=[.43 .46 .35 .22];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_StructMecha(P_tot, sc_type)
  factor=[.0 .1 .0 .1];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_Thermal(P_tot, sc_type)
  factor=[.5 .10 .14 .15];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_Power(P_tot, sc_type)
  %power including harness
  factor=[.10 .09 .07 .10];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_TTC(P_tot, sc_type)
  factor=[.11 .12 .16 .18];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_OnBoardProcessing(P_tot, sc_type)
  factor=[.13 .12 .10 .11];
  m = m_dry*(factor(sc_type));
    
end

function P = p_scale_ADC(P_tot, sc_type)
  %attitude determination and control
  factor=[.18 .10 .16 .12];
  m = m_dry*(factor(sc_type));
  
end

function P = p_scale_Propulsion(P_tot, sc_type)
  factor=[0 0 .02 .11];
  m = m_dry*(factor(sc_type));

end

