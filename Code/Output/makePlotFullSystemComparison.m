function [] = makePlotFullSystemComparison(input, data, analysis,config, case_type)
disp(' ')
disp(' Output production: Full System Comparison Graph')
disp(' ')
plotLegend = [];

    if config.ConsiderMargins == 1
        analysis = plot_margins(analysis, config);
    end

    fig_handle = figure('Name',strcat('Full Case Comparison ', case_type));
    hold on;
    for i=1:size(analysis,2)
        plot(analysis(i).c_e,analysis(i).result.mu_EP,'color',rand(1,3),'LineWidth',1.5 );
        plotLegend=[plotLegend cellstr(analysis(i).description)];
    end
    
    plotLegend =[ plotLegend 'Minima'];
    plotLegend =[ plotLegend 'Current Design'];
    
        if config.ConsiderMargins == 1
            plotLegend=[ plotLegend strcat(num2str(config.margin), ' % Margin')];
        end

    for i=1:size(analysis,2)
        plot(analysis(i).result.mu_EP_min_c_e,analysis(i).result.mu_EP_min,'dr');
        plot(input(i).c_e,data.reference(i).mu_EP,'xr');
            if config.ConsiderMargins == 1
               plot(analysis(i).mu_min_margin_c_e, analysis(i).mu_min_margin, '--k','LineWidth',1.5);
            end
    end
    
    lgd = legend('Location','northeast',plotLegend);

    xlabel('c_e / m/s');
    ylabel('\mu_{EPropSys} / -');
    ylim([0 1]);
    
    saveas(fig_handle,strcat('Output/','ESDC Full Concept Comparison ', case_type,'.png'),'png');
    disp(strcat('Output complete: Full Concept Comparison Plot'));
end
