function plot_case = augment_plot_case(evolution_data, input, plot_case, n_plot_case, n_input_case)
  plot_case = add_visualization_lineages(evolution_data, plot_case, n_input_case);
  plot_case = add_min_max_values_for_continuous_dofs(plot_case, evolution_data, n_input_case);
  plot_case = add_subsystems_fieldnames(plot_case, evolution_data, n_input_case);
  plot_case = add_number_of_subsystems(plot_case);
  plot_case = add_subsystems_line_colors(plot_case);
  plot_case = add_visualization_filename(input, plot_case, n_plot_case, n_input_case);
end