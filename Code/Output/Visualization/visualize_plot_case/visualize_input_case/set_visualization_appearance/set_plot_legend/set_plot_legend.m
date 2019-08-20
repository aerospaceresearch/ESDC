function [] = set_plot_legend(plot_case)
  if is_legend_active(plot_case)
    plot_dummy_graphics(plot_case, "line_type")
    plot_dummy_graphics(plot_case, "marker_type")
    plot_dummy_graphics(plot_case, "line_color")
    plot_dummy_graphics(plot_case, "marker_color")
    plot_dummy_graphics(plot_case, "subsystems_bars")
    legend_names = get_legend_names(plot_case);
    legend(legend_names)
  end
end