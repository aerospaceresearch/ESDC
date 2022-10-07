%initially called by mass budget propulsion, should now be called in mass budget power

function [m_PV] = m_scale_PV(P_out, db_data)
 filename = strcat("Database/Scaling/scaling_power_generation_photovoltaic_cell_mass_to_power_max");


    data = dlmread(filename,",");

  m_PV = scaling_linear(P_out,data);
  
end
  % PV scaling takes place in power system
  %mass_propulsion.PV         = m_scale_PV(data.power_propulsion, db_data);
