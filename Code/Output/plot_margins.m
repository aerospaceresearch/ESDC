function [input] = plot_margins(input, config)

    for j=1:size(input,2)    
        %index for area of mu_EP_min less margin
        [~, min_index] = min(input(j).result.mu_EP);
        margin_limit =input(j).result.mu_EP_min*(1+config.margin/100);
        
       [~, min_addmargin_index]  = min(abs(input(j).result.mu_EP(min_index:end) - margin_limit ));
       min_addmargin_index= min_addmargin_index+min_index;
            if min_addmargin_index > size(input(j).result.mu_EP ,2)
                min_addmargin_index = size(input(j).result.mu_EP ,2);
            end
        %index for area of mu_EP_min greater margin
       [~, min_lessmargin_index] = min(abs(input(j).result.mu_EP(1:min_index) - margin_limit ));
       
        input(j).mu_min_margin     = input(j).result.mu_EP(min_lessmargin_index:min_addmargin_index);
        input(j).mu_min_margin_c_e = input(j).c_e(min_lessmargin_index:min_addmargin_index);
    end 
end
