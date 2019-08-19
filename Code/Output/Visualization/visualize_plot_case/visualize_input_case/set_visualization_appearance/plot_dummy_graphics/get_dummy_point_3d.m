function [xdum, ydum, zdum] = get_dummy_point_3d(plot_case)
  [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
  xdum = mean(xlimits);
  ydum = mean(ylimits);
  zdum = mean(zlimits);
end