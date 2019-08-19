function [] = hide_all_graphics(graphics_handles)
  num_lineages = numel(graphics_handles);
  for n_lineage = 1:num_lineages
    num_gens = numel(graphics_handles{n_lineage});
    for n_gen = 1:num_gens
      if ~isempty(graphics_handles{n_lineage}{n_gen})
        num_graphics = numel(graphics_handles{n_lineage}{n_gen});
        for n_graphic = 1:num_graphics
          graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
          hide_graphic(graphic_handle);
        end
      end
    end
  end
end