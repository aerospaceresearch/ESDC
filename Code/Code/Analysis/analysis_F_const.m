function [analysis] = analysis_F_const(input, data, config)
%case specific walking of parameter space
disp('Simple analysis for c_e variation at constant thrust ...');
disp(' ');

analysis = input ; 

for i=1:size(input,2)  % for each concept
    
   analysis(i).description = char([analysis(i).description ' and F = '  num2str(analysis(i).F) ' N']);
        c_e = linspace(config.(analysis(i).propulsion_type).c_e_min, config.(analysis(i).propulsion_type).c_e_max, 1000);
         % Todo: adapt resolution = 1000 through config here
        % Calculate data from c_e span    
        analysis(i).c_e = c_e;
        analysis(i).m_dot= analysis(i).F./c_e;
        analysis(i).P_jet = 1/2.*analysis(i).m_dot.*c_e.^2;
        
        analysis(i).PPU_P = analysis(i).P_jet./( analysis(i).PPU_eff*analysis(i).eff);

        analysis(i).result = scale_EPsystem(analysis(i));
        disp(' ');
        disp('Min achieveable \mu_{EP}');
        disp(analysis(i).result.mu_EP_min);
        disp('at');
        disp(strcat('c_e = ',num2str(analysis(i).result.mu_EP_min_c_e),' m/s'));
        disp(' ');

    %Output
    % Plot Component Sysem Mass fraction of components normed to total sys mass
        if config.plots_componentwise == 1
                makePlotNormalizedSystemFunction(analysis(i));
        end
end

% Plot comparison of system mass fractions of all input concepts
    if config.plot_systemcompare == 1  
            makePlotFullSystemComparison(input, data, analysis,config, ' constant thrust');        
    end
    
    makePlotFullSystemPowerComparison(analysis, ' constant thrust'); 
    makePlotFullSystemBurnTimeComparison(analysis,' constant thrust');

end
