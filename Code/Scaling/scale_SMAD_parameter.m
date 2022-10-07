function y = scale_SMAD_parameter(in, sc_type, param_a, param_b)
 sc_name= {"No Propulsion";"Low Earth";"High Earth";"Planetary"};
 filename=strcat("Database/Scaling/scaling_spacecraft_",char(sc_name{sc_type,1}),"_parameter_",param_a,"_to_",param_b,".csv");
  %disp(filename)
 if exist(filename)
  data = dlmread(filename,",");
  y = scaling_linear(in, data);
 else
  disp('File not found.');
  disp(filename);
 end
 
end