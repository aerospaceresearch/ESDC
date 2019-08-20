function string = get_input_case_number_substring(plot_case, n_input_case)
  string = "";
  if is_filename_substring_active(plot_case, "input_case_number") || ~is_filename_substring_active(plot_case, "input_case_info")
    string = sprintf("input_case_%d", n_input_case);
  end
end