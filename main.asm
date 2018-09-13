;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
.text
	bis.b #BIT0,&P1DIR; LED1 P1.0=output
	bis.b #BIT7,&P4DIR; LED2 P4.7=output
	bic.b #BIT1,&P1DIR; S2 P1.1=input
	bis.b #BIT1,&P2OUT; S2 w/ pull up/dw
	bis.b #BIT1,&P2REN; S2  pull up
	call #CONTA
	jmp $

CONTA: mov.w #0,R5; counter
LA:    bit.b #BIT1,&P2IN; read button state
	   jnz LA; case open
	   inc.b R5; count++
	   cmp.b #1,R5;
	   jeq num1;
	   cmp.b #2,R5;
	   jeq num2;
	   cmp.b #3,R5;
	   jeq num3;
	   mov.w #0,R5;
	   bic.b #BIT0,&P1OUT; LED 1 off
	   bic.b #BIT7,&P4OUT; LED 2 off
LF:    bit.b #BIT1,&P2IN; read button
	   jz LF; case close
	   jmp LA;
num1: bis.b #BIT0,&P1OUT; LED 1 on
	  bic.b #BIT7,&P4OUT; LED 2 off
num2: bic.b #BIT0,&P1OUT; LED 1 off
      bis.b #BIT7,&P4OUT; LED 2 on
num3: bis.b #BIT0,&P1OUT; LED 1 on
      bis.b #BIT0,&P4OUT; LED 2 on
                                            

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
