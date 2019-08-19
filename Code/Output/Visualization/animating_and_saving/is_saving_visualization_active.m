function bool = is_saving_visualization_active(plot_case, save_type)
  bool = plot_case.save.(save_type).active;
end