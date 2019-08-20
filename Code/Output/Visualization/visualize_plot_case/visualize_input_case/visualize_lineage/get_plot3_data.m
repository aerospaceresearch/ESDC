function [x_plt3, y_plt3, z_plt3, line_type, line_color] = get_plot3_data(plot_case, lineage, n_gen)
  previous_gen = get_last_sucessful_gen(lineage, n_gen);
  x_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "x"), get_plot_value(plot_case, lineage, n_gen, "x")];
  y_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "y"), get_plot_value(plot_case, lineage, n_gen, "y")];
  z_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "z"), get_plot_value(plot_case, lineage, n_gen, "z")];
  line_type = get_plot_value(plot_case, lineage, n_gen, "line_type");
  line_color = get_plot_value(plot_case, lineage, n_gen, "line_color");
end