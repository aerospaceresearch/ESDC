function [] = save_visualization(fig, plot_case)
  if is_saving_visualization_active(plot_case, "image")
    formats = get_image_formats(plot_case);
    for i = 1:numel(formats)
      format = formats{i};
      filename = get_visualization_filename(plot_case);
      folder = "Output/";
      filename_with_path = strcat(folder, filename);
      saveas(fig, filename_with_path, format);
    end
  end
  if is_saving_visualization_active(plot_case, "octave_figure")
    format = "ofig";
    filename = get_visualization_filename(plot_case);
    folder = "Output/";
    filename_with_path = strcat(folder, filename);
    full_filename_with_path = strcat(filename_with_path, ".", format);
    hgsave(fig, full_filename_with_path);
  end
end