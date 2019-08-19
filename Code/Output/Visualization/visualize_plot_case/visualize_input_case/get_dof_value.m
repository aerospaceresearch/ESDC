function dof_value = get_dof_value(lineage, n_gen, dof)
  dof_value = lineage{n_gen};
  for i = 1:numel(dof)
    dof_value = dof_value.(dof{i});
  end  
end