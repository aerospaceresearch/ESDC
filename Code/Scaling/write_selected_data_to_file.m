function [] = write_selected_data_to_file(x,y,filename, padbit)   %function to write 
  
    [data] = sort_data_to_x(x,y,padbit);
    
    if size(data,2)==1                  %linear scaling when only single data point available
      data = [data(:,1), 2.*data(:,1)];
    end
    [data_fit] = data_fitting(data,2);
    %write file  
    
    dlmwrite(filename, data, ",");
    dlmwrite(filename, data_fit, ",",'-append');
    
    make_makeshift_graph(filename, data, data_fit);

    %TODO add here name string appending of file
    %append with name strings
    disp(strcat(filename, " updated"));
  
endfunction


function [] = make_makeshift_graph(filename_old, data, data_fit)
  
  filename = strrep(filename_old, '.csv', '.png');
  filename = strrep(filename, 'Database/Scaling/', 'Output/');
  
  title =filename(8:end-4);
 % title = erase(filename, "Output/")
  
  fig_handle = figure('Name',title);
    hold on;
    plot(data(2,:),data(1,:), '*k');
    plot(data_fit(2,:),data_fit(1,:), '-k','LineWidth',1.5);
    saveas(fig_handle,filename,'png');
    hold off;
    close;
  
end