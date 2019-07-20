
function [] = visualization(evolution_data, input, db_data, config)
  
  visualization_startup();
  visualization_data = get_visualization_data('Input/visualization.xml');

  num_plot_cases = get_number_of_plot_cases(visualization_data);

  for n_plot_case = 1:num_plot_cases
  
    plot_case = get_plot_case(visualization_data, n_plot_case);
  
    if is_plot_case_active(plot_case)
      visualize_plot_case(evolution_data, input, plot_case, n_plot_case);
    end
  
  end
end

function [] = visualize_plot_case(evolution_data, input, plot_case, n_plot_case)
  disp(sprintf("Plot case: %d",n_plot_case));
  disp_plot_case(plot_case);
  disp(' ');

  input_cases = get_input_cases(plot_case);
  num_input_cases = numel(input_cases);
  
  disp(sprintf("Number of input cases: %d", num_input_cases));
  disp(sprintf("Input cases: %s", mat2str(input_cases)));
  disp(' ');
  
  for n_input_case = input_cases
    
    visualize_input_case(evolution_data, input, plot_case, n_plot_case, n_input_case);
      
  end
end

function [] = visualize_input_case(evolution_data, input, plot_case, n_plot_case, n_input_case)
  
  disp(sprintf("Starting plot case %d for input case %d", n_plot_case, n_input_case));
      
  fig = figure(1);
  clf (fig)
  hold on
  
  plot_case = add_min_max_values_for_continuous_dofs(plot_case, evolution_data, n_input_case);
  set_visualization_appearance(plot_case)
  
  if strcmp(get_plot_case_type(plot_case), "3d")
      
    lineages = get_visualization_lineages(evolution_data, plot_case, n_input_case);
      
    for n_lineage = lineages
        
      lineage = get_lineage(evolution_data, n_input_case, n_lineage);
      
      
      num_gens = numel(lineage);    
      
      if is_scatter_active(plot_case) && are_seed_points_active(plot_case)
        n_gen = 1;
        graphics_handles{n_lineage}{n_gen} = plot_seed_point_3d(plot_case, lineage, n_gen);
      end
      for n_gen = 2:num_gens
        if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
          graphics_handles{n_lineage}{n_gen} = plot_generation_3d(plot_case, lineage, n_gen);
        end
      end
        
    end
    
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    
    lineages = get_visualization_lineages(evolution_data, plot_case, n_input_case);
    for n_lineage = lineages
      lineage = get_lineage(evolution_data, n_input_case, n_lineage);
      num_gens = numel(lineage);
      
      if is_scatter_active(plot_case) && are_seed_points_active(plot_case)
        n_gen = 1;
        graphics_handles{n_lineage}{n_gen} = plot_seed_point_2d(plot_case, lineage, n_gen);
      end
      for n_gen = 2:num_gens
        if is_mutation_successful(lineage, n_gen) || are_failed_mutations_active(plot_case)
          graphics_handles{n_lineage}{n_gen} = plot_generation_2d(plot_case, lineage, n_gen);
        end
      end
    end
      
  end
  
  plot_case = set_visualization_filename(input, plot_case, n_plot_case, n_input_case);
  save_visualization(fig, plot_case);
  
  animate_and_save_visualization(plot_case, fig, graphics_handles);
  
end

function num_gens = get_number_of_visualized_generations_per_lineage(graphics_handles)
  num_lineages = numel(graphics_handles);
  for n_lineage = 1:num_lineages
    num_gens(n_lineage) = numel(graphics_handles{n_lineage});
  end
end  

function [] = animate_and_save_visualization(plot_case, fig, graphics_handles)
  if is_animate_and_save_active(plot_case)
    hide_all_graphics(graphics_handles);
    filename = get_visualization_filename(plot_case);
    folder = "Output/";
    if strcmp(get_animation_order(plot_case), "by_lineage")
      filename_with_path = strcat(folder, filename, "_animation_by_lineage.gif");
      animate_and_save_visualization_by_lineage(plot_case, fig, graphics_handles, filename_with_path);
    elseif strcmp(get_animation_order(plot_case), "by_generation")
      filename_with_path = strcat(folder, filename, "_animation_by_generation.gif");
      animate_and_save_visualization_by_generation(plot_case, fig, graphics_handles, filename_with_path);
    end 
  end
end

