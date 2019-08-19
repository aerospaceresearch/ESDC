function plot_case = set_subsystems_line_colors(plot_case)
  colormap = plot_case.subsystems_bars.line_colors_colormap{1};
  num_colors = get_number_of_subsystems(plot_case);
  line_colors = eval(sprintf("%s(%d)", colormap, num_colors));
  plot_case.subsystems_bars.line_colors = line_colors;
end