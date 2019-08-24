function [y] = scaling_linear(x, data)
    % Interpolate for known data, extrapolate beyond.
  if x<=data(1,end)
    y = interp1(data(1,:),data(2,:),x,"linear");
  else
    y = interp1([data(1,1) data(1,end)],[data(2,1) data(2,end)],x,"extrap");
    if numel(data(1,:)==1)
      disp(strcat("Warning: Insufficent extrapolation data"));
    end
  end

endfunction