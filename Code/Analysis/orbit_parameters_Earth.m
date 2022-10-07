function [orbit_parameter] = orbit_parameters_Earth(height_above_ground_km) %Produces orbital parameters for a given orbital height in km
  orbit_parameter=struct;
  
  constant = celestial_constants();
  
  m_Earth = constant.m_Earth;     % 5.97237*10^24;                     % mass of Earth in kg             https://ssd.jpl.nasa.gov/?planet_phys_par
  r_Earth = constant.r_Earth;     % 6371.0084*10^3;                    % mean radius Earth in meters     https://ssd.jpl.nasa.gov/?planet_phys_par
  G       = constant.G;           % 6.67430 *10^(-11);                 % gravity constant kg-1 m3 s-2    https://ssd.jpl.nasa.gov/?constants
  au      = constant.au;          % 1.4959787066*10^11;                % 1 astronomic unit in m, mean distance sun Earth https://solarsystem.nasa.gov/basics/units/
  r_Sun   = constant.r_Sun;       % 695700*10^3;                       % mean radius sun                 https://nssdc.gsfc.nasa.gov/planetary/factsheet/sunfact.html

  mu_g    = constant.mu_g;                    % local gravity parameter
  height = height_above_ground_km*10^3;       % convert height from km to m
  orbit_height = r_Earth+height;              % add Earth radius to height above ground
  
  orbit_parameter.height                                              = orbit_height;
  orbit_paramter.height_above_surface                                 = height;
  orbit_parameter.velocity                                            = orbital_velocity(mu_g, orbit_height);                                                    % orbital velocity at given height
  orbit_parameter.time.orbit                                          = orbital_time(mu_g, orbit_height);                                                        % time for a single circular orbit
  [orbit_parameter.time.shadow orbit_parameter.time.average_light]    = orbital_time_shadow(r_Earth, r_Sun, au, orbit_parameter.time.orbit, orbit_height) ;      % times of shadow phases, umbra, penumbra, total, averaged 
  orbit_parameter.time.full_light                                     = orbit_parameter.time.orbit - orbit_parameter.time.shadow.total;                          % time of pure light
  orbit_parameter.time.comm_max                                       = orbital_time_comm(orbit_parameter.time.orbit, orbit_height, r_Earth);                    % time of maximum possible communication
  orbit_parameter.magneticfield                                       = orbit_magnetic_field(orbit_height, r_Earth);
end

function velocity = orbital_velocity(mu_g, orbit_height)
  velocity = sqrt(mu_g/orbit_height);
end

function time = orbital_time(mu_g,orbit_height)
  time =  2*pi*sqrt(orbit_height^3/mu_g);
end

function [time time_average_light] = orbital_time_shadow( r_Earth, r_Sun, au, orbit_time, orbit_height)    % https://core.ac.uk/download/pdf/42780676.pdf page 9
  
  time = struct;
  
  D_P = 2*r_Earth;                                                                    % Diameter of planet
  D_S = 2*r_Sun;                                                                      % Diameter of Sun
  
  %umbra // coreshadow 
  xi_u = D_P*au/(D_S-D_P) ;                                                           % umbra length
  if (xi_u> orbit_height)
    alpha_umbra = asin(D_P/(2*xi_u));                                                 % half angle of umbra cone
    beta_umbra = asin((xi_u/orbit_height)*sin(alpha_umbra));                          % beta angle of umbra cone, intersection with line of umbra and orbital height, law of sines
    beta_umbra = pi-beta_umbra;                                                       % select the larger angle of asin in the invervall [45-90°] /[pi/2 pi]
    gamma_umbra = pi-alpha_umbra - beta_umbra;                                        % internal angle law, sum is 180° or pi
    time.umbra =2*gamma_umbra/(2*pi)*orbit_time;                                      % two times the umbra angle for a circular orbit
  end
  
  %penumbra // halfshadow
  xi_p = D_P*au/(D_S+D_P);                                                           % penumbra focal point distance in front of Earth
  alpha_penumbra = asin(D_P/(2*xi_p));                                               % opening angle of penumbra
  beta_1 = pi-pi/2-alpha_penumbra;                                                   % internal angle of triangle focal point, earth center and penumbra intersect earth
  beta_2 = pi-beta_1;                                                                % internal angle on the opposing side
  alpha_2= asin(r_Earth/orbit_height*sin(beta_2));                                   % law of sines for calculating angle for intersecting orbital height
  gamma_2=pi-beta_2-alpha_2;                                                         % internal angle law, sum is 180° or pi
  gamma_penumbra =  pi/2-gamma_2;                                                    % composite angle for getting 90° or pi/2
  
  if isfield(time,'umbra')
    gamma_penumbra = gamma_penumbra-gamma_umbra;                                     % substract opening angle of the umbra from the penumbra to get the remaining time
  end
  time.penumbra = 2*gamma_penumbra/(2*pi)*orbit_time;                                % two times for the penumbra angle for a circular orbit 
  
  time.total = time.penumbra;                                                        % calculate time where not total light is available
  if isfield(time,'umbra')
  time.total = time.total + time.umbra;                                              % add shadow times
end
  
  if (xi_u> orbit_height)                                                            % if orbit is near enough
    time_average_light = orbit_time -time.umbra - 1/2*time.penumbra;                 % zero power available at umbra , continously reducting power at penumbra, thus half available
 else 
    r_x = r_Earth/orbit_height*(orbit_height+au);                                     % projected radius of half shadowing earth on sun surface
    reduction_factor = (r_Sun^2-r_x^2)/(r_Sun^2);                                     % reduction factor of the projected radius of the earth circle on the sun circle
    time_average_light =  orbit_time-time.penumbra*reduction_factor;                  % calculate available time, when during penumbra full reduction is continously applied
  end


end

function time= orbital_time_comm(time, orbit_height, r_Earth)                        % maximum available time for communication
  alpha_comm = acos(r_Earth/orbit_height);                                           % best case assumption starting comm when over the horizon until next horizon
  time = alpha_comm/pi*time;
end

function b_field =   orbit_magnetic_field(orbit_height, r_Earth)
  B_0 = 2.259*10^-5;                                                                % mean value of the magnetic field at the magnetic equator on the Earth's surface, ] C. C. Finlay, S. Maus, C. D. Beggan, T. N. Bondar, A. Chambodut, T. A. Chernova, A. Chulliat, V. P. Golovkov, B. Hamilton, M. Hamoudi, R. Holme, G. Hulot, W. Kuang, B. Langlais, V. Lesur, F. J. Lowes, H. Lühr, S. Macmillan, M. Mandea, S. McLean, C. Manoj, M. Menvielle, I. Michaelis, N. Olsen, J. Rauberg, M. Rother, T. J. Sabaka, A. Tangborn, L. Tøffner-Clausen, E. Thébault, A. W. P. Thomson, I. Wardinski, Z. Wei, T. I. Zvereva, International Geomagnetic Reference Field: the eleventh generation, Geophysical Journal International, Volume 183, Issue 3, December 2010, +Pages 1216–1230, https://doi.org10.1111/j.1365- 246X.2010.04804.x
  co_lat = pi/2;                                                                    % the colatitude measured from the north magnetic pole, pi/2 = 90° at equator
  b_field = B_0*(r_Earth/orbit_height)^3*sqrt(1+3*(cos(co_lat))^2);                 % Walt, Martin (1994). Introduction to Geomagnetically Trapped Radiation. New York, NY: Cambridge University Press. pp. 29–33. ISBN 0-521-61611-5. 
end

