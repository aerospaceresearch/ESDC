function [analysis] = analysis_P_const(input, data, config)
disp('Simple analysis for c_e variation at constant power ...');
disp(' ');

analysis = input ; 

for i=1:size(input,2)  % for each concept
    analysis(i).description= char([analysis(i).description ' and P = ' num2str(analysis(i).P_propulsion) ' W']);

        c_e = linspace(config.(analysis(i).propulsion_type).c_e_min, config.(analysis(i).propulsion_type).c_e_max, 1000);
         % Todo: adapt resolution = 1000 through config here

        % Calculate data from c_e span    
      analysis(i).c_e = c_e;
      analysis(i).P_jet = analysis(i).P_propulsion/(analysis(i).eff*analysis(i).PPU_eff).*ones(1,size(c_e,2));


   %   analysis(i).m_dot= 2.*analysis(i).P_jet./(c_e.^2);
      analysis(i).PPU_P = analysis(i).P_propulsion.*ones(1,size(c_e,2));
      
      analysis(i).result = scale_EPsystem(analysis(i));

      

      disp('Min achieveable \mu_{EP}');
      disp(analysis(i).result.mu_EP_min);
      disp('at');
      disp(strcat('c_e = ',num2str(analysis(i).result.mu_EP_min_c_e),' m/s'));
      disp(' ');
      
        if config.plots_componentwise == 1
                makePlotNormalizedSystemFunction(analysis(i));
        end
        

end
% Plot comparison of system mass fractions of all input concepts
    if config.plot_systemcompare == 1  
            makePlotFullSystemComparison(input, data, analysis,config, ' constant power supply');
    end
    
    makePlotFullSystemThrustComparison(analysis,' constant power supply'); 
    makePlotFullSystemBurnTimeComparison(analysis,' constant power supply');

end
