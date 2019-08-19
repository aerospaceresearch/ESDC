function subsystems_names = get_subsystems_names(plot_case)
  if are_subsystems_bars_active(plot_case)
    subsystems_names = get_subsystems_fieldnames(plot_case);
  else
    subsystems_fieldnames = {};
  end
end