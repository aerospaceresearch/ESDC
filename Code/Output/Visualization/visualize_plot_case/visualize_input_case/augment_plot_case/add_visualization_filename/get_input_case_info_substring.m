function string = get_input_case_info_substring(input, plot_case, n_input_case)
  string = "";
  if is_filename_substring_active(plot_case, "input_case_info")
    fields = get_filename_input_case_fields(plot_case);
    num_fields = numel(fields);
    for i = 1:num_fields
      field = fields{i};
      value = get_input_case_field_value(input, n_input_case, field);
      values{i} = num2str(round(value));
    end
    fields_values(1:2:2*num_fields) = fields;
    fields_values(2:2:2*num_fields) = values;
    string = strjoin(fields_values, "_");
  end
end