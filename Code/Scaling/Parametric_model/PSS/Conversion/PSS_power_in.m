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
## @deftypefn {} {@var{retval} =} PSS_power_in (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: op <op@op>
## Created: 2021-07-05

function P_in = PSS_power_in (mu_PSS, P_PV_out_mean)
  P_in = mu_PSS*P_PV_out_mean; 
endfunction

function P_in = PSS_power_in_PV (mu_PSS, I_PV_out, U_PV_out)
  P_in = mu_PSS*_PV_out*U_PV_out; 
endfunction
