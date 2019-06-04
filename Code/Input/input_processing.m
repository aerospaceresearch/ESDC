function [mission_parameters database  simulation_parameters]= input_processing()
 %InputReading
    % Mission Parameters
    [mission_parameters] =  read_input_mission_parameter();
    
    % Database     % THIS WILL BE OBSOLETE SOON check by hash for diff-> update DB scaling model functions automatically
    [database] =  read_reference_data();
    database.DOF =  read_DOF();
    
    % Simulation Parameters
    [simulation_parameters] = read_input_simulation_parameter();
    
    
    disp(' ')
    disp('Input Reading complete')
    disp(' ')
end
