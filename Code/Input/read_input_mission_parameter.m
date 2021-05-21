function [mission_parameters] = read_input_mission_parameter()
  if exist('Input/ESDC_Input.xml')
    disp('Reading Mission Parameter Input File');
    mission_parameters = xml2struct('Input/ESDC_Input.xml');
    mission_parameters = typeset_struct(mission_parameters);

    %This allows a singular entry to parse as a cell array with one entry instead of a struct, which causes downstream errors.
    if isstruct(mission_parameters.Satellite_parameters.input_case)
      structdata          = mission_parameters.Satellite_parameters.input_case;
      mission_parameters  = struct();
      mission_parameters.Satellite_parameters.input_case{1} = structdata;
    disp('Success');
    disp(' ');
    fflush(stdout);
    end
  else
    disp('ERROR: No input definition file')
  end
end
