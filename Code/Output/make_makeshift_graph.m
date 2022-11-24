function [] = make_makeshift_graph(filename_old, data, data_fit)
  

  filename = strrep(filename_old, '.csv', '.png');
  filename = strrep(filename, 'Database/Scaling/', 'Output/');
  
  title =filename_old(8:end-4);
  
  if strfind(filename_old,'spacecraft')     % graphs only for SC currently, TODO add case handling of comps?
    str_underscores   = strfind(filename_old,'_');       % have to count backwards, because incosistent orbit type _ number
    str_param         = strfind(filename_old,'parameter');
    str_to            = strfind(filename_old,'_to_');
    str_orbit_type    = filename_old(1,str_underscores(2)+1:str_param-2); % orbit type is found bewteen second underscore and "parameter"
    
    str_param_x_axis  = filename_old(1,str_param+10:str_to-1);

    str_unit_x_axis   = define_graph_unit(str_param_x_axis);
    
    if strcmp(str_param_x_axis(1,1),'p')
      str_param_x_axis(1,1)='P';
    endif
    
    str_param_y_axis = filename_old(1,str_to+4:end-4);
    str_unit_y_axis = define_graph_unit(str_param_y_axis);
    
      
    if strcmp(str_param_y_axis(1,1),'p');
      str_param_y_axis(1,1)='P';
    endif
    str_param_x_axis = strrep( str_param_x_axis,'_',' ');
    str_param_y_axis = strrep( str_param_y_axis,'_',' ');
    
    
    strcat(str_param_x_axis,str_unit_x_axis);
    strcat(str_param_y_axis,str_unit_y_axis);
    
    annotation_string=strcat('Orbit type:',{''} ,str_orbit_type);

    title = erase(filename, "Output/");

    #extract type, add to text box 
    
      fig_handle = figure('Name',title,'visible','off');            % use invisible here to avoid number of figure popups during updatinggiu
      set(0,'CurrentFigure',fig_handle);
      hold on;
      annotation('textbox',[.15 .9 .3 .8],'String',annotation_string,'FitBoxToText','on','Edgecolor','white','FontSize',16);
      xlabel(strcat(str_param_x_axis,str_unit_x_axis),'FontSize',16);
      ylabel(strcat(str_param_y_axis,str_unit_y_axis),'FontSize',16);
      plot(data(2,:),data(1,:), '*k','MarkerSize',12);
      plot(data_fit(2,:),data_fit(1,:), '-k','LineWidth',2);
      saveas(fig_handle,filename,'png');
      hold off;
      close;
    
  end
end

function unit = define_graph_unit(input)
  %disp(input)
  input=input(1); % take only the first letter for determination of unit assignement - might become buggy
  
  if strcmp(input,'m') 
    unit = ' / kg';
  endif
  
  if strcmp(input,'p')
    unit = ' / W';
  endif
  
  if strcmp(input,'f')
    unit = ' / -';
  endif
  
  if strcmp(input,'s')
    unit = ' / m';
  endif
endfunction