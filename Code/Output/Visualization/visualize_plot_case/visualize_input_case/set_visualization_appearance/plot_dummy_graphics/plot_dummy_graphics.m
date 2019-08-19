function [] = plot_dummy_graphics(plot_case, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if strcmp(plot_dof, "line_type")
      line_color = "k";
      line_width = 0.5;
      for i = 1:numel(plot_case.(plot_dof).plot_values)
        line_type = plot_case.(plot_dof).plot_values{i};
        plot_dummy_line(plot_case, line_type, line_color, line_width)
      end
    elseif strcmp(plot_dof, "marker_type")
      marker_color = "k";
      for i = 1:numel(plot_case.(plot_dof).plot_values)
        marker_type = plot_case.(plot_dof).plot_values{i};
        plot_dummy_point(plot_case, marker_type, marker_color)
      end
    elseif strcmp(plot_dof, "line_color")
      colors = lines;
      line_type = "-";
      line_color = colors(2,:);
      line_width = 0.5;
      plot_dummy_line(plot_case, line_type, line_color, line_width);
    elseif strcmp(plot_dof, "marker_color")
      colors = lines;
      marker_type = "o";
      marker_color = colors(2,:);
      plot_dummy_point(plot_case, marker_type, marker_color)
    elseif strcmp(plot_dof, "subsystems_bars")
      %%%%%%
      line_type = get_subsystems_line_type(plot_case);
      line_colors = get_subsystems_line_colors(plot_case);
      line_width = get_subsystems_line_width(plot_case);
      num_subsystems = get_number_of_subsystems(plot_case);
      for n_subsystem = 1:num_subsystems
        line_color = line_colors(n_subsystem,:);
        plot_dummy_line(plot_case, line_type, line_color, line_width)
      end
    end
  end
end