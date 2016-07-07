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

    ; Fuses settings
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



;;;;; Variables
; Delay
DELAY_COUNT1 EQU 0x021
DELAY_COUNT2 EQU 0x022
DELAY_COUNT3 EQU 0x023
DELAY_COUNT4 EQU 0x024




    ORG     0

INIT
    ; Init internal oscillator
    ; 4MHz
    call    BANK15
    movlw   B'11101101'
    movwf   OSCCON

    ; Init delay counters
    movlw   0xFF
    movwf   DELAY_COUNT1
    movwf   DELAY_COUNT2
    movwf   DELAY_COUNT3
    movwf   DELAY_COUNT4

    ; Init TRISB as ouput
    movlw   B'0000000'
    movwf   TRISB
    movwf   PORTB

    ; Init UART
    ; Asynchornous, 8 bits, high speed
    ; 9.6Kbd
    bsf     RCSTA, SPEN
    bsf     TRISC, TRISC6
    bsf     TRISC, TRISC7
    movlw   .25
    movwf   SPBRG
    movlw   B'00100110'
    movwf   TXSTA
    movlw   B'10010000'
    movwf   RCSTA
    movlw   B'00000000'
    movwf   BAUDCON



MAIN
    call    BANK15
    comf    PORTB,1
    movlw   'a'
    movwf   TXREG
    call    DELAY
    goto    MAIN
    goto    DIE


DIE
    nop
    goto DIE


BANK0
    movlb   0x00
    return
BANK1
    movlb   0x01
    return
BANK2
    movlb   0x02
    return
BANK3
    movlb   0x03
    return
BANK15
    movlb   0x0F
    return


DELAY
    dcfsnz  DELAY_COUNT1,1
    return
REDUCE_DELAY
    dcfsnz  DELAY_COUNT2,1
    goto    DELAY
    nop
    goto    REDUCE_DELAY
; REDUCE_DELAY1
;     dcfsnz  DELAY_COUNT3,1
;     goto    REDUCE_DELAY
;     nop
;     goto    REDUCE_DELAY1
; REDUCE_DELAY2
;     dcfsnz  DELAY_COUNT4,1
;     goto    REDUCE_DELAY1
;     nop
;     goto    REDUCE_DELAY2


    END

; vim:ft=pic8
