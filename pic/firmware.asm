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

#include p18f4550.inc
list p=18f4550

    ; Fuses setting
    CONFIG PLLDIV = 1
    CONFIG CPUDIV = OSC1_PLL2
    CONFIG FOSC = INTOSCIO_EC
    CONFIG FCMEN = OFF
    CONFIG IESO = OFF
    CONFIG PWRT = ON
    CONFIG BOR = OFF
    CONFIG WDT = OFF
    CONFIG PBADEN = OFF
    CONFIG LPT1OSC = OFF
    CONFIG MCLRE = ON
    CONFIG STVREN = OFF
    CONFIG LVP = OFF
    CONFIG ICPRT = OFF
    CONFIG XINST = OFF
    CONFIG DEBUG = OFF
    CONFIG CP0 = OFF
    CONFIG CP1 = OFF
    CONFIG CP3 = OFF
    CONFIG CPB = OFF
    CONFIG CPD = OFF
    CONFIG WRT0 = OFF
    CONFIG WRT1 = OFF
    CONFIG WRT2 = OFF
    CONFIG WRT3 = OFF
    CONFIG WRTC = OFF
    CONFIG WRTB = OFF
    CONFIG WRTD = OFF
    CONFIG EBTR0 = OFF
    CONFIG EBTR1 = OFF
    CONFIG EBTR2 = OFF
    CONFIG EBTR3 = OFF
    CONFIG EBTRB = OFF



; Variables
DELAY_COUNT1 EQU 0x021
DELAY_COUNT2 EQU 0x022
DELAY_COUNT3 EQU 0x023
DELAY_COUNT4 EQU 0x024




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
