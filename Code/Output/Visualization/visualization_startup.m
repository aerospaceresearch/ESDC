function [] = visualization_startup()
  disp("Starting Visualization")
  disp(" ")
  disp("Author: Themistoklis Spanoudis")
  disp(" ")
  disp(" ")
  addpath("Code/Output/Visualization");
  addpath("Code/Output/Visualization/visualize_plot_case");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/animate_and_save_visualization");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_min_max_values_for_continuous_dofs");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_number_of_subsystems");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_subsystems_fieldnames");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_subsystems_line_colors");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_visualization_filename");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/augment_plot_case/add_visualization_lineages");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/save_visualization");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/plot_dummy_graphics");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/set_axis_labels");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/set_axis_limits");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/set_plot_legend");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/set_plot_title");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/set_visualization_appearance/set_viewing_angle");
  addpath("Code/Output/Visualization/visualize_plot_case/visualize_input_case/visualize_lineage");
end