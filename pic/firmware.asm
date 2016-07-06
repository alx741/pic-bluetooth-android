; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
; By: Daniel Campoverde Carrión [Alx741]
; Assembler: GPASM (should work with Microchip's assembler as well)

#include p16f876a.inc
list p=16f876A
    __config _FOSC_XT & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF
    __config _CPD_OFF & _WRT_OFF & _DEBUG_OFF & _CPD_OFF


; vim:ft=pic8
