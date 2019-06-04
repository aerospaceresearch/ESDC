function [mass_fractions] = mass_fractions(data)
  m_ref= data.mass;
  names= fieldnames(data.subsystem_masses);
  mass_fractions = struct();
  
  for i=1:numel(names)
  mass_fractions.(names{i}) = data.subsystem_masses.(names{i})/m_ref;
  end

end