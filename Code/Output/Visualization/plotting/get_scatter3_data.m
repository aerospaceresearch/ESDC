function [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen)
  x_sctr3 = get_plot_value(plot_case, lineage, n_gen, "x");
  y_sctr3 = get_plot_value(plot_case, lineage, n_gen, "y");
  z_sctr3 = get_plot_value(plot_case, lineage, n_gen, "z");
  marker_type = get_plot_value(plot_case, lineage, n_gen, "marker_type");
  marker_color = get_plot_value(plot_case, lineage, n_gen, "marker_color");
end