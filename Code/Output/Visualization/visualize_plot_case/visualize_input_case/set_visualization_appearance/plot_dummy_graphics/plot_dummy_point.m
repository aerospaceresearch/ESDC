function [] = plot_dummy_point(plot_case, marker_type, marker_color)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xdum, ydum, zdum] = get_dummy_point_3d(plot_case);
    obj = scatter3(xdum, ydum, zdum, "marker", marker_type, "markeredgecolor", marker_color);
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xdum, ydum] = get_dummy_point_2d(plot_case);
    obj = scatter(xdum, ydum, "marker", marker_type, "markeredgecolor", marker_color);
  end 
  set(obj, "visible", "off");
end