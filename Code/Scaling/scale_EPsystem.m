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


