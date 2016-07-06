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
    __config _FOSC_XT & _WDT_OFF & _PWRTE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _DEBUG_OFF & _CPD_OFF


    ORG     0

MAIN
    call    BANK1
    movlw   B'1111111'
    movwf	TRISB
    movwf	PORTB
    goto    DIE


DIE
    nop
    goto DIE


BANK0
    bcf     STATUS,RP0
    bcf     STATUS,RP1
    return

BANK1
    bsf     STATUS,RP0
    bcf     STATUS,RP1
    return

BANK2
    bcf     STATUS,RP0
    bsf     STATUS,RP1
    return

BANK3
    bsf     STATUS,RP0
    bsf     STATUS,RP1
    return



    END

; vim:ft=pic8
