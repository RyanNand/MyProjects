@ Program: Rotate Name Display
@ Description: Program will display name on LCD screen using UART2 on pin 21
@ of P9. A button connected to GPIO1_31 (pin 20 of P8) will start the program.
@ Then the screen will shift to the right, eventually repeating.
@ Author: Ryan Nand
@ Date: 02/01/2021

.text
.global _start
.global INT_DIRECT
_start:
.equ NUM, 6				@ Message array length

@ Initialize program stacks
	LDR R13, =STACK1		@ Point to base of STACK1 for SVC mode
	ADD R13, R13, #0x1000		@ Point to top of STACK1
	CPS #0x12			@ Switch to IRQ mode
	LDR R13, =STACK2		@ Point to base of STACK2 for IRQ mode
	ADD R13, R13, #0x1000		@ Point to top of STACK2
	CPS #0x13			@ Switch back to SVC mode

@ Initialize GPIO1 clock
	MOV R0, #0x02			@ Value to enable clock
	LDR R1, =0x44E00000		@ Base address of CM_PER
	STR R0, [R1, #0xAC]		@ Write to CM_PER_GPIO1_CLKCTRL
@ Initialize UART2 clock
	STR R0, [R1, #0x70]		@ Write to CM_PER_UART2_CLKCTRL
@ Initialize Timer7 clock
	STR R0, [R1, #0x7C]		@ Write to CM_PER_TIMER7_CLKCTRL
	LDR R1, =0x44E00504		@ Address for CLKSEL_TIMER7_CLK
	STR R0, [R1]			@ Select 32kHz clock

@ Set up GPIO1_31 for falling edge interrupt
	LDR R0, =0x4804C000		@ Base address for GPIO1 registers
	ADD R1, R0, #0x14C		@ FALLINGDETECT register offset
	MOV R2, #0x80000000		@ Load value for bit 31
	LDR R3, [R1]			@ Read FALLINGDETECT
	ORR R3, R3, R2			@ Enable/modify data
	STR R3, [R1]			@ Write back to FALLINGDETECT
	ADD R1, R0, #0x34		@ GPIO1_IRQSTATUS_SET_0 offset
	STR R2, [R1]			@ Enable GPIO1_31 request to POINTRPEND1

@ Initialize INTC
	LDR R1, =0x48200000		@ Base address for INTC
	MOV R2, #0x2			@ Value to reset INTC
	STR R2, [R1, #0x10]		@ Write to INTC_SYSCONFIG
	MOV R2, #0x04			@ Value to unmask INTC INT 98, GPIOINTA
	STR R2, [R1, #0xE8]		@ Unmask/write to INTC_MIR_CLEAR3
	MOV R2, #0x400			@ Value to unmask INTC INT 74, UART2
	STR R2, [R1, #0xC8]		@ Unmask/write to INTC_MIR_CLEAR2
	MOV R2, #0x80000000 		@ Value to unmask INTC INT 95, DMTIMER7
	STR R2, [R1, #0xC8]		@ Unmask/write to INTC_MIR_CLEAR2

@ Map UART2
	LDR R0, =0x44E10954		@ Address for CONF_SPI0_D0
	MOV R1, #0x11			@ Value for MODE1 and pull-up
	LDR R2, [R0]			@ Read CONF_SPI0_D0
	ORR R2, R2, R1			@ Modify
	STR R2, [R0]			@ Write to CONF_SPI0_D0

@ Initialize UART2 Baud rate, etc.
	LDR R0, =0x48024000		@ Base address for UART2
	MOV R1, #0x83			@ Value to switch to mode A and set 8-bit format
	STR R1, [R0, #0x0C]		@ Write to LCR
	MOV R1, #0x01			@ Value to write to DLH for 9.6kbps Baud
	STR R1, [R0, #0x04]		@ Write to DLH
	MOV R1, #0x38			@ Value to write to DLL for 9.6kbps Baud
	STR R1, [R0]			@ Write to DLL
	MOV R2, #0x00			@ Value to write to MDR1 for 16x UART mode
	STR R2, [R0, #0x20]		@ Write to MDR1
	MOV R1, #0x03			@ Value to switch back op mode w/o changing 8-bit
	STR R1, [R0, #0x0C]		@ Write to LCR
	STR R2, [R0, #0x08]		@ Disable FIFO

@ Initialize Timer7
	LDR R1, =0x4804A000		@ Base address for Timer7
	MOV R2, #0x1			@ Value to reset Timer7
	STR R2, [R1, #0x10]		@ Write to Timer7 TIOCP_CFG
	MOV R2, #0x2			@ Value to enable overflow interrupt
	STR R2, [R1, #0x2C]		@ Write to Timer7 IRQENABLE_SET
	LDR R2, =0xFFFFC000		@ Count value for 1 second delay
	STR R2, [R1, #0x40]		@ Timer7 TLDR load register (reload value)
	STR R2, [R1, #0x3C]		@ Write to Timer7 TCRR count register

@ Enable IRQ interrupt
	MRS R3, CPSR			@ Copy CPSR
	BIC R3, #0x80			@ Clear bit 7
	MSR CPSR_c, R3			@ Write to CPSR

@ Initialize counter
	MOV R0, #0x0			@ Set internalized counter to zero

@ Wait for interrupt
LOOP:	NOP
		B LOOP

@ Find source of interrupt and direct it to the correct procedure
INT_DIRECT:
	STMFD SP!, {R3, LR}		@ Save registers on stack
	LDR R2, =0x482000D8		@ Address for INTC_PENDING_IRQ2
	LDR R3, [R2]			@ Read INTC_PENDING_IRQ2
	TST R3, #0x00000400		@ Test bit 10
	BEQ TCHK			@ If bit 10 != 1 go to TCHK
	LDR R2, =0x48024008		@ Address of IIR_UART2
	LDR R3, [R2]			@ Read IIR_UART2
	TST R3, #0x00000001		@ Test bit 0
	BEQ TALKER_SVC			@ If bit 0 = 0 go to TALKER_SVC
	B RETURN			@ Else go to RETURN
TCHK:
	TST R3, #0x80000000		@ Test bit 31 in INTC_PENDING_IRQ2
	BEQ BCHK			@ If bit 31 != 1 go to BCHK
	LDR R2, =0x4804A028		@ Address for Timer7 IRQSTATUS
	LDR R3, [R2]			@ Read IRQSTATUS
	TST R3, #0x2			@ Test bit 1
	BNE TIMER7_SVC			@ If bit 1 = 1 go to TIMER7_SVC
	B RETURN			@ Else go to RETURN
BCHK:
	LDR R2, =0x482000F8		@ Address of INTC_PENDING_IRQ3
	LDR R3, [R2]			@ Read INTC_PENDING_IRQ3
	TST R3, #0x00000004		@ Test bit 2
	BEQ RETURN			@ If bit 2 = 0 go to RETURN
	LDR R2, =0x4804C02C		@ Address of GPIO1_IRQSTATUS_0
	LDR R3, [R2]			@ Read GPIO1_IRQSTATUS_0
	TST R3, #0x80000000		@ Test bit 31
	BNE BUTTON_SVC			@ If bit 31 = 1 go to BUTTON_SVC
	B RETURN			@ Else go to RETURN

@ Check for the button interrupt (if yes, enable UART2)
BUTTON_SVC:
	MOV R3, #0x80000000		@ Value for bit 31
	STR R3, [R2]			@ Disable IRQ for button
	MOV R3, #0x1			@ Value to turn off NEWIRQA
	LDR R2, =0x48200048		@ Address of INTC_CONTROL
	STR R3, [R2]			@ Write to disable NEWIRQA
	MOV R3, #0x2			@ Value to enable UART2 interrupt
	LDR R2, =0x48024004		@ Address of IER_UART2
	STR R3, [R2]			@ Enable UART2 interrupt
	LDR R2, =0x4804A038		@ Address of Timer7 TCLR
	MOV R3, #0x03			@ Value to enable Timer7 and auto-reload
	STR R3, [R2]			@ Write to TCLR
	LDMFD SP!, {R3, LR}		@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop

TIMER7_SVC:
	LDR R1, =0x4804A028		@ Address of Timer7 IRQSTATUS
	MOV R2, #0x2			@ Value to disable Timer7
	STR R2, [R1]			@ Write to disable
	LDR R1, =MESSAGE		@ Point to message
	CMP R0, #44			@ Compare counter to length of array
	BEQ COMP			@ If counter = length of array go to COMP
	LDR R1, =MESSAGE		@ Point to message
	LDRB R2, [R1, R0]!		@ Load 8-bit value from message
	LDR R1, =0x48024000		@ Address of THR_UART2
	STRB R2, [R1]			@ Write 8-bit value to THR_UART2
	ADD R0, R0, #1			@ Increment counter
	B RETURN
COMP:
	MOV R0, #0			@ Reset counter
	MOV R3, #0x2			@ Value to enable UART2 interrupt
	LDR R2, =0x48024004		@ Address of IER_UART2
	STR R3, [R2]			@ Enable UART2 interrupt
	B RETURN			@ Go to RETURN


@ UART procedure
TALKER_SVC:
	MOV R1, #NUM			@ Load array length
	SUBS R1, R1, R0			@ Update counter
	BEQ STOP			@ If R1 = 0 go to STOP
	LDR R1, =MESSAGE		@ Point to message
	LDRB R2, [R1, R0]!		@ Load 8-bit value from message
	LDR R1, =0x48024000		@ Address of THR_UART2
	STRB R2, [R1]			@ Write 8-bit value to THR_UART2
	ADD R0, R0, #1			@ Increment counter
	B RETURN
STOP:
	ADD R0, R0, #1			@ Increment counter
	MOV R4, #0x0			@ Value to disable UART2
	LDR R2, =0x48024004		@ Address of IER_UART2
	STR R4, [R2]			@ Write to disable UART2
	B RETURN			@ Go to RETURN

RETURN:
	LDR R2, =0x48200048		@ Address of INTC_CONTROL
	MOV R4, #0x01			@ Value to enable new IRQ interrupt
	STR R4, [R2]			@ Enable interrupt
	LDMFD SP!, {R3, LR}		@ Pop registers
	SUBS PC, LR, #4			@ Return to infinite loop

.data
.align 2
MESSAGE: 	.ascii "|"
			.byte 45
			.ascii "Ryan"
			.byte 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C
			.byte 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C
			.byte 254, 0x1C, 254, 0x1C, 254, 0x1C, 254, 0x1C
.align 2
STACK1:		.rept 1024
			.word 0x000
			.endr
STACK2:		.rept 1024
			.word 0x000
			.endr
.end
