function output_XML_generation(input, db_data, config, evolution_data)
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
%disp('XML Output complete')
disp(' ')

end


function processed_data = output_XML_attributes(unprocessed_data);
%walk down data
%make if conditions for each available variable

%size(unprocessed_data{end})

  attr_definitions = xml2struct('Database/ESDC_variable_attributes.xml');
  attr_definitions = typeset_struct(attr_definitions);
  attr_definitions= attr_definitions.variable_attributes;

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

%  processed_data = attributeGenAbstractParameter(unprocessed_data);
end

function out = createAttributes(name, val, attr_definitions)
  if isstruct(val)
    [out.Attributes] = getAttributes(name, attr_definitions);
      
      fields= fieldnames(val);
      for k=1: size(fields,1)
        out.(fields{k,1}) = createAttributes(fields{k,1}, val.(fields{k,1}), attr_definitions); 
      end
    
    %out = val;
 
  else
        out = struct();
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
   % name= attributes.(var_name).name; 
   % unit= attributes.(var_name).unit; 
   % description = attributes.(var_name).description;
  else
    out_attributes.none="no attributes defined"; 
    %name= "undefined variable";
    %unit= "undefined unit";
    %description = "missing description";
  end
end

function out = attributeGenPhysicalParameter(name, param, unit, description)
  out = struct();
  out = param;
  out.Attributes.name=name;
  out.Attributes.unit=unit;
  out.Attributes.description=description;  
endfunction

function out = attributeGenAbstractParameter(in_struct)
  out = struct();
  out.Text = in_struct;
  out.Attributes.show="true";
  out.Attributes.version=num2str(now);

endfunction