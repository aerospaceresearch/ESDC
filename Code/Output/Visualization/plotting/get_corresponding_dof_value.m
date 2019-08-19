function dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof)
  dof = plot_case.(plot_dof).dof;
  dof_value = lineage{n_gen};
  for i = 1:numel(dof)
    dof_value = dof_value.(dof{i});
  end  
end