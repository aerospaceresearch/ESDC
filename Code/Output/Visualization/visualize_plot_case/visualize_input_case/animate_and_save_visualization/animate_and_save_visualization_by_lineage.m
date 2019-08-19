function [] = animate_and_save_visualization_by_lineage(plot_case, fig, graphics_handles, filename_with_path)
  num_lineages = numel(graphics_handles);
  num_gens = get_number_of_visualized_generations_per_lineage(graphics_handles);
  initialize_animation_file(filename_with_path, fig, plot_case);
  for n_lineage = 1:num_lineages
    for n_gen = 1:num_gens(n_lineage)
      if ~isempty(graphics_handles{n_lineage}{n_gen})
        num_graphics = numel(graphics_handles{n_lineage}{n_gen});
        for n_graphic = 1:num_graphics
          graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
          show_graphic(graphic_handle);
        end
        add_frame_to_animation_file(filename_with_path, fig, plot_case);
      end
    end
  end
end