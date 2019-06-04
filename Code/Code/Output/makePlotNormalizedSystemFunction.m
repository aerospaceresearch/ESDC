function [] = makePlotNormalizedSystemFunction(input)
disp(' ')
disp(' Output production: Normalized System Component Graphs')
disp(' ')

    fig_handle = figure('Name',strcat('Component comparison ',input.description));
    hold on
        plot(input.c_e,input.result.EP_sys_mass./input.result.EP_sys_mass,'-k','LineWidth',1.5);
        plot(input.c_e,input.result.PPU_mass./input.result.EP_sys_mass,'-b','LineWidth',1.5);
        plot(input.c_e,input.result.PV_mass./input.result.EP_sys_mass,'-r','LineWidth',1.5);
        plot(input.c_e,input.result.tank_mass./input.result.EP_sys_mass,'-c','LineWidth',1.5);
        plot(input.c_e,input.result.thruster_mass./input.result.EP_sys_mass, 'color',[0 .5 .5],'LineWidth',1.5);
        plot(input.c_e,input.result.structure_mass./input.result.EP_sys_mass,'-y','LineWidth',1.5);
        plot(input.c_e,input.result.propellant_mass./input.result.EP_sys_mass,'-m','LineWidth',1.5);
        plot([input.result.mu_EP_min_c_e input.result.mu_EP_min_c_e],[0 1],'-dk');
    xlabel('c_e / m/s');
    ylabel('\mu_{Component} / -');
    ylim([0 1]);
    %todo plot2 file 
    
    lgd = legend('Location','northeast','System','PPU','Solar Panel','Tank','Thruster','Structure','Propellant','Minimum');

    saveas(fig_handle,strcat('Output/','ESDC Component Comparison Plot ',strrep(input.description,char(10),''),'.png'),'png');

    disp(strcat('Output complete: Componentwise comparison',input.description));
        hold off
end

