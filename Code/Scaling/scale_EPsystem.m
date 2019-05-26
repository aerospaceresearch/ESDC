function [data] = scale_EPsystem(input)


for i = 1:size(input,2)
    
    m = linspace(0,0,size(input(1).c_e,2));
    
    data(i).PPU_mass = m_scale_PPU(input(i).PPU_P,input(i).PPU_eff, input(i).propulsion_type);
    m = m +data(i).PPU_mass;

    data(i).PV_mass = m_scale_SolarPanel(input(i).PPU_P);
    m = m + data(i).PV_mass;

    data(i).propellant_mass = m_scale_propellant(input(i).sat_mass, input(i).delta_v, input(i).c_e);
    m = m + data(i).propellant_mass;

    data(i).tank_mass = m_scale_tank(data(i).propellant_mass, input(i).propellant);
    m = m + data(i).tank_mass;

    data(i).thruster_mass = m_scale_thruster(input(i).PPU_P, input(i).propulsion_type); 
    m = m + data(i).thruster_mass;
    
    data(i).structure_mass = m_scale_structure(input(i).struct_mass);
    m = m + data(i).structure_mass;

    EP_sys_mass= m;
        for j=1:size(EP_sys_mass,2)
            if EP_sys_mass(j)>input(i).sat_mass
                EP_sys_mass(j) = input(i).sat_mass+1;
            end
        end
    data(i).EP_sys_mass = EP_sys_mass;

    mu_EP = data(i).EP_sys_mass./input(i).sat_mass;
        for j=1:size(mu_EP,2)
            if mu_EP(j)>1
                mu_EP(j) = 1.01;
            end
        end
    data(i).mu_EP =mu_EP;
    
    if size(input(i).c_e,2)>1
        disp(input(i).description);
        [data(i).mu_EP_min, mu_min_index] = min(data(i).mu_EP);
        % TODO output all of this into data file 
        data(i).mu_EP_min_c_e = input(i).c_e(mu_min_index);
        PPU = data(i).PPU_mass(mu_min_index);
        PV  =data(i).PV_mass(mu_min_index);
        tank = data(i).tank_mass(mu_min_index);
        thruster = data(i).thruster_mass(mu_min_index);
        prop = data(i).propellant_mass(mu_min_index);
        sys_mass = data(i).EP_sys_mass(mu_min_index);
        P_jet = input(i).PPU_P(mu_min_index);
    end

    
end


end

function [m_PPU_out] = m_scale_PPU(P_in,eta_PPU,type)

    if strcmp(type,'Arcjet')
% Ref:BB28 report for scaling of PPU mass
    m_0     = 1.011;
    slope   = 2.465/1000;
    
    elseif strcmp(type,'GridIonThruster')
            m_0     = 1.5;       % DCIU % AIAA-2006-5 162  Mission Benefits of Gridded Ion and Hall Thruster Hybrid Propulsion Systems
            slope   = 2.5/1000;
        
    else
        disp('Unknown thruster - no PPU scaling available in m_scale_PPU')
    end
    
    m_PPU_out = m_0+slope.*P_in./eta_PPU;
end

function [m_Panel_out] = m_scale_SolarPanel(P_out)
%currently scaled for requested output power
    m_0     = 0;
    slope   = 1/64.242; % W/kg Ref:http://dhvtechnology.com/wp-content/uploads/2017/07/Datasheet-Julio-v1-front-back.pdf

    m_Panel_out = m_0+ slope.*P_out;

end

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

function [m_Thruster_out] = m_scale_thruster(P_in, type)

m_0_set = [];
slope_set = [];

for i=1:size(P_in,2)
    
    if strcmp(type,'Arcjet')
    
        if P_in(i) <= 300
            m_0     = 0.3;        % Velarc mass
            slope   = 0;        % constant for P <300 W
        end
        if ((P_in(i)>= 300) && (P_in(i) < 1500))
            m_0     = 0.2;        % ATOS/ARTUS 0.7 kg at 1500 W
            slope   = 0.00033333333333333333;

        end
        if ((P_in(i) >= 1500) && (P_in(i) < 10000))
            m_0     = 0.4882352941176471;        % MARC
            slope   = 0.00014117647058823529;
        end

        if P_in(i) >= 10000
            m_0     = 0.0196581196581199205;        % HIPARC
            slope   = 0.00018803418803418803;  
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    elseif strcmp(type,'GridIonThruster')       % http://www.space-propulsion.com/brochures/electric-propulsion/electric-propulsion-thrusters.pdf
            
        if P_in(i) <= 50                            % RIT μX
            m_0     =0.44;    
            slope   =0;             
        end
        
        if ((P_in(i)>= 50) && (P_in(i) < 2000))     %RIT 10 EVO
            m_0     =0.027;    
            slope   =0.0034;       
        end
        
        if P_in(i) >= 2000                          % RIT 2X
            m_0     =0.027;    
            slope   =0.0034;    
        end
    m_0_set = [m_0_set m_0];
    slope_set = [slope_set slope];
    else
        disp('This type of thruster not yet implemented');
    end
end
    m_Thruster_out = m_0_set + slope_set.*P_in;
end

function [m_propellant_out] = m_scale_propellant(mass, dv, c_e)
    I_tot = c_e.*mass.*(1-exp(-dv./c_e));
    m_propellant_out = I_tot./c_e;
end

function [m_struct_out] = m_scale_structure(m)
% elaborate further?

m_struct_out= m;
end
