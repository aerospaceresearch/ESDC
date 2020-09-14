function [DOF] = read_DOF()
% reads file the currently defines degrees of freedoms in different implemented systems

if exist("Database/model_DOF.xml")
  disp('Reading Degress of Freedom Input File');
  DOF_parameters = xml2struct('Database/model_DOF.xml');
  DOF = typeset_struct(DOF_parameters);
  disp('Success');
  disp(' ');
  fflush(stdout);
else
  disp('No Degress of Freedom Input File');
end

end
