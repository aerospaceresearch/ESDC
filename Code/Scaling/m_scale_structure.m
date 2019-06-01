function [m_struct_out] = m_scale_structure(type)
% elaborate further?
    if strcmp(type,'arcjet')
           m_struct_out=  0.493;
    elseif strcmp(type,'gridionthruster')
            m_struct_out=  2;
    else
         disp('no struct mass available')
         m =0;
    end
end