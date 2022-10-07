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
## @deftypefn {} {@var{retval} =} Solar_irradiance (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: op <op@op>
## Created: 2021-07-05

function G_S = Solar_irradiance (input1, input2)
  G_S = 1362*(1/r_sun_Au)^2;
endfunction


function G_S = Solar_constant ()
  G_S = 1362;
endfunction


function G_S_mean = Solar_irradiance_mean (G_S,tau_orbit,tau_sun)
  G_S_mean = G_Solar*tau_sun/tau_orbit;
endfunction