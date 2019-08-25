function plot_case = add_visualization_filename(input, plot_case, n_plot_case, n_input_case)
  if is_saving_visualization_active(plot_case, "image") || is_saving_visualization_active(plot_case, "octave_figure") || is_animate_and_save_active(plot_case)
    filename_substrings{1} = get_input_case_number_substring(plot_case, n_input_case);
    filename_substrings{2} = get_input_case_info_substring(input, plot_case, n_input_case);
    filename_substrings{3} = get_plot_case_number_substring(n_plot_case);
    for i = numel(filename_substrings):-1:1
      if strcmp(filename_substrings{i}, "")
        filename_substrings(i) = [];
      end
    end
    filename = strjoin(filename_substrings, "_");
    plot_case.save.filename.name = filename;
  end
end