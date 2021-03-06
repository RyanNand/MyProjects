@ Program: Basic Name Display
@ Description: Program will display name on LCD screen using UART2 on pin 21 of P9 upon 
@ falling edge from button on GPIO 31. There should be a background color change as well.
@ Date: 01/25/2021
@ Author: Ryan Nand

.text
.global _start
.global INT_DIRECT
_start:
.equ	NUM, 3				@ Array length

@ Initialize program stacks
	LDR R13, =STACK1		@ Point to base of Stack for SVC mode
	ADD R13, R13, 0x1000		@ Point to top of STACK
	CPS #0x12			@ Switch to IRQ mode
	LDR R13, =STACK2		@ Point to IRQ stack
	ADD R13, R13, #0x1000		@ Point to top of STACK
	CPS #0x13			@ Back to SVC mode

@ Initialize GPIO1 clock
	MOV R0, #0x02			@ Value to enable clock
	LDR R1, =0x44E00000		@ Base address of CM_PER 
STR R0, [R1, #0xAC]			@ Write to CM_PER_GPIO1_CLKCTRL

@ Initialize UART2 clock
	STR R0, [R1, #0x70]		@ Write to CM_PER_UART2_CLKCTRL

@ Set up GPIO 31 for falling edge interrupt
	LDR R0, =0x4804C000		@ Base address for GPIO1 registers
	ADD R1, R0, #0x14C		@ Falling detect register offset
	MOV R2, #0x80000000		@ Bit 31
	LDR R3, [R1]			@ Read falling detect register
	ORR R3, R3, R2			@ Enable/modify falling detect
	STR R3, [R1]			@ Write back to falling detect register
	ADD R1, R0, #0x34		@ GPIO1_IRQSTATUS_SET_0 address
	STR R2, [R1]			@ Enable GPIO1_31 request on POINTRPEND1

@ Initialize INTC
	LDR R1, =0x48200000		@ Base address for INTC
	MOV R2, #0x2			@ Value to reset INTC
	STR R2, [R1, #0x10]		@ Write to INTC config register
	MOV R2, #0x04			@ Value to unmask INTC INT 98, GPIOINTA
	STR R2, [R1, #0xE8]		@ Unmask/Write to INTC_MIR_CLEAR3
	MOV R2, #0x400			@ Value to unmask INTC INT 74, UART2
	STR R2, [R1, #0xC8]		@ Unmask/Write to INTC_MIR_CLEAR2

@ Map UART2 
	LDR R0, =0x44E10954		@ Address for CONF_SPI0_D0 register
	MOV R1, #0x11			@ Value for MODE1 and pull-up
	LDR R2, [R0]			@ Read CONF_SPI0_D0 register
	ORR R2, R2, R1			@ Modify
	STR R2, [R0]			@ Write to CONF_SPI0_D0

@ Initialize UART2 Baud rate, etc.
	LDR R0, =0x48024000		@ Base address for UART2
	MOV R1, #0x83			@ Value to switch to mode A and set data format
	STR R1, [R0, #0x0C]		@ Write to LCR register
	MOV R1, #0x01			@ Value to write to DLH for 9.6kbps Baud
	STR R1, [R0, #0x04]		@ Write to DLH register
	MOV R1, #0x38			@ Value to write to DLL for 9.6kbps Baud
	STR R1, [R0]			@ Write to DLL register
	MOV R2, #0x00			@ Value to write to MDR1 for 16x UART mode
	STR R2, [R0, #0x20]		@ Write to MDR1
	MOV R1, #0x03			@ Value to switch back op mode w/o resetting data format
	STR R1, [R0, #0x0C]		@ Write to LCR
	STR R2, [R0, #0x8]		@ Disable FIFO
	
@ Enable IRQ interrupt
	MRS R3, CPSR			@ Copy CPSR to R3
	BIC R3, #0x80			@ Clear bit 7
	MSR CPSR_c, R3			@ Write back to CPSR

@ Initialize counter
	MOV R0, #0x0			@ Internalized counter

@ Wait for interrupt
LOOP: NOP
	B LOOP

@ Find source of interrupt and direct it to the correct procedure
INT_DIRECT:
	STMFD SP!, {R3, LR}		@ Save registers on stack
	LDR R2, =0x482000D8		@ Address for INTC_PENDING_IRQ2
	LDR R3, [R2]			@ Read INTC_PENDING_IRQ2
	TST R3, #0x00000400		@ Test bit 10
	BEQ BCHK			@ If bit 10 != 1 go to BCHK (If AND result all equal to zero)
	LDR R2, =0x48024008		@ Else continue to check UART2 address of IIR_UART2
	LDR R3, [R2]			@ Read IIR_UART2
	TST R3, #0x00000001		@ Test bit 0
	BEQ TALKER_SVC			@ If bit 0 = 0 go to TALKER_SVC (result all equal to zero)
	B RETURN			@ Else go to RETURN to return to infinite loop
BCHK:
	LDR R2, =0x482000F8		@ Address of INTC_PENDING_IRQ3
	LDR R3, [R2]			@ Read INTC_PENDING_IRQ3
	TST R3, #0x00000004		@ Test bit 2
	BEQ RETURN			@ If bit 2 = 0 return to infinite loop
	LDR R2, =0x4804C02C		@ Address of GPIO1_IRQSTATUS_0
	LDR R3, [R2]			@ Read GPIO1_IRQSTATUS_0
	TST R3, #0x80000000		@ Test bit 31
	BNE BUTTON_SVC			@ If bit 31 = 1 go to BUTTON_SVC
RETURN:
	LDR R2, =0x48200048		@ Address of INTC_CONTROL
	MOV R3, #0x01			@ Value to enable new IRQ interrupt
	STR R3, [R2]			@ Enable interrupt
	LDMFD SP!, {R3, LR}		@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop

@ Button procedure
BUTTON_SVC:
	MOV R3, #0x80000000		@ Value of bit 31
	STR R3, [R2]			@ Disable IRQ for button
	MOV R3, #0x1			@ Value to turn off NEWIRQA
	LDR R2, =0x48200048		@ Address of INTC_CONTROL 
	STR R3, [R2]			@ Write to disable NEWIRQA
	MOV R3, #0x2			@ Value to enable UART2 interrupt
	LDR R2, =0x48024004		@ Address of IER_UART2
	STR R3, [R2]			@ Enable UART2 interrupt
	LDMFD SP!, {R3, LR}		@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop

@ UART procedure
TALKER_SVC:
	MOV R1, #NUM			@ Load array length
	SUBS R1, R1, R0			@ Update counter
	BEQ STOP			@ If R1 = 0 go to STOP
	LDR R1, =MESSAGE		@ Point to message
	LDRB R2, [R1, R0]!		@ Load 8-bit value from message
	LDR R1, =0x48024000		@ Address of THR_UART2
STRB R2, [R1] 				@ Write 8-bit value to THR_UART2
ADD R0, R0, #1				@ Increment counter
MOV R3, #0x1				@ Value to enable new interrupt
	LDR R2, =0x48200048		@ Address of INTC_CONTROL
	STR R3, [R2]			@ Write to enable new interrupt
LDMFD SP!, {R3, LR}			@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop
STOP:
	MOV R3, #0x0			@ Value to disable UART2
	LDR R2, =0x48024004		@ Address of IER_UART
	STR R3, [R2]			@ Write to disable UART2
	LDMFD SP!, {R3, LR}		@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop

.data
.align 2
MESSAGE:	.ascii ???Ryan???

STACK1:	.rept 1024
		.word 0x000
		.endr
STACK2:	.rept 1024
		.word 0x000
		.endr

.end
