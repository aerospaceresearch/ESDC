function [xdum, ydum] = get_dummy_line_2d(plot_case)
  [xlimits, ylimits] = get_axes_limits_2d(plot_case);
  xdum = [sum([0.51, 0.49].*xlimits), sum([0.49, 0.51].*xlimits)];
  ydum = [sum([0.51, 0.49].*ylimits), sum([0.49, 0.51].*ylimits)];
end