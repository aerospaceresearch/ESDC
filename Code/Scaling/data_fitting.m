function [data_fit] = data_fitting(data)
  
      threshold = 0.95;  % max 1-> perfect fit %TODO Simulation parameter

    % find best fitting polynominal fit for 1th 2nd and 3rd degree polynominal
      %disp(data)
      for i=1:4
        [trash_vals intp_data] = polyfit(data(2,:),data(1,:),i);
        normed_res(i)=intp_data.normr;
      end
    %normed_res
    
    % norm residuals against different approaches
    if not(normed_res(1) == 0)
      for i=1:4
        normed_res_1(i) = normed_res(i)./normed_res(1);
      end

    %normed_res_1
      if min(normed_res_1)> threshold
        result=1;
      else
        result=0;
      end
    else
        result =0;
    endif

    if not(result || normed_res(2) == 0)
        for i=1:3
          normed_res_2(i) = normed_res(i)./normed_res(2);
        end
        
        if (min(normed_res_2)> threshold)
          result=2;
        end

    endif
 
    if not(result|| normed_res(3) == 0)
      
      for i=1:4           % check for fourth 
        normed_res_3(i) = normed_res(i)./normed_res(3);
      end
    
      if (min(normed_res_3)> threshold)  % reconsider here!!
        result=3;
      end
      
    end
    
    if result == 3
        [itp_func_coeffs intp_data] = polyfit(data(2,:),data(1,:),result);
        x_fit= linspace(data(2,1),data(2,end),100);
        
          for i=1:numel(x_fit)
              y_fit(i) =0;
            for j=1:numel(itp_func_coeffs)
              y_fit(i)=y_fit(i)+itp_func_coeffs(j)*x_fit(i)^(numel(itp_func_coeffs)-j);
            end
          end
          
          if min(y_fit) < min(data(1,:)) || max(y_fit) > max(data(1,:))
            result =1;
          end
          
    end
    
    if not(result)
        result=1;
    end
    
  [itp_func_coeffs intp_data] = polyfit(data(2,:),data(1,:),result);
  %end

  %reconstruct function here for lookup table genpath
  x_fit= linspace(data(2,1),data(2,end),100);
  

  for i=1:numel(x_fit)
    y_fit(i) =0;
      for j=1:numel(itp_func_coeffs)
        y_fit(i)=y_fit(i)+itp_func_coeffs(j)*x_fit(i)^(numel(itp_func_coeffs)-j);
      end
      
  end
  
%  figure;
%  hold on;
%
%    plot(data(2,:),data(1,:),'*')
%    plot(x_fit,y_fit,'-')

  data_fit(1,:) = y_fit;
  data_fit(2,:) = x_fit;
  
  
endfunction