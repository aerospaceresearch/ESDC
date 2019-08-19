function [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen)
  x_sctr = n_gen;
  y_sctr = get_plot_value(plot_case, lineage, n_gen, "y");
  marker_type = get_plot_value(plot_case, lineage, n_gen, "marker_type");
  marker_color = get_plot_value(plot_case, lineage, n_gen, "marker_color");
end