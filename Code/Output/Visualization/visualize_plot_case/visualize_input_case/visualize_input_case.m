function [] = visualize_input_case(evolution_data, input, plot_case, n_plot_case, n_input_case)
  
  disp(sprintf("Starting plot case %d for input case %d", n_plot_case, n_input_case));
      
  fig = figure(1);
  clf (fig)
  hold on
  
  plot_case = augment_plot_case(evolution_data, input, plot_case, n_plot_case, n_input_case);
  set_visualization_appearance(plot_case);
  
  lineages = get_visualization_lineages(plot_case);  
  for n_lineage = lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    graphics_handles{n_lineage} = visualize_lineage(plot_case, lineage); 
  end
  
  save_visualization(fig, plot_case);
  animate_and_save_visualization(plot_case, fig, graphics_handles);
end