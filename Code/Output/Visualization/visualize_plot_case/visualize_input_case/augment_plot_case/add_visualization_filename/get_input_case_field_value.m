function value = get_input_case_field_value(input, n_input_case, field)
  value = input.Satellite_parameters.input_case{n_input_case}.(field);
end