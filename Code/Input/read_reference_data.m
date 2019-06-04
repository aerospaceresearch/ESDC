function [database]  = read_reference_data()
disp('Reading Reference Data Input File');
database = xml2struct('Database/ESDC_Reference_Data.xml');
database= typeset_struct(database);
disp('Success');
disp(' ');
end 
