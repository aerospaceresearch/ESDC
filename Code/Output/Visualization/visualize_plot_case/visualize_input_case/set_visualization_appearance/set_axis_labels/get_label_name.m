function name = get_label_name(plot_case, plot_dof)
  if plot_case.appearance.custom_display_names.(plot_dof).active
    name = plot_case.appearance.custom_display_names.(plot_dof).name;
  else
    % add code here
  end
end