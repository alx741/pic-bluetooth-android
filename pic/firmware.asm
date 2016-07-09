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

; ADC result
ADCH EQU 0x025
ADCL EQU 0x026

; ADC modes
ADCMODE_A_ADCON0 EQU B'00000001'
ADCMODE_A_ADCON2 EQU B'00010100'
ADCMODE_B_ADCON0 EQU B'00000001'
ADCMODE_B_ADCON2 EQU B'00010101'
ADCMODE_C_ADCON0 EQU B'00000101'
ADCMODE_C_ADCON2 EQU B'00010100'
ADCMODE_D_ADCON0 EQU B'00000101'
ADCMODE_D_ADCON2 EQU B'00010101'



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

    ; Init ADC
    ; MODE A
    movlw   ADCMODE_A_ADCON0
    movwf   ADCON0
    movlw   B'00001101'
    movwf   ADCON1
    movlw   ADCMODE_A_ADCON2
    movwf   ADCON2



MAIN
    ; Check for new incomming configuration
    btfsc   PIR1, RCIF
    call    CONFIGURE_ADC

    ; Convert and send results
    call    ADC_CONVERT
    movff   ADCH, TXREG
    call    WAIT_UART_TRANSMISSION
    movff   ADCL, TXREG

    movff   ADCH, PORTB
    goto    MAIN


GET_UART_DATA
    btfss   PIR1, RCIF
    goto    GET_UART_DATA
    bcf     PIR1, RCIF
    movlw   'b'
    cpfseq  RCREG
    return
    comf    PORTB,1
    clrf    RCREG
    return

; CONFIGURE_ADC
;     movff   RCREG, ADCON0
;     clrf    RCREG
;     bcf     PIR1, RCIF
; wait_second_byte
;     btfss   PIR1, RCIF
;     goto    wait_second_byte
;     movff   RCREG, ADCON2
;     clrf    RCREG
;     bcf     PIR1, RCIF
;     ; Send confirmation byte
;     movlw   '.'
;     movwf   TXREG
;     return

CONFIGURE_ADC
    movlw   'a'
    cpfsgt  RCREG
    goto    adc_mode_a

    movlw   'b'
    cpfsgt  RCREG
    goto    adc_mode_b

    movlw   'c'
    cpfsgt  RCREG
    goto    adc_mode_c

    movlw   'd'
    cpfsgt  RCREG
    goto    adc_mode_d
adc_mode_a
    movlw   ADCMODE_A_ADCON0
    movwf   ADCON0
    movlw   ADCMODE_A_ADCON2
    movwf   ADCON2
    goto    adc_clean
adc_mode_b
    movlw   ADCMODE_B_ADCON0
    movwf   ADCON0
    movlw   ADCMODE_B_ADCON2
    movwf   ADCON2
    goto    adc_clean
adc_mode_c
    movlw   ADCMODE_C_ADCON0
    movwf   ADCON0
    movlw   ADCMODE_C_ADCON2
    movwf   ADCON2
    goto    adc_clean
adc_mode_d
    movlw   ADCMODE_D_ADCON0
    movwf   ADCON0
    movlw   ADCMODE_D_ADCON2
    movwf   ADCON2
    goto    adc_clean
adc_clean
    clrf    RCREG
    bcf     PIR1, RCIF
    return

WAIT_UART_TRANSMISSION
    btfss   TXSTA, TRMT
    goto WAIT_UART_TRANSMISSION
    return

ADC_CONVERT
    call    DELAY
    bsf     ADCON0, GO_DONE
adc_wait
    btfsc   ADCON0, GO_DONE
    goto    adc_wait
    movff   ADRESH, ADCH
    movff   ADRESL, ADCL
    return





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
