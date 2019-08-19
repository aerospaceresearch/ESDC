function plot_case = add_number_of_subsystems(plot_case)
  num_subsystems = numel(get_subsystems_fieldnames(plot_case));
  plot_case.subsystems_bars.num_subsystems = num_subsystems;
end