function [m_PPU_out] = m_scale_PPU(P_in,eta_PPU,propulsion_system)


    if strcmp(propulsion_system,'arcjet')
% Ref:BB28 report for scaling of PPU mass
    m_0     = 1.011;
    slope   = 2.465/1000;
    
    elseif strcmp(propulsion_system,'gridionthruster')
            m_0     = 1.5;       % DCIU % AIAA-2006-5 162  Mission Benefits of Gridded Ion and Hall Thruster Hybrid Propulsion Systems
            slope   = 2.5/1000;
        
    else
        disp('Unknown thruster - no PPU scaling available in m_scale_PPU')
    end
    
    m_PPU_out = m_0+slope.*P_in./eta_PPU;
end