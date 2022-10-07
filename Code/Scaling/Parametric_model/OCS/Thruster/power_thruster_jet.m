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
## @deftypefn {} {@var{retval} =} power_thruster_jet´ (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: op <op@op>
## Created: 2021-07-05

function P_jet = power_thruster_jet(F, c_e)
  P_jet = 1/2*F*c_e;
endfunction

function P_in = power_thruster_UI(U,I)
  P_in = U*I;
endfunction

function mu_thruster = power_thruster_efficiency(P_jet,P_el)        % or from correlation 
  mu_thruster = P_jet/P_el;
endfunction

