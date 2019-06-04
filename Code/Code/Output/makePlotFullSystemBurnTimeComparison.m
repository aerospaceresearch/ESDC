function [] = makePlotFullSystemBurnTimeComparison(analysis,case_type)
disp(' ')
disp(' Output production: Full System Burn Time Comparison Graph')
disp(' ')
plotLegend = [];

    fig_handle = figure('Name',strcat('Full Case  Burn Time Comparison ', case_type));
    hold on;
    for i=1:size(analysis,2)
        t_burn = analysis(i).result.propellant_mass./analysis(i).m_dot;
        t_burn = t_burn./(60*60*24);
        plot(analysis(i).c_e,t_burn,'color',rand(1,3),'LineWidth',1.5 );
        plotLegend=[plotLegend cellstr(analysis(i).description)];
    disp('T burn max');
    disp(max(t_burn));
    end
    hold off
    
    disp('T burn max');
    disp(max(t_burn));

    lgd = legend('Location','northeast',plotLegend);

    xlabel('c_e / m/s');
    ylabel('t_{burn} / days');
    
    saveas(fig_handle,strcat('Output/','ESDC Full Concept Burn Time Comparison ', case_type,'.png'),'png');
    disp(strcat('Output complete: Full Concept Burn Time Comparison Plot', case_type));
end

