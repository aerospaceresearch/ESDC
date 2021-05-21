function [simulation_parameters] = read_input_simulation_parameter()
  if exist('Input/ESDC_Simulation_parameters.xml')
   disp('Reading Simulation Parameter Input File')
   simulation_parameters = xml2struct('Input/ESDC_Simulation_parameters.xml');
   simulation_parameters = typeset_struct(simulation_parameters);
   disp('Success');
   disp(' ');
   fflush(stdout);
  else
   disp('ERROR: No Simulation Parameter Input File')
  end
end

