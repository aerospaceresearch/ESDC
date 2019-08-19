function visualization_data = get_visualization_data(file)
  visualization_parameters = xml2struct(file);
  visualization_data = typeset_struct(visualization_parameters);
end