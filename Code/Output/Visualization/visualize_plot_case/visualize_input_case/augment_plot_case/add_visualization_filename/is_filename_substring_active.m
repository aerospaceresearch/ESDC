function bool = is_filename_substring_active(plot_case, substring_type)
  bool = plot_case.save.filename.(substring_type).active;
end