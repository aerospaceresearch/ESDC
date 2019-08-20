function graphics_handles = visualize_lineage(plot_case, lineage)
  if strcmp(get_plot_case_type(plot_case), "3d")
    graphics_handles = visualize_lineage_3d(plot_case, lineage);
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    graphics_handles = visualize_lineage_2d(plot_case, lineage);
  end
end