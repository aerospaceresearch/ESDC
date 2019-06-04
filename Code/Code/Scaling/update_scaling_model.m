function [scaling_model_struct] = update_scaling_model()
  disp('Database check:');
  if exist("Database/ESDC_Reference_Data_hash")
    
    hash_file = fopen('Database/ESDC_Reference_Data_hash', "r");
    hash_val = fgetl(hash_file);
    fclose(hash_file);
    current_hash = hash('md5', fileread('Database/ESDC_Reference_Data.xml'));
 
    if (hash_val == current_hash)
      disp('No updates to database detected.');
      else
      disp('Updates to database detected.');
        [data] = read_reference_data();                    % add output here
        hash_file= fopen('Database/ESDC_Reference_Data_hash', "w");
        fprintf(hash_file, hash('md5', fileread('Database/ESDC_Reference_Data.xml')));
        fclose(hash_file);
        update_generic_scaling_model(data);
        disp('Updates complete.');
      end
  else
    disp('No database hash file found');
    disp('Creating hash file');
    hash_file= fopen('Database/ESDC_Reference_Data_hash', "a");
    disp('Write hash');
    fprintf(hash_file, hash('md5', fileread('Database/ESDC_Reference_Data.xml')));
    fclose(hash_file);
  end
end


function [] = update_generic_scaling_model(data)

% EXTRACT data here
% generate data structure
% write generic scaling structure to XML
% make has of XML
  
end