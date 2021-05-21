function output_XML_generation(input, db_data, config, evolution_data)
disp('XML production ')


%Pre-Processing data to lineages
output_struct=struct;

%Adding attributes and field descrptions
evolution_data = output_XML_attributes(evolution_data);

%output_struct.evolution_lineage_history = evolution_data_preprocessing(evolution_data);

% Producing full output
%if config.Simulation_parameters.output.xml.full_history
%   output_XML_full_history(output_struct);
%end

%Producing optimal output
if config.Simulation_parameters.output.xml.optimal_candidates
  output_XML_best_candidates(config, evolution_data);
end

%completing program
disp('XML Output complete')
disp(' ')

end


function processed_data = output_XML_attributes(unprocessed_data);

  attr_definitions = xml2struct('Database/ESDC_variable_attributes.xml');
  attr_definitions = typeset_struct(attr_definitions);
  attr_definitions = attr_definitions.variable_attributes;

for i=1:size(unprocessed_data{end},1)
   for j=1:size(unprocessed_data{end},2)
      %unprocessed_data{end}(i,j);
      fields= fieldnames(unprocessed_data{end}(i,j));
      for k=1: size(fields,1)
        
       % if not(strcmp(fields{k,1},"subsystem_masses")) && not(strcmp(fields{k,1},"mission_parameters")) && not(strcmp(fields{k,1},"mass_fractions"))
        unprocessed_data{end}(i,j).(fields{k,1}) = createAttributes(fields{k,1}, unprocessed_data{end}(i,j).(fields{k,1}),  attr_definitions); 
      %  end
 
      end
    end
end

processed_data =unprocessed_data;



%processed_data = attributeGenAbstractParameter(unprocessed_data);  % this is unused?
end

function out = createAttributes(name, val, attr_definitions)
  
  out = struct();
  if isstruct(val)

    [out.Attributes] = getAttributes(name, attr_definitions); % here name of variable 
      
      fields= fieldnames(val);
      for k=1: size(fields,1)
        out.(fields{k,1}) = createAttributes(fields{k,1}, val.(fields{k,1}), attr_definitions); 
      end

    %out = val;
 
  else
      if isnumeric(val)
      out.Text = num2str(val);
      else
      out.Text=val;
      end
     % [out.Attributes.name out.Attributes.unit out.Attributes.description] = getAttributes(name, attr_definitions);
      [out.Attributes] = getAttributes(name, attr_definitions);
 
  end
end

function [out_attributes] = getAttributes(var_name,attributes)
  
  fields = fieldnames(attributes);
  if any(strcmp(var_name,fields))
    
    attr_fields= fieldnames(attributes.(var_name));
    %disp(attributes.(var_name).(attr_fields{1}))
    for i=1:size(attr_fields,1)
      out_attributes.(attr_fields{i}) =attributes.(var_name).(attr_fields{i});
    end
  else
    out_attributes.none="no attributes defined"; 
  end
end

