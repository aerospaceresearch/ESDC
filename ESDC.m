function [  ] =ESDC()
clc
addpath('Code/Analysis')
addpath('Code/Evolver')
addpath('Code/Input')
%addpath('Code/Modelling')
addpath('Code/Output')
addpath('Code/Scaling')
addpath('Code/Support')

startup();
fflush(stdout);

update_scaling_model();

[input db_data config] = input_processing();

disp('Starting Evolution ...');
disp(' ');
fflush(stdout);

t_1=now;
evolution_data = evolver(input, db_data, config);
t_2=now;

evolution_time(t_1,t_2)


% XML output
%data = makestruct(input, data);
%out.ESCD_output_data = data;

data_output(input, config, evolution_data);


disp('Writing XML Output ')
struct2xml(out,'Output/ESDC_output')

disp('XML Output complete')
disp(' ')
disp('ESDC complete')
disp(' ')
disp(' ')
end

