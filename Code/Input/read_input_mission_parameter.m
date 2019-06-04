function [mission_parameters] = read_input_mission_parameter()
  
disp('Reading Mission Parameter Input File');
mission_parameters = xml2struct('Input/ESDC_Input.xml');
mission_parameters = typeset_struct(mission_parameters);
disp('Success');
disp(' ');
end
