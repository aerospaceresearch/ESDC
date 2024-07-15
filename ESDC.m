% ESDC: Evolutionary Spacecraft Design Code
% 
% This function serves as the main entry point for the ESDC program. It facilitates
% the generic design of spacecraft using correlations and applies evolutionary optimization
%
% Parameters:
%   runID (optional): Identifier for the current run of the program. If not provided, defaults to 0.
%
% Functionality:
%   1. Initializes the environment and adds necessary paths for the relevant folders.
%   2. Starts the program and logs the initial status.
%   3. Updates the scaling database if needed.
%   4. Processes the input files for the current simulation.
%   5. Executes the evolutionary algorithm to solve the design problem.
%   6. Generates the output in XML format.
%   7. Logs the completion status and total execution time.
%   8. Handles any exceptions, logs error messages, and terminates the program if an error occurs.
%
% Usage:
%   ESDC(runID)
%
% Example:
%   ESDC(1)  % Runs the ESDC program with runID set to 1
%   ESDC()   % Runs the ESDC program with the default runID (0)

function ESDC(runID)
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
force_db_update = 0 ;                                  % Set this for debugging and data base scaling law tests
update_scaling_model(force_db_update);                 % Checks for changes in the data bases and derives changed scaling laws

%Input
[input db_data config] = input_processing();   %Reads input files for the specific simulaton at hand

%Evolve
evolutionStartTime=now;                              % Reference timer for performance evaluation: After evoluation completion

evolution_data = evolver(input, db_data, config,runID); % Main solver performance here

evolution_time(evolutionStartTime);                % Calculate the time for the evolution process

%Output
output_XML_generation(input, db_data, config, evolution_data,runID);

%Visual Output   - old code needs revision and adaption
%disp('Visual production ')
%visualization(evolution_data, config);
%disp('Visual production complete')


%End
disp('ESDC complete')
completionTime=now;
eval_total_time(startTime, completionTime)

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

