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
## @deftypefn {} {@var{retval} =} Tsiolkovsky (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: op <op@op>
## Created: 2021-07-05

function dv = Tsiolkovsky_dv_m_b(c_e, m_0, m_b)
  dv = c_e*ln(m_0/m_b);
endfunction

function dv = Tsiolkovsky_dv_m_p(c_e, m_0, m_p)
  dv = c_e*ln(m_0/(m_0-m_p);
endfunction

function m_p = Tsiolkovsky_m_p(dv, c_e, m_0)
  m_p = (1-e^(-dv/c_e))*m_0;
endfunction

function m_b = Tsiolkovsky_m_b(dv, c_e, m_0)
  m_b = e^(-dv/c_e))*m_0;
endfunction

function m_0 = Tsiolkovsky_m_0_m_b(dv, c_e, m_b)
  m_0 = e^(dv/c_e))*m_b;
endfunction
