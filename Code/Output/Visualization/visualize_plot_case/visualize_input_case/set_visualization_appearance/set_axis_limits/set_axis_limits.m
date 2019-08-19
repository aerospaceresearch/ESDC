function [] = set_axis_limits(plot_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
    xlim(xlimits)
    ylim(ylimits)
    zlim(zlimits)
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xlimits, ylimits] = get_axes_limits_2d(plot_case);
    xlim(xlimits)
    ylim(ylimits)
  end
end