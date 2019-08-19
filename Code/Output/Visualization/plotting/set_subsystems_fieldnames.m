function plot_case = set_subsystems_fieldnames(plot_case, evolution_data, n_input_case)
  container_field = get_container_field(plot_case);
  n_gen = 1;
  n_lineage = 1;
  subsystems_fieldnames = fieldnames(evolution_data{n_gen}(n_input_case, n_lineage).(container_field));
  subsystems_fieldnames(end) = [];
  subsystems_fieldnames = subsystems_fieldnames';
  plot_case.subsystems_bars.subsystems_fieldnames = subsystems_fieldnames;
end