function [] = set_plot_title(plot_case)
  if plot_case.appearance.title.active
    fontsize = plot_case.appearance.title.fontsize;
    title(plot_case.appearance.title.name, "fontsize", fontsize)
  end
end