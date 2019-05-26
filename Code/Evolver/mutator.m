function lineage_mutated = mutator(lineage_old)

lineage_mutated = lineage_old;
  for i=1:numel(fieldnames(lineage_mutated.mutagen))
      
      if isfield(lineage_mutated.mutagen,'propulsion_type')
        lineage_mutated.propulsion_type = mutate_propulsion_type();
      end
   
     if isfield(lineage_mutated.mutagen,'propellant')
        lineage_mutated.propellant = mutate_propellant(lineage_mutated.propulsion_type);
      end
   
      if isfield(lineage_mutated.mutagen,'c_e')
         lineage_mutated.c_e= mutate_c_e(lineage_mutated.propulsion_type,lineage_mutated.propellant,lineage_old.c_e);
      end
      
      if isfield(lineage_mutated.mutagen,'F')
         lineage_mutated.F= mutate_F(lineage_mutated.propulsion_type,lineage_mutated.propellant,lineage_mutated.c_e, lineage_old.F);
      end
      
  end

    mass_data = scale_EPsystem(lineage_mutated)
    for fn= fieldnames(mass_data)'
        lineage_mutated.(fn{1})=  mass_data.(fn{1});
    end
end

function propulsion_type_new = mutate_propulsion_type()
  %make list of propulsion types
    %look up data base or data base tree 
    %make a random pick from data base available types 
        %consider 
end

function propellant_type_new = mutate_propellant(propulsion_type)

%%only mutate between applied propellants - no increments
% prop_new = randi(max(get_prop_span()));

end

function c_e_new = mutate_c_e(propulsion_type,propellant_type, c_e)

%c_e_span = get_c_e_span();
%
%resolution_const=0.0001; % here potential for improvement
%diff = (max(c_e_span)-min(c_e_span));
%direction = (-1)^randi(2);
%increment = randi(100); % potential for improvement
%
%c_e_new = c_e_old+direction*increment*diff*resolution_const;
%
%%mutation definition here
%
%if c_e_new> max(c_e_span)
%    c_e_new = max(c_e_span);
%end
%if c_e_new< min(c_e_span)
%    c_e_new = min(c_e_span);
%end

end

function F_new = mutate_F(propulsion_type,propellant_type, c_e,F)
%F_span = get_F_span();
%resolution_const=0.001; % here potential for improvement
%diff = (max(F_span)-min(F_span));
%direction = (-1)^randi(2);
%increment = randi(10); %10 potential for improvement
%
%F_new = F_old+direction*increment*diff*resolution_const;

%
%if F_new> max(F_span)
%    F_new = max(F_span);
%end
%if F_new< min(F_span)
%    F_new = min(F_span);
%end

end
