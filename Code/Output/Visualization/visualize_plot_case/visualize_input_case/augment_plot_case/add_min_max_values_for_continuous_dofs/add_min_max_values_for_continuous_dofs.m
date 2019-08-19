function plot_case = add_min_max_values_for_continuous_dofs(plot_case, evolution_data, n_input_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    potentially_continuous_plot_dofs = {"x", "y", "z", "line_color", "marker_color"};
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    plot_case = add_max_number_of_generations(plot_case, evolution_data, n_input_case);
    potentially_continuous_plot_dofs = {"y", "line_color", "marker_color"};
  end
  for i = 1:numel(potentially_continuous_plot_dofs)
    potentially_continuous_plot_dof = potentially_continuous_plot_dofs{i};
    if is_plot_dof_active(plot_case, potentially_continuous_plot_dof)
      if is_plot_dof_continuous(plot_case, potentially_continuous_plot_dof)
        continuous_plot_dof = potentially_continuous_plot_dof;
        dof = plot_case.(continuous_plot_dof).dof;
        [min_value, max_value] = get_visualization_min_max_dof_value(plot_case, evolution_data, n_input_case, dof);
        plot_case.(continuous_plot_dof).min_value = min_value;
        plot_case.(continuous_plot_dof).max_value = max_value;
      end
    end
  end      
end