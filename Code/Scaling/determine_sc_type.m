function [sc_type] = determine_sc_type(data)
    if isfield(data,'dv') && (data.dv >0) % only type 1,2,3 when propelled
      sc_type = 2; % LEO type mission is default
      if (data.dv >2000) && (data.dv <=4300)
        sc_type = 3; % High Earth type mission like GEO
      elseif (data.dv >4300) % dv to escape earth from orbital velocity, makes planetary probe type mission (3)
        sc_type = 4;
      endif
    else 
      sc_type = 1; % no propulsion case
    endif
endfunction