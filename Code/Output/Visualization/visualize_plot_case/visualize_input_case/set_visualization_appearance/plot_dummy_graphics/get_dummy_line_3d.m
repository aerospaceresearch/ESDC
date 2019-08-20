function [xdum, ydum, zdum] = get_dummy_line_3d(plot_case)
  [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
  xdum = [sum([0.51, 0.49].*xlimits), sum([0.49, 0.51].*xlimits)];
  ydum = [sum([0.51, 0.49].*ylimits), sum([0.49, 0.51].*ylimits)];
  zdum = [sum([0.51, 0.49].*zlimits), sum([0.49, 0.51].*zlimits)];
end