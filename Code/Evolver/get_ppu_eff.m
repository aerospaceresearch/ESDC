function eff_ppu = get_ppu_eff(data)
 %todo: update this to not consider the average of all relevant PPUs but look for data adaptive estimate
  n_ppu = size(data,2);
  if n_ppu==1
    eff_ppu= data.efficiency;
  else
    eff_ppu_list = [];
    for i=1:n_ppu
      eff_ppu_list = [eff_ppu_list;data{i}.efficiency];
    end
      eff_ppu = average_array(eff_ppu_list);
  end
end
