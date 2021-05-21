function [spacecraft_parameters ] = read_reference_spacecraft_data()
  
if exist("Database/ESDC_Reference_Data_Spacecrafts.xml")
  disp('Reading Spacecraft Reference Database');
  spacecraft_parameters = xml2struct('Database/ESDC_Reference_Data_Spacecrafts.xml');
  spacecraft_parameters = typeset_struct(spacecraft_parameters);

  %This allows a singular entry to parse as a cell array with one entry instead of a struct, which causes downstream errors.
  if isstruct(spacecraft_parameters.reference_data_spracecraft)
    structdata = spacecraft_parameters.reference_data_spracecraft;
    spacecraft_parameters=struct();
    spacecraft_parameters.reference_data_spracecraft{1} = structdata;
  end


  disp('Success');
  disp(' ');
  fflush(stdout);

else 
  disp('ERROR: No spacecraft rerference data found')
end

end
