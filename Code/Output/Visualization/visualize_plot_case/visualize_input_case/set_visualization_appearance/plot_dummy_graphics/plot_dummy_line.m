function [] = plot_dummy_line(plot_case, line_type, line_color, line_width)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xdum, ydum, zdum] = get_dummy_line_3d(plot_case);
    obj = plot3(xdum, ydum, zdum, "linestyle", line_type, "color", line_color, "linewidth", line_width);
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xdum, ydum] = get_dummy_line_2d(plot_case);
    obj = plot(xdum, ydum, "linestyle", line_type, "color", line_color, "linewidth", line_width);
  end
  set(obj, "visible", "off");
end