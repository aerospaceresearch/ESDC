function [  ] =ESDC()
t_0 = now;
addpath('Code/Analysis');
addpath('Code/Evolver');
addpath('Code/Input');
%addpath('Code/Modelling')
addpath('Code/Output');
addpath('Code/Scaling');
addpath('Code/Support');

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

%Preprocessing Results
disp('Starting Output Preprocessing ...');
disp(' ');
t_3 = now;
output_struct.evolution_lineage_history = evolution_data_preprocessing(evolution_data);
t_4 = now;

disp(sprintf('Output Preprocessing complete after %d s.',(t_4-t_3)*60*60*24));
fflush(stdout);

%XML
disp('Writing XML Output ')
fflush(stdout);
struct2xml(output_struct, 'Output/ESDC_evolution_history')


%completing program
disp('XML Output complete')
disp(' ')
disp('ESDC complete')
t_end = now;
disp(sprintf('Exiting program after total runtime of %d s.',(t_end-t_0)*60*60*24))
disp(' ')
end



