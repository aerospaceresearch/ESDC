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
t_to_convergence = (t_2-t_1)*60*60*24;

disp(sprintf('Total time for evolver convergence: %d s', t_to_convergence ))



%disp('EP mass system scaling for reference points');
%disp(' ');
%data.reference = scale_EPsystem(input);
%for i=1:size(input,2)
%    disp(input(i).description);
%    disp(data.reference(i));
%end

% Simple analysis
%data.analysis.F_const = analysis_F_const(input, data, config);
%data.analysis.P_const = analysis_P_const(input, data, config);
%data.evolver_analysis = evolver_analysis(input, data, config);

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