%Produces mass fractions of the given data
%TODO: Make more generic, by using a second argument that defines reference mass to be considered

function [mass_fractions] = mass_fractions(data)                                        %Returns a structure containing fields of mass fractions
  m_ref                                     = data.mass;                                % Definition reference mass
  mass_fractions                            = struct();                                 % Initialize structure for fractions
  
  names                                     = fieldnames(data.subsystem_masses);        % Short cut fieldnames
  for i=1:numel(names)                                                                  % Loop over all fields
    mass_fractions.(strcat('frac_',names{i})) = data.subsystem_masses.(names{i})/m_ref; % Calculate the fraction 
  end

end