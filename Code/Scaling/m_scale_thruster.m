function [m_Thruster_out] = m_scale_thruster(P_thruster, type)
t_1=now;
m_0_set = [];
slope_set = [];

for i=1:size(P_thruster,2)
    
    if strcmp(type,'arcjet')
    
        if P_thruster(i) <= 300
            m_0     = 0.3;        % Velarc mass
            slope   = 0;        % constant for P <300 W
        end
        if ((P_thruster(i)>= 300) && (P_thruster(i) < 1500))
            m_0     = 0.2;        % ATOS/ARTUS 0.7 kg at 1500 W
            slope   = 0.00033333333333333333;

        end
        if ((P_thruster(i) >= 1500) && (P_thruster(i) < 10000))
            m_0     = 0.4882352941176471;        % MARC
            slope   = 0.00014117647058823529;
        end

        if P_thruster(i) >= 10000
            m_0     = 0.0196581196581199205;        % HIPARC
            slope   = 0.00018803418803418803;  
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    elseif strcmp(type,'gridionthruster')       % http://www.space-propulsion.com/brochures/electric-propulsion/electric-propulsion-thrusters.pdf
            
        if P_thruster(i) <= 50                            % RIT μX
            m_0     =0.44;    
            slope   =0;             
        end
        
        if ((P_thruster(i)>= 50) && (P_thruster(i) < 2000))     %RIT 10 EVO
            m_0     =0.027;    
            slope   =0.0034;       
        end
        
        if P_thruster(i) >= 2000                          % RIT 2X
            m_0     =0.027;    
            slope   =0.0034;    
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    else
        disp('This type of thruster not yet implemented');
    end
end
    m_Thruster_out = m_0_set + slope_set.*P_thruster;
    
    
end