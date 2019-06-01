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
