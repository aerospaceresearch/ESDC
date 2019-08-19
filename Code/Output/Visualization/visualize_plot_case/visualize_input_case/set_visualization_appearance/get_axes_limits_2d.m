function [xlimits, ylimits, zlimits] = get_axes_limits_2d(plot_case)
  if plot_case.appearance.custom_limits.active
    xlimits = plot_case.appearance.custom_limits.xlim;
    ylimits = plot_case.appearance.custom_limits.ylim;
  else
    xlimits = [plot_case.x.min_value, plot_case.x.max_value];
    if are_subsystems_bars_active(plot_case)
      ylimits = [0, plot_case.y.max_value];
    else
      ylimits = [plot_case.y.min_value, plot_case.y.max_value];
    end
  end
end