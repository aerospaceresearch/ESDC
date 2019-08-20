function color = map_dof_value_to_color(plot_case, plot_dof, dof_value)
  colormap = plot_case.(plot_dof).plot_values{1};
  num_colors = 64;
  colors = eval(sprintf("%s(%d)", colormap, num_colors));
  min_value = plot_case.(plot_dof).min_value;
  max_value = plot_case.(plot_dof).max_value;
  color_idx = 1 + round((num_colors - 1)*(min_value + dof_value)/(min_value + max_value));
  color = colors(color_idx,:);
end