function [] = visualization(evolution_data, input, db_data, config)
  
  visualization_startup();
  visualization_data = get_visualization_data('Input/visualization.xml');

  num_plot_cases = get_number_of_plot_cases(visualization_data);

  for n_plot_case = 1:num_plot_cases
  
    plot_case = get_plot_case(visualization_data, n_plot_case);
  
    if is_plot_case_active(plot_case)
      visualize_plot_case(evolution_data, input, plot_case, n_plot_case);
    end
  
  end
end