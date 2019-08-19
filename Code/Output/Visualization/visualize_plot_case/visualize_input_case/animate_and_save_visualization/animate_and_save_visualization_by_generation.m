function [] = animate_and_save_visualization_by_generation(plot_case, fig, graphics_handles, filename_with_path)
  num_lineages = numel(graphics_handles);
  max_gens = get_max_visualized_generations(graphics_handles);
  initialize_animation_file(filename_with_path, fig, plot_case);
  for n_gen = 1:max_gens
    for n_lineage = 1:num_lineages
      try
        if ~isempty(graphics_handles{n_lineage}{n_gen})
          num_graphics = numel(graphics_handles{n_lineage}{n_gen});
          for n_graphic = 1:num_graphics
            graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
            show_graphic(graphic_handle);
          end
        end
      catch
        % nothing to add here, the use of try-catch is only to avoid out of bound errors
      end
    end
    add_frame_to_animation_file(filename_with_path, fig, plot_case);
  end 
end