function [] = makePlotFullSystemThrustComparison(analysis,case_type)
disp(' ')
disp(' Output production: Full System Comparison Graph')
disp(' ')
plotLegend = [];

    fig_handle = figure('Name',strcat('Full Case Thrust Comparison ', case_type));
    hold on;
    for i=1:size(analysis,2)
        F = 2*analysis(i).P_jet./analysis(i).c_e;
        plot(analysis(i).c_e,F,'color',rand(1,3),'LineWidth',1.5 );
        plotLegend=[plotLegend cellstr(analysis(i).description)];
    end
    hold off
    
    lgd = legend('Location','northeast',plotLegend);

    xlabel('c_e / m/s')
    ylabel('F / N')

    saveas(fig_handle,strcat('Output/','ESDC Full Concept Thrust Comparison ', case_type,'.png'),'png')
    disp(strcat('Output complete: Full Concept Comparison Plot'));
end
