function [x] = scaling_linear(y, data)
    % Interpolate for known data, extrapolate beyond.

    x = interp1(data(4,:),data(3,:),y,'linear','extrap');
    
    %some values become negative - check!!!
      
  if x<0      %exclude negatives
    x=0;
  end
endfunction