function [] = animate_and_save_visualization_by_lineage(plot_case, fig, graphics_handles, filename_with_path)
  [fps, delay_time, num_gens, max_gens, num_lineages] = get_parameters_for_animation(plot_case, graphics_handles);
  initialize_animation_file(filename_with_path, fig, delay_time);
  for n_lineage = 1:num_lineages
    num_gens = numel(graphics_handles{n_lineage});
    for n_gen = 1:num_gens
      if ~isempty(graphics_handles{n_lineage}{n_gen})
        num_graphics = numel(graphics_handles{n_lineage}{n_gen});
        for n_graphic = 1:num_graphics
          graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
          show_graphic(graphic_handle);
        end
        add_frame_to_animation_file(filename_with_path, fig, delay_time);
      end
    end
  end
end

function [] = animate_and_save_visualization_by_generation(plot_case, fig, graphics_handles, filename_with_path)
  [fps, delay_time, num_gens, max_gens, num_lineages] = get_parameters_for_animation(plot_case, graphics_handles);
  initialize_animation_file(filename_with_path, fig, delay_time);
  for n_gen = 1:max_gens
    for n_lineage = 1:num_lineages
      try
        if ~isempty(graphics_handles{n_lineage}{n_gen})
          num_graphics = numel(graphics_handles{n_lineage}{n_gen});
          for n_graphic = 1:num_graphics
            graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
            show_graphic(graphic_handle);
          end
        end
      catch
        % nothing to add here, the use of try-catch is only to avoid out of bound errors
      end
    end
    add_frame_to_animation_file(filename_with_path, fig, delay_time);
  end 
end

function [fps, delay_time, num_gens, max_gens, num_lineages] = get_parameters_for_animation(plot_case, graphics_handles)
  fps = get_fps(plot_case);
  delay_time = 1/fps;
  num_gens = get_number_of_visualized_generations_per_lineage(graphics_handles);
  max_gens = max(num_gens);
  num_lineages = numel(graphics_handles);
end    

function [] = initialize_animation_file(filename, fig, delay_time)
  [A, map] = get_indexed_image(fig);
  %imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay_time,'Compression','lzw');
  imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',delay_time);
end

function [] = add_frame_to_animation_file(filename, fig, delay_time)
  [A, map] = get_indexed_image(fig);
  %imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay_time,'Compression','lzw');
  imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',delay_time);
end

function [A, map] = get_indexed_image(fig)
  frame = getframe(fig);
  im = frame2im(frame);
  [A, map] = rgb2ind(im);
end

function [] = hide_all_graphics(graphics_handles)
  num_lineages = numel(graphics_handles);
  for n_lineage = 1:num_lineages
    num_gens = numel(graphics_handles{n_lineage});
    for n_gen = 1:num_gens
      if ~isempty(graphics_handles{n_lineage}{n_gen})
        num_graphics = numel(graphics_handles{n_lineage}{n_gen});
        for n_graphic = 1:num_graphics
          graphic_handle = graphics_handles{n_lineage}{n_gen}{n_graphic};
          hide_graphic(graphic_handle);
        end
      end
    end
  end
end

function [] = hide_graphic(graphic_handle)
  set(graphic_handle, "visible", "off");
end

function [] = show_graphic(graphic_handle)
  set(graphic_handle, "visible", "on");
end

function animation_order = get_animation_order(plot_case)
  animation_order = plot_case.animate_and_save.animation_order;
end

function bool = is_animate_and_save_active(plot_case)
  bool = plot_case.animate_and_save.active;
end

function fps = get_fps(plot_case)
  fps = plot_case.animate_and_save.fps;
end

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

function bool = is_saving_visualization_active(plot_case, save_type)
  bool = plot_case.save.(save_type).active;
end

function formats = get_image_formats(plot_case)
  formats = plot_case.save.image.formats;
end

function filename = get_visualization_filename(plot_case)
  filename = plot_case.save.filename.name;
end

function plot_case = set_visualization_filename(input, plot_case, n_plot_case, n_input_case)
  if is_saving_visualization_active(plot_case, "image") || is_saving_visualization_active(plot_case, "octave_figure")
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
  
function string = get_input_case_number_substring(plot_case, n_input_case)
  string = "";
  if is_filename_substring_active(plot_case, "input_case_number") || ~is_filename_substring_active(plot_case, "input_case_info")
    string = sprintf("input_case_%d", n_input_case);
  end
