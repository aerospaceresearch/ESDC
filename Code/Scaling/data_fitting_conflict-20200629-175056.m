function [data_fit] = data_fitting(data)  % TODO: add option for degree of polynominal fit
    %fits data by cubic least square fit
    poly2_coeff= polyfit(data(2,:),data(1,:),2);
    data_span = linspace(data(2,1),data(2,end),100);
    
    data_fit(1,:)= poly2_coeff(1).*data_span.^2+poly2_coeff(2).*data_span+poly2_coeff(3);
    data_fit(2,:) = data_span;
endfunction
