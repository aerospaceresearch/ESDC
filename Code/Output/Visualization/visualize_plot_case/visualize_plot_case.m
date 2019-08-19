function [] = visualize_plot_case(evolution_data, input, plot_case, n_plot_case)
  disp(sprintf("Plot case: %d",n_plot_case));
  disp_plot_case(plot_case);
  disp(' ');

  input_cases = get_input_cases(plot_case);
  num_input_cases = numel(input_cases);
  
  disp(sprintf("Number of input cases: %d", num_input_cases));
  disp(sprintf("Input cases: %s", mat2str(input_cases)));
  disp(' ');
  
  for n_input_case = input_cases
    
    visualize_input_case(evolution_data, input, plot_case, n_plot_case, n_input_case);
      
  end
end