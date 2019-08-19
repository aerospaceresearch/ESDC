function [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case)
  if plot_case.appearance.custom_limits.active
    xlimits = plot_case.appearance.custom_limits.xlim;
    ylimits = plot_case.appearance.custom_limits.ylim;
    zlimits = plot_case.appearance.custom_limits.zlim;
  else
    xlimits = [plot_case.x.min_value, plot_case.x.max_value];
    ylimits = [plot_case.y.min_value, plot_case.y.max_value];
    if are_subsystems_bars_active(plot_case)
      zlimits = [0, plot_case.z.max_value];
    else
      zlimits = [plot_case.z.min_value, plot_case.z.max_value];
    end
  end
end