end

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

function fields = get_filename_input_case_fields(plot_case)
  fields = plot_case.save.filename.input_case_info.fields;
end

function value = get_input_case_field_value(input, n_input_case, field)
  value = input.Satellite_parameters.input_case{n_input_case}.(field);
end

function string = get_plot_case_number_substring(n_plot_case)
  string = sprintf("plot_case_%d", n_plot_case);
end

function bool = is_filename_substring_active(plot_case, substring_type)
  bool = plot_case.save.filename.(substring_type).active;
end


function bool = are_seed_points_active(plot_case)
  bool = plot_case.seed_points.active;
end

function [] = set_viewing_angle(plot_case)
  view(plot_case.appearance.view)
end

function [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case)
  if plot_case.appearance.custom_limits.active
    xlimits = plot_case.appearance.custom_limits.xlim;
    ylimits = plot_case.appearance.custom_limits.ylim;
    zlimits = plot_case.appearance.custom_limits.zlim;
  else
    xlimits = [plot_case.x.min_value, plot_case.x.max_value];
    ylimits = [plot_case.y.min_value, plot_case.y.max_value];
    zlimits = [plot_case.z.min_value, plot_case.z.max_value];
  end
end

function [xlimits, ylimits, zlimits] = get_axes_limits_2d(plot_case)
  if plot_case.appearance.custom_limits.active
    xlimits = plot_case.appearance.custom_limits.xlim;
    ylimits = plot_case.appearance.custom_limits.ylim;
  else
    xlimits = [plot_case.x.min_value, plot_case.x.max_value];
    ylimits = [plot_case.y.min_value, plot_case.y.max_value];
  end
end

function [] = set_axis_limits(plot_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
    xlim(xlimits)
    ylim(ylimits)
    zlim(zlimits)
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xlimits, ylimits] = get_axes_limits_2d(plot_case);
    xlim(xlimits)
    ylim(ylimits)
  end
end

function [] = set_plot_title(plot_case)
  if plot_case.appearance.title.active
    fontsize = plot_case.appearance.title.fontsize;
    title(plot_case.appearance.title.name, "fontsize", fontsize)
  end
end

function [] = set_axis_labels(plot_case)
  if plot_case.appearance.labels.active
    fontsize = plot_case.appearance.labels.fontsize;
    
    name = get_label_name(plot_case, "x");
    xlabel(name, "fontsize", fontsize);
    
    name = get_label_name(plot_case, "y");
    ylabel(name, "fontsize", fontsize);
    
    if strcmp(get_plot_case_type(plot_case), "3d")
      name = get_label_name(plot_case, "z");
      zlabel(name, "fontsize", fontsize);
    end
  end
end

function bool = is_legend_active(plot_case)
  bool = plot_case.appearance.legend.active && ...
  ( is_plot_dof_active(plot_case, "line_type") || ...
  is_plot_dof_active(plot_case, "marker_type") || ...
  is_plot_dof_active(plot_case, "line_color") || ...
  is_plot_dof_active(plot_case, "marker_color") );
end

function [xdum, ydum, zdum] = get_dummy_line_3d(plot_case)
  [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
  xdum = [sum([0.51, 0.49].*xlimits), sum([0.49, 0.51].*xlimits)];
  ydum = [sum([0.51, 0.49].*ylimits), sum([0.49, 0.51].*ylimits)];
  zdum = [sum([0.51, 0.49].*zlimits), sum([0.49, 0.51].*zlimits)];
end

function [xdum, ydum] = get_dummy_line_2d(plot_case)
  [xlimits, ylimits] = get_axes_limits_2d(plot_case);
  xdum = [sum([0.51, 0.49].*xlimits), sum([0.49, 0.51].*xlimits)];
  ydum = [sum([0.51, 0.49].*ylimits), sum([0.49, 0.51].*ylimits)];
end

function [xdum, ydum, zdum] = get_dummy_point_3d(plot_case)
  [xlimits, ylimits, zlimits] = get_axes_limits_3d(plot_case);
  xdum = mean(xlimits);
  ydum = mean(ylimits);
  zdum = mean(zlimits);
end

function [xdum, ydum] = get_dummy_point_2d(plot_case)
  [xlimits, ylimits] = get_axes_limits_2d(plot_case);
  xdum = mean(xlimits);
  ydum = mean(ylimits);
end

function [] = plot_dummy_line(plot_case, line_type, line_color)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xdum, ydum, zdum] = get_dummy_line_3d(plot_case);
    obj = plot3(xdum, ydum, zdum, "linestyle", line_type, "color", line_color);
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xdum, ydum] = get_dummy_line_2d(plot_case);
    obj = plot(xdum, ydum, "linestyle", line_type, "color", line_color);
  end
  set(obj, "visible", "off");
