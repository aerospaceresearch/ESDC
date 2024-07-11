%main function of the ESDC program. The tools allows for generic spacecraft design based on correlations and application of an evolutionary algorithm.
 %https://standards.nasa.gov/standard/gsfc/gsfc-std-1000 gold rules for margins and more
function [] =ESDC(runID)
if nargin < 1
  runID = 0;
end

clc

startTime = now;                               % Reference timer for performance evaluation: Start

try

% Path adding for relevant folders containing code
    folders = {'Code/Analysis', 'Code/Evolver', 'Code/Input', 'Code/Output', 'Code/Scaling', 'Code/Support'};
    for i = 1:length(folders)
        if exist(folders{i}, 'dir')
            addpath(folders{i});
        else
            warning(['Folder not found: ', folders{i}]);
        end
    end
add_paths_for_visualization();          % additional paths for the visulisation codes like video and animation creation
% Start
startup();                              % Display startup messages, licenses etc.
appendToLogFileDCEP('DCEP_STATUS: RUNNING_0%',1,runID)

%Update Scaling Data Base
force_db_update = 0 ;
update_scaling_model(force_db_update);                 % Checks for changes in the data bases and derives changed scaling laws

%Input
[input db_data config] = input_processing();   %Reads input files for the specific simulaton at hand

%Evolve
evolutionStartTime=now;                              % Reference timer for performance evaluation: After evoluation completion

evolution_data = evolver(input, db_data, config,runID); % Main solver performance here

evolution_time(evolutionStartTime);                % Calculate the time for the evolution process

%Output
output_XML_generation(input, db_data, config, evolution_data,runID);

%Visual Output
%disp('Visual production ')
%visualization(evolution_data, config);
%disp('Visual production complete')


%End
disp('ESDC complete')
eval_total_time(startTime, t_end=now)

appendToLogFileDCEP('DCEP_STATUS: FINISHED',0,runID)

catch exception
    % Handle the exception
    disp(['Error occurred: ' exception.message]);
    appendToLogFileDCEP('DCEP_STATUS: ERROR ', 0,runID);
    % Write the error message to the log file
    appendToLogFileDCEP(exception.message, 0,runID);

    % Re-throw the exception to terminate the program
    rethrow(exception);
end

endfunction

