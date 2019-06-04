function [] = makePlotFullSystemPowerComparison(analysis,case_type)
disp(' ')
disp(' Output production: Full System Power Comparison Graph')
disp(' ')
plotLegend = [];

    fig_handle = figure('Name',strcat('Full Case Power Comparison ', case_type));
    hold on;
    for i=1:size(analysis,2)
        plot(analysis(i).c_e,analysis(i).P_jet,'color',rand(1,3),'LineWidth',1.5);
        plotLegend=[plotLegend cellstr(analysis(i).description)];
    end
    
    lgd = legend('Location','northeast',plotLegend);
    xlabel('c_e / m/s');
    ylabel('P_{jet} / W');
    
    saveas(fig_handle,strcat('Output/','ESDC Full Concept Power Comparison ', case_type,'.png'),'png');
    disp(strcat('Output complete: Full Concept Power Comparison Plot'));
end
