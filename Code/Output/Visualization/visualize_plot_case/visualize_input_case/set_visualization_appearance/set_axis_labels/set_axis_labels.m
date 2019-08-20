function [] = set_axis_labels(plot_case)
  if plot_case.appearance.labels.active
    fontsize = plot_case.appearance.labels.fontsize;
    
    name = get_label_name(plot_case, "x");
    xlabel(name, "fontsize", fontsize);
    
    name = get_label_name(plot_case, "y");
    ylabel(name, "fontsize", fontsize);
    
    if strcmp(get_plot_case_type(plot_case), "3d")
      name = get_label_name(plot_case, "z");
      zlabel(name, "fontsize", fontsize);
    end
  end
end