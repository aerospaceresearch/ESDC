function [m_propellant_out] = m_scale_propellant(mass, dv, c_e)
    I_tot = c_e.*mass.*(1-exp(-dv./c_e));
    m_propellant_out = I_tot./c_e;
end
