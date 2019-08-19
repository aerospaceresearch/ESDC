function plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if strcmp(plot_dof,"x") || strcmp(plot_dof,"y") || strcmp(plot_dof,"z")
      plot_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
    elseif strcmp(plot_dof,"line_type") || strcmp(plot_dof,"marker_type")
      dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
      dof_values = plot_case.(plot_dof).dof_values;
      plot_values = plot_case.(plot_dof).plot_values;
      for i = 1:numel(dof_values)
        if strcmp(dof_value, dof_values{i})
          plot_value = plot_values{i};
          break;
        end
      end
    elseif strcmp(plot_dof,"line_color") || strcmp(plot_dof,"marker_color")
      dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
      plot_value = map_dof_value_to_color(plot_case, plot_dof, dof_value);
    end
  else
    plot_value = plot_case.(plot_dof).default_plot_value;
  end
end