end

function [] = plot_dummy_point(plot_case, marker_type, marker_color)
  if strcmp(get_plot_case_type(plot_case), "3d")
    [xdum, ydum, zdum] = get_dummy_point_3d(plot_case);
    obj = scatter3(xdum, ydum, zdum, "marker", marker_type, "markeredgecolor", marker_color);
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    [xdum, ydum] = get_dummy_point_2d(plot_case);
    obj = scatter(xdum, ydum, "marker", marker_type, "markeredgecolor", marker_color);
  end 
  set(obj, "visible", "off");
end

function [] = plot_dummy_graphics(plot_case, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if strcmp(plot_dof, "line_type")
      line_color = "k";
      for i = 1:numel(plot_case.(plot_dof).plot_values)
        line_type = plot_case.(plot_dof).plot_values{i};
        plot_dummy_line(plot_case, line_type, line_color)
      end
    elseif strcmp(plot_dof, "marker_type")
      marker_color = "k";
      for i = 1:numel(plot_case.(plot_dof).plot_values)
        marker_type = plot_case.(plot_dof).plot_values{i};
        plot_dummy_point(plot_case, marker_type, marker_color)
      end
    elseif strcmp(plot_dof, "line_color")
      colors = lines;
      line_type = "-";
      line_color = colors(2,:);
      plot_dummy_line(plot_case, line_type, line_color);
    elseif strcmp(plot_dof, "marker_color")
      colors = lines;
      marker_type = "o";
      marker_color = colors(2,:);
      plot_dummy_point(plot_case, marker_type, marker_color)
    end
  end
end

function dof_names = get_dof_names(plot_case, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if plot_case.appearance.custom_display_names.(plot_dof).active
      dof_names = plot_case.appearance.custom_display_names.(plot_dof).name;
    else
      dof_names = pot_case.(plot_dof).dof_values;
    end
  else
    dof_names = {};
  end
end

function legend_names = get_legend_names(plot_case)
  line_type_names = get_dof_names(plot_case, "line_type");
  line_color_names = get_dof_names(plot_case, "line_color");
  marker_type_names = get_dof_names(plot_case, "marker_type");
  marker_color_names = get_dof_names(plot_case, "marker_color");
  legend_names = [line_type_names, marker_type_names, line_color_names, marker_color_names];
end

function [] = set_plot_legend(plot_case)
  if is_legend_active(plot_case)
    plot_dummy_graphics(plot_case, "line_type")
    plot_dummy_graphics(plot_case, "marker_type")
    plot_dummy_graphics(plot_case, "line_color")
    plot_dummy_graphics(plot_case, "marker_color")
    legend_names = get_legend_names(plot_case);
    legend(legend_names)
  end
end

function [] = set_visualization_appearance(plot_case)
  set_axis_limits(plot_case)
  set_plot_title(plot_case)
  set_axis_labels(plot_case)
  set_plot_legend(plot_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    set_viewing_angle(plot_case)
  end
end


function name = get_label_name(plot_case, plot_dof)
  if plot_case.appearance.custom_display_names.(plot_dof).active
    name = plot_case.appearance.custom_display_names.(plot_dof).name;
  else
    % add code here
  end
end

    
    
function lineages = get_visualization_lineages(evolution_data, plot_case, n_input_case)
  dof = get_sorting_dof(plot_case);  
  dof_values = get_all_dof_values(evolution_data, n_input_case, dof);
  
  if strcmp(plot_case.lineages.sorting_direction,"increasing")
    lineages_values = min(dof_values);
    sorting_column = 2;
  elseif strcmp(plot_case.lineages.sorting_direction,"decreasing")
    lineages_values = max(dof_values);
    sorting_column = -2;
  end
  
  lineages_indexes = 1:get_number_of_lineages(evolution_data, n_input_case);
  sorted_indexes_values = sortrows([lineages_indexes', lineages_values'], sorting_column);
  
  sorted_indexes = sorted_indexes_values(:,1)';
  lineages = eval(sprintf("sorted_indexes(%s)", get_lineages_indexes(plot_case))); 
end

function sorting_dof = get_sorting_dof(plot_case)
  sorting_dof = plot_case.lineages.sorting_dof;
end

function sorting_direction = get_sorting_direction(plot_case)
  sorting_direction = plot_case.lineages.sorting_direction;
end

function indexes = get_lineages_indexes(plot_case)
  indexes = plot_case.lineages.indexes{1};
end

function plot_case = add_min_max_values_for_continuous_dofs(plot_case, evolution_data, n_input_case)
  if strcmp(get_plot_case_type(plot_case), "3d")
    potentially_continuous_plot_dofs = {"x", "y", "z", "line_color", "marker_color"};
  elseif strcmp(get_plot_case_type(plot_case), "2d")
    plot_case = add_max_number_of_generations(plot_case, evolution_data, n_input_case);
    potentially_continuous_plot_dofs = {"y", "line_color", "marker_color"};
  end
  for i = 1:numel(potentially_continuous_plot_dofs)
    potentially_continuous_plot_dof = potentially_continuous_plot_dofs{i};
    if is_plot_dof_active(plot_case, potentially_continuous_plot_dof)
      if is_plot_dof_continuous(plot_case, potentially_continuous_plot_dof)
        continuous_plot_dof = potentially_continuous_plot_dof;
        dof = plot_case.(continuous_plot_dof).dof;
        [min_value, max_value] = get_min_max_dof_value(evolution_data, n_input_case, dof);
        plot_case.(potentially_continuous_plot_dof).min_value = min_value;
        plot_case.(potentially_continuous_plot_dof).max_value = max_value;
      end
    end
  end      
end

function plot_case = add_max_number_of_generations(plot_case, evolution_data, n_input_case)
  num_gens = get_number_of_generations_per_lineage(evolution_data, n_input_case);
  min_gens = 1;
  max_gens = max(num_gens);
  plot_case.("x").min_value = min_gens;
  plot_case.("x").max_value = max_gens;
end

function num_gens = get_number_of_generations_per_lineage(evolution_data, n_input_case)
  num_lineages = get_number_of_lineages(evolution_data, n_input_case);
  for n_lineage = 1:num_lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    num_gens(n_lineage) = numel(lineage);
  end
end

function bool = is_plot_dof_continuous(plot_case, plot_dof)
  bool = strcmp(plot_case.(plot_dof).type, "continuous");
end

function bool = is_plot_dof_active(plot_case, plot_dof)
  bool = plot_case.(plot_dof).active;
end

function [min_value, max_value] = get_min_max_dof_value(evolution_data, n_input_case, dof)
  dof_values = get_all_dof_values(evolution_data, n_input_case, dof);
  min_value = min(min(dof_values));
  max_value = max(max(dof_values));
end

function dof_values = get_all_dof_values(evolution_data, n_input_case, dof)
  num_lineages = get_number_of_lineages(evolution_data, n_input_case);
  for n_lineage = 1:num_lineages
    lineage = get_lineage(evolution_data, n_input_case, n_lineage);
    num_gens = numel(lineage);
    for n_gen = 1:num_gens
      dof_values(n_gen, n_lineage) = get_dof_value(lineage, n_gen, dof);
    end
  end
end

function [] = visualization_startup()
  disp("Starting Visualization")
  disp(" ")
  disp("Author: Themistoklis Spanoudis")
  disp(" ")
  disp(" ")
end

function num_plot_cases = get_number_of_plot_cases(visualization_data)
  num_plot_cases = numel(visualization_data.plots.plot_case);
end

function plot_case = get_plot_case(visualization_data, n_plot_case)
  plot_case = visualization_data.plots.plot_case{n_plot_case};
end

function bool = is_plot_case_active(plot_case)
  bool = plot_case.active;
end

function visualization_data = get_visualization_data(file)
  visualization_parameters = xml2struct(file);
  visualization_data = typeset_struct(visualization_parameters);
end

function input_cases = get_input_cases(plot_case)
  input_cases = plot_case.input_cases;
end

function dof_string = get_dof_string(dof)
  dof_string = strjoin(dof, ".");
end

function type = get_plot_case_type(plot_case)
  type = plot_case.type;
end

function [] = disp_plot_case(plot_case)
  type = plot_case.type;
  disp(sprintf("Type: %s", get_plot_case_type(plot_case)));
  if strcmp(type, "3d")
    plot_dofs = {"x", "y", "z", "line_type", "line_color", "marker_type", "marker_color"};
  elseif strcmp(type, "2d")
    plot_dofs = {"y", "line_type", "line_color", "marker_type", "marker_color"};
  end
  for n_plot_dof = 1:numel(plot_dofs)
    disp(sprintf("%s: %s", plot_dofs{n_plot_dof}, get_dof_string(plot_case.(plot_dofs{n_plot_dof}).dof)))
  end
end

function bool = is_scatter_active(plot_case)
  bool = is_plot_dof_active(plot_case, "marker_type") || is_plot_dof_active(plot_case, "marker_color");
end

function num_lineages = get_number_of_lineages(evolution_data, n_input_case)
  num_lineages = size(evolution_data(1){},2);
end

function [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen)
  x_sctr3 = get_plot_value(plot_case, lineage, n_gen, "x");
  y_sctr3 = get_plot_value(plot_case, lineage, n_gen, "y");
  z_sctr3 = get_plot_value(plot_case, lineage, n_gen, "z");
  marker_type = get_plot_value(plot_case, lineage, n_gen, "marker_type");
  marker_color = get_plot_value(plot_case, lineage, n_gen, "marker_color");
end

function [x_plt3, y_plt3, z_plt3, line_type, line_color] = get_plot3_data(plot_case, lineage, n_gen)
  previous_gen = get_last_sucessful_gen(lineage, n_gen);
  x_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "x"), get_plot_value(plot_case, lineage, n_gen, "x")];
  y_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "y"), get_plot_value(plot_case, lineage, n_gen, "y")];
  z_plt3 = [get_plot_value(plot_case, lineage, previous_gen, "z"), get_plot_value(plot_case, lineage, n_gen, "z")];
  line_type = get_plot_value(plot_case, lineage, n_gen, "line_type");
  line_color = get_plot_value(plot_case, lineage, n_gen, "line_color");
end

function n_last_sucessful_gen = get_last_sucessful_gen(lineage, n_gen)
  candidate_last_sucessful_gen = n_gen - 1;
  while ~is_mutation_successful(lineage, candidate_last_sucessful_gen)
    candidate_last_sucessful_gen = candidate_last_sucessful_gen - 1;
  end
  n_last_sucessful_gen = candidate_last_sucessful_gen;
end

function bool = are_failed_mutations_active(plot_case)
  bool = plot_case.failed_mutations.active;
end

function bool = is_mutation_successful(lineage, n_gen)
  bool = lineage{n_gen}.evolution_success;
end

function dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof)
  dof = plot_case.(plot_dof).dof;
  dof_value = lineage{n_gen};
  for i = 1:numel(dof)
    dof_value = dof_value.(dof{i});
  end  
end

function dof_value = get_dof_value(lineage, n_gen, dof)
  dof_value = lineage{n_gen};
  for i = 1:numel(dof)
    dof_value = dof_value.(dof{i});
  end  
end

function plot_value = get_plot_value(plot_case, lineage, n_gen, plot_dof)
  if is_mutation_successful(lineage, n_gen)
    plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
  else
    plot_value = get_plot_value_failed_mutation(plot_case, lineage, n_gen, plot_dof);
  end
end

function plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof)
  if is_plot_dof_active(plot_case, plot_dof)
    if strcmp(plot_dof,"x") || strcmp(plot_dof,"y") || strcmp(plot_dof,"z")
      plot_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
    elseif strcmp(plot_dof,"line_type") || strcmp(plot_dof,"marker_type")
      dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
      dof_values = plot_case.(plot_dof).dof_values;
      plot_values = plot_case.(plot_dof).plot_values;
      for i = 1:numel(dof_values)
        if strcmp(dof_value, dof_values{i})
          plot_value = plot_values{i};
          break;
        end
      end
    elseif strcmp(plot_dof,"line_color") || strcmp(plot_dof,"marker_color")
      dof_value = get_corresponding_dof_value(plot_case, lineage, n_gen, plot_dof);
      plot_value = map_dof_value_to_color(plot_case, plot_dof, dof_value);
    end
  else
    plot_value = plot_case.(plot_dof).default_plot_value;
  end
end

function plot_value = get_plot_value_failed_mutation(plot_case, lineage, n_gen, plot_dof)
  if strcmp(plot_dof,"x") || strcmp(plot_dof,"y") || strcmp(plot_dof,"z")
    plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
  elseif strcmp(plot_dof,"line_type") || strcmp(plot_dof,"line_color") || strcmp(plot_dof,"marker_type") || strcmp(plot_dof,"marker_color")
    if use_custom_plot_values_for_failed_mutations(plot_case, plot_dof)
      plot_value = plot_case.failed_mutations.custom_plot_values.(plot_dof).custom_plot_value;
    else
      plot_value = get_plot_value_successful_mutation(plot_case, lineage, n_gen, plot_dof);
    end
  end
end

function bool = use_custom_plot_values_for_failed_mutations(plot_case, plot_dof)
  bool = plot_case.failed_mutations.custom_plot_values.(plot_dof).active;
end

function color = map_dof_value_to_color(plot_case, plot_dof, dof_value)
  colormap = plot_case.(plot_dof).plot_values{1};
  num_colors = 64;
  colors = eval(sprintf("%s(%d)", colormap, num_colors));
  min_value = plot_case.(plot_dof).min_value;
  max_value = plot_case.(plot_dof).max_value;
  color_idx = 1 + round((num_colors - 1)*(min_value + dof_value)/(min_value + max_value));
  color = colors(color_idx,:);
end

function graphics_handles_seed_point = plot_seed_point_3d(plot_case, lineage, n_gen)
  [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
  sizedata = plot_case.seed_points.sizedata;
  graphics_handles_seed_point{1} = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
end

function graphics_handles_seed_point = plot_seed_point_2d(plot_case, lineage, n_gen)
  [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen);
  sizedata = plot_case.seed_points.sizedata;
  graphics_handles_seed_point{1} = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color,"sizedata",sizedata);
end

function graphics_handles_n_gen = plot_generation_3d(plot_case, lineage, n_gen)  
  [x_plt3, y_plt3, z_plt3, line_type, line_color] = get_plot3_data(plot_case, lineage, n_gen);
  graphics_handles_n_gen{1} = plot3(x_plt3, y_plt3, z_plt3, "linestyle", line_type, "color", line_color);
  if is_scatter_active(plot_case)
    [x_sctr3, y_sctr3, z_sctr3, marker_type, marker_color] = get_scatter3_data(plot_case, lineage, n_gen);
    graphics_handles_n_gen{2} = scatter3(x_sctr3, y_sctr3, z_sctr3, "marker", marker_type, "markeredgecolor", marker_color);
  end
end



function graphics_handles_n_gen = plot_generation_2d(plot_case, lineage, n_gen)
  [x_plt, y_plt, line_type, line_color] = get_plot_data(plot_case, lineage, n_gen);
  graphics_handles_n_gen{1} = plot(x_plt, y_plt, "linestyle", line_type, "color", line_color);
  if is_scatter_active(plot_case)
    [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen);
    graphics_handles_n_gen{2} = scatter(x_sctr, y_sctr, "marker", marker_type, "markeredgecolor", marker_color);
  end
end

function [x_sctr, y_sctr, marker_type, marker_color] = get_scatter_data(plot_case, lineage, n_gen)
  x_sctr = n_gen;
  y_sctr = get_plot_value(plot_case, lineage, n_gen, "y");
  marker_type = get_plot_value(plot_case, lineage, n_gen, "marker_type");
  marker_color = get_plot_value(plot_case, lineage, n_gen, "marker_color");
end

function [x_plt, y_plt, line_type, line_color] = get_plot_data(plot_case, lineage, n_gen)
  previous_gen = get_last_sucessful_gen(lineage, n_gen);
  x_plt = [previous_gen, n_gen];
  y_plt = [get_plot_value(plot_case, lineage, previous_gen, "y"), get_plot_value(plot_case, lineage, n_gen, "y")];
  line_type = get_plot_value(plot_case, lineage, n_gen, "line_type");
  line_color = get_plot_value(plot_case, lineage, n_gen, "line_color");
end