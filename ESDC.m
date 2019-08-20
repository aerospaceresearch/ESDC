function [  ] =ESDC()
t_0 = now;
addpath('Code/Analysis');
addpath('Code/Evolver');
addpath('Code/Input');
%addpath('Code/Modelling')
addpath('Code/Output');
addpath('Code/Scaling');
addpath('Code/Support');
add_paths_for_visualization();

clc;

startup();
fflush(stdout);

update_scaling_model();

[input db_data config] = input_processing();
t_1=now;

disp('Starting Evolution ...');
disp(' ');
fflush(stdout);

evolution_data = evolver(input, db_data, config);
t_2=now;

evolution_time(t_1,t_2)

%Create and Save Visualizations
visualization(evolution_data, input, db_data, config);

output_XML_generation(input, db_data, config, evolution_data);

disp('ESDC complete')
t_end = now;
disp(sprintf('Exiting program after total runtime of %d s.',(t_end-t_0)*60*60*24))
disp(' ')
end
