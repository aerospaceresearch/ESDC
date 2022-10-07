## Copyright (C) 2021 op
## 
## This program is free software: you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <https://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {} {@var{retval} =} time_shadow (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: op <op@op>
## Created: 2021-07-05

function tau_shadow = time_shadow_surface_km (height)
  m_Earth = 5.97237*10^24;
  mu_g = 6.6743015*10^-11;
  grav= m_Earth*mu_g;
  r_Earth = 6371; % km
  
  tau_shadow = 2*sqrt(((r_Earth+height)*10^3)^3/grav)*asin(r_Earth/((r_Earth+height)*10^3));
endfunction


function tau_shadow = time_shadow__Earth_center_km(height)
  m_Earth = 5.97237*10^24;
  mu_g = 6.6743015*10^-11;
  grav= m_Earth*mu_g;
  r_Earth = 6371; % km
  tau_shadow = 2*sqrt(((height)*10^3)^3/grav)*asin(r_Earth/((height)*10^3));
endfunction
