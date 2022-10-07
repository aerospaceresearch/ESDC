function [constant] = celestial_constants()
  
  constant = struct;
  
  constant.m_Earth = 5.97237*10^24;                     % mass of Earth in kg             https://ssd.jpl.nasa.gov/?planet_phys_par
  constant.r_Earth = 6371.0084*10^3;                    % mean radius Earth in meters     https://ssd.jpl.nasa.gov/?planet_phys_par
  constant.G       = 6.67430 *10^(-11);                 % gravity constant kg-1 m3 s-2    https://ssd.jpl.nasa.gov/?constants
  constant.au      = 1.4959787066*10^11;                % 1 astronomic unit in m, mean distance sun Earth https://solarsystem.nasa.gov/basics/units/
  constant.r_Sun   = 695700*10^3;                       % mean radius sun                 https://nssdc.gsfc.nasa.gov/planetary/factsheet/sunfact.html
  constant.solar_constant_at_au = 1360.8;                % W/m² https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2010GL045777

  constant.mu_g    =constant.m_Earth*constant.G ;                      % local gravity parameter
endfunction
