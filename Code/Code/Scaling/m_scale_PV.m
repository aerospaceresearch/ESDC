function [m_Panel_out] = m_scale_PV(P_out)
%currently scaled for requested output power
    m_0     = 0;
    slope   = 1/64.242; % W/kg Ref:http://dhvtechnology.com/wp-content/uploads/2017/07/Datasheet-Julio-v1-front-back.pdf

    m_Panel_out = m_0+ slope.*P_out;

end