function [xdum, ydum] = get_dummy_point_2d(plot_case)
  [xlimits, ylimits] = get_axes_limits_2d(plot_case);
  xdum = mean(xlimits);
  ydum = mean(ylimits);
end