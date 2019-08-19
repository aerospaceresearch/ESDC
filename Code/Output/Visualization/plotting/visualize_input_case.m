function [] = visualize_input_case(evolution_data, input, plot_case, n_plot_case, n_input_case)
  
  disp(sprintf("Starting plot case %d for input case %d", n_plot_case, n_input_case));
      
  fig = figure(1);
  clf (fig)
  hold on
  
  plot_case = set_visualization_lineages(evolution_data, plot_case, n_input_case);
  plot_case = add_min_max_values_for_continuous_dofs(plot_case, evolution_data, n_input_case);
  plot_case = set_subsystems_fieldnames(plot_case, evolution_data, n_input_case);
  plot_case = set_number_of_subsystems(plot_case);
  plot_case = set_subsystems_line_colors(plot_case);
  
  set_visualization_appearance(plot_case)
  
  if strcmp(get_plot_case_type(plot_case), "3d")
      
    lineages = get_visualization_lineages(plot_case);
      
    for n_lineage = lineages
        
      lineage = get_lineage(evolution_data, n_input_case, n_lineage);
      
      
      num_gens = numel(lineage);    
      
      if is_scatter_active(plot_case) && are_seed_points_active(plot_case)
        n_gen = 1;
        graphics_handles{n_lineage}{n_gen} = plot_seed_point_3d(plot_case, lineage, n_gen);
      end
      for n_gen = 2:num_gens
        if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
          graphics_handles{n_lineage}{n_gen} = plot_generation_3d(plot_case, lineage, n_gen);
        end
      end
        
    end
    
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    
    lineages = get_visualization_lineages(plot_case);
    for n_lineage = lineages
      lineage = get_lineage(evolution_data, n_input_case, n_lineage);
      num_gens = numel(lineage);
      
      if is_scatter_active(plot_case) && are_seed_points_active(plot_case)
        n_gen = 1;
        graphics_handles{n_lineage}{n_gen} = plot_seed_point_2d(plot_case, lineage, n_gen);
      end
      for n_gen = 2:num_gens
        if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
          graphics_handles{n_lineage}{n_gen} = plot_generation_2d(plot_case, lineage, n_gen);
        end
      end
    end
      
  end
  
  plot_case = set_visualization_filename(input, plot_case, n_plot_case, n_input_case);
  save_visualization(fig, plot_case);
  
  animate_and_save_visualization(plot_case, fig, graphics_handles);
  
end