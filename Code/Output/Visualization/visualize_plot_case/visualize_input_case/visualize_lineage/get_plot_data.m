function [x_plt, y_plt, line_type, line_color] = get_plot_data(plot_case, lineage, n_gen)
  previous_gen = get_last_sucessful_gen(lineage, n_gen);
  x_plt = [previous_gen, n_gen];
  y_plt = [get_plot_value(plot_case, lineage, previous_gen, "y"), get_plot_value(plot_case, lineage, n_gen, "y")];
  line_type = get_plot_value(plot_case, lineage, n_gen, "line_type");
  line_color = get_plot_value(plot_case, lineage, n_gen, "line_color");
end