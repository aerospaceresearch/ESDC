function [] = set_visualization_appearance(plot_case)
  set_axis_limits(plot_case)
  set_plot_title(plot_case)
  set_axis_labels(plot_case)
  set_plot_legend(plot_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    set_viewing_angle(plot_case)
  end
end