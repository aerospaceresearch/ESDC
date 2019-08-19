function [] = disp_plot_case(plot_case)
  type = plot_case.type;
  disp(sprintf("Type: %s", get_plot_case_type(plot_case)));
  if strcmp(type, "3d")
    plot_dofs = {"x", "y", "z", "line_type", "line_color", "marker_type", "marker_color"};
  elseif strcmp(type, "2d")
    plot_dofs = {"y", "line_type", "line_color", "marker_type", "marker_color"};
  end
  for n_plot_dof = 1:numel(plot_dofs)
    disp(sprintf("%s: %s", plot_dofs{n_plot_dof}, get_dof_string(plot_case.(plot_dofs{n_plot_dof}).dof)))
  end
end