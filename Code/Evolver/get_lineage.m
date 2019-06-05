function lineage = get_lineage(generation_data, n_case, n_individual)
  %produces a lineage from generation data for the lineage of individual n for a input case
  lineage = {};
  for i=1:size(generation_data,2)
    lineage{end+1} = generation_data{i}(n_case, n_individual);
  end
end