@ Pulsing LED Program
@ This program will pulse four LEDs on the Black Beagle Board
@ Uses R0-R10
@ Ryan Nand November 2019

.text
.global _start
_start:	

@ Initialize clocks for GPIOs
	MOV R0, #0x02				@ Value to enable clocks for GPIO
	LDR R1, =0x44E000AC			@ Address of GPIO1 clock control
	STR R0, [R1]				@ Store value to enable

@ Load addresses of base address for GPIOs being used
	LDR R0, =0x4804C000 			@ Base address for GPIO1

@ Initialize outputs to low before enabling them as outputs
	LDR R2, =0x01E00000 			@ LED bits
	ADD R3, R0, #0x190			@ GPIO1_CLEARDATAOUT
	STR R2, [R3]				@ Write to the address to clear

@ Enable needed outputs
	ADD R4, R0, #0x134 			@ GPIO1 enable address
	LDR R5, [R4]				@ Read current GPIO1 enable address
	LDR R6, =0xFE1FFFFF			@ Word to enable GPIO1 as output
	AND R5, R6, R5				@ Clear bits
	STR R5, [R4]				@ Write to GPIO1 enable address

@ Initialize counter values
	MOV R4, #10				@ Load counter for main program

@ Create main program loop
REPEAT:
							
@ Turn on LED0 and LED3
	ADD R5, R0, #0x194			@ GPIO1_SETDATAOUT
	LDR R2, =0x01200000 			@ LED0 and LED3
	STR R2, [R5]				@ Write to GPIO1 to turn on LED0
	
	LDR R9, =0x00FFFFFF 			@ Load value for delay counter
		
@ Create start of delay loop
DELAY:
 
	SUBS R9, R9, #1				@ Decrement counter
	BNE DELAY				@ Loop if not equal to zero
	
@ Turn LED0 and LED3 off
	STR R2, [R3]				@ Clear LED0
	
@ Turn on LED1 and LED2
	LDR R6, =0x00C00000			@ LED1 and LED2
	STR R6, [R5]				@ Write to set LED1 and LED2 

@ Reload the counter for delay	
	LDR R9, =0x00FFFFFF 			@ Load value for counter

@ Create second delay
DELAY2: 
	SUBS R9, R9, #1 			@ Decrement counter
	BNE DELAY2
	
@ Turn off LED1 and LED2
	STR R6, [R3]				@ Write to turn off LED1 and LED2
	SUBS R4, R4, #1				@ Decrement main program counter
	BNE REPEAT				@ Repeat main program if not equal to zero
	NOP

.end 


Part 2 code
Don’t forget to update startup


@ Pulsing LED Program with button
@ This program will pulse four LEDs on the Black Beagle Board
@ Uses R0-R10
@ Ryan Nand November 2019

.text
.global _start
.global INT_DIRECTOR
_start:	

@ Stack initializations
	LDR R13, =STACK1			@ point to base of STACK for SVC mode
	ADD R13, R13, #0x1000			@ Point to top of STACK
	CPS #0x12				@ Switch to IRQ mode
	LDR R13, =STACK2			@ Point to IRQ stack
	ADD R13, R13, #0x1000			@ Point to top of STACK
CPS #0x13					@ Back to SVC mode

@ Initialize GPIO1 clock
	MOV R0, #0x02				@ Value to enable clocks for GPIO
	LDR R1, =0x44E000AC			@ Address of GPIO1 clock control
	STR R0, [R1]				@ Store value to enable

@ Load addresses of base address for GPIOs being used
	LDR R0, =0x4804C000 			@ Base address for GPIO1	

@ Initialize GPIO1 outputs
	LDR R2, =0x01E00000 			@ LED bits
	ADD R3, R0, #0x190			@ GPIO1_CLEARDATAOUT
	STR R2, [R3]				@ Write to the address to clear
	ADD R4, R0, #0x134 			@ GPIO1 enable address
	LDR R5, [R4]				@ Read current GPIO1 enable address
	LDR R6, =0xFE1FFFFF			@ Word to enable GPIO1 as output
	AND R5, R6, R5				@ Clear bits
	STR R5, [R4]				@ Write to GPIO1 enable address

@ Initialize button at GPIO1_29
	ADD R1, R0, #0x14C			@ GPIO1_FALLINGDETECT
	MOV R2, #0x20000000			@ Bit GPIO1_29
	LDR R4, [R1]				@ Read GPIO1_FALLINGDETECT register
	ORR R4, R4, R2				@ Modify (set bit 29)
	STR R4, [R1]				@ Write to GPIO1_FALLINGDETECT register
	ADD R1, R0, #0x34			@ GPIO1_IRQSTATUS_SET_0 
	STR R2, [R1]				@ Enable GPIO1_29 request on POINTRPEND1

@ Initialize INTC
	LDR R1, =0x482000E8			@ INTC_MIR_CLEAR3
	MOV R2, #0x04				@ Value to unmask INTC INT 98, GPIOINT1A
	STR R2, [R1]				@ Write to INTC_MIR_CLEAR3

@ Processor IRQ enabled in CPSR
	MRS R2, CPSR				@ Copy CPSR to R2
	BIC R2, #0x80				@ Clear bit 7
	MSR CPSR_c, R2				@ Write to CPSR

@ Wait for initial button push
LOOP: 
	LDR R6, =0x000FFFFF 			@ Load value for delay counter
DELAY:
	SUBS R6, R6, #1				@ Decrement counter
	BNE DELAY				@ Loop if not equal to zero
	TST R0, #0x00000001			@ Test if LED rotation happens or not
	BEQ LOOP				@ If LEDs are off keep waiting

@ LED rotation procedure
ROTATE:
@ Make sure base address is loaded 
	LDR R1, =0x4804C000 			@ Base address for GPIO1	
	TST R0, #0x00000002 			@ Check bit 1
	BEQ ODD					@ Rotate based on current status
	@ Turn on LED0/LED3 and LED1/LED2 off
EVEN:
	ADD R4, R1, #0x190			@ GPIO1_CLEARDATAOUT
	ADD R3, R1, #0x194			@ GPIO1_SETDATAOUT
	LDR R2, =0x00C00000			@ LED1 and LED2
	STR R2, [R4]				@ Turn off LED1 and LED2
	LDR R2, =0x01200000 			@ LED0 and LED3
	STR R2, [R3]				@ Turn on LED0 and LED3
	MOV R0, #0x1				@ Value to switch LEDs from current status
	B LOOP					@ Repeat from top
	
	@ Turn off LED0/LED3 and LED1/LED2 on
ODD:
	ADD R4, R1, #0x190			@ GPIO1_CLEARDATAOUT
	ADD R3, R1, #0x194			@ GPIO1_SETDATAOUT
	LDR R2, =0x01200000 			@ LED0 and LED3
	STR R2, [R4]				@ Turn off LED1 and LED2
	LDR R2, =0x00C00000			@ LED1 and LED2
	STR R2, [R3]				@ Turn on LED0 and LED3
	MOV R0, #0x3				@ Value to switch LEDs from current status
	B LOOP					@ Repeat from top


@ INT_DIRECTOR procedure
INT_DIRECTOR: 
	STMFD SP!, {R1-R3, LR}			@ Push registers on stack
	LDR R3, =0x482000F8			@ INTC-PENDING_IRQ3
	LDR R1, [R3]				@ Read INTC-PENDING_IRQ3
	TST R1, #0x00000004			@ Test bit 2
	BEQ RETURN				@ Go back to initial wait loop
	LDR R3, =0x4804C02C			@ GPIO1_IRQSTATUS_0
	LDR R1, [R3]				@ Read status register
	TST R1, #0x20000000			@ Check bit GPIO1_29
	BNE BUTTON				@ If button pushed go to button procedure
	BEQ RETURN				@ If button not pushed return to initial wait loop

@ Return procedure
RETURN: 
	LDMFD SP!, {R1-R3, LR}			@ Pop back pushed registers
	SUBS PC, LR, #4				@ Return from interrupt to initial wait loop

@ Button procedure
BUTTON:
	MOV R1, #0x20000000			@ Bit GPIO1_29
	STR R1, [R3]				@ Write to GPIO1_IRQSTATUS_0
@ Turn off NEWIRQA bit in INTC_CONTROL
	LDR R3, =0x48200048			@ INTC_CONTROL
	MOV R1, #1				@ Value to clear bit
	STR R1, [R3]				@ Write to INTC_CONTROL
@ Update return parameter in R0
	TST R0, #0x00000001			@ Test bit to see if rotation is on/off
	BEQ ON					@ Update to turn LED rotation on
	B OFF					@ Update to turn LED rotation off

@ Update procedure for off
OFF: 
	LDR R1, =0x4804C000 			@ Base address for GPIO1	
	LDR R2, =0x01E00000 			@ LED bits
	ADD R3, R1, #0x190			@ GPIO1_CLEARDATAOUT
	STR R2, [R3]				@ Write to the address to clear
	MOV R0, #0				@ Value to start LED rotation
@ Return to initial wait loop
	B RETURN

@ Update procedure for on
ON: 
	MOV R0, #1				@ Value to start LED rotation
@ Return to initial wait loop
	B RETURN

.data
.align 2
STACK1:	.rept 1024
		.word 0x0000
		.endr
STACK2:	.rept 1024
		.word 0x0000
		.endr
.end

Part 3

@ Pulsing LED Program with button and timer 7
@ This program will pulse four LEDs on the Black Beagle Board
@ Uses R0-R10
@ Ryan Nand November 2019

.text
.global _start
.global INT_DIRECTOR
_start:	

@ Stack initializations
	LDR R13, =STACK1			@ point to base of STACK for SVC mode
	ADD R13, R13, #0x1000			@ Point to top of STACK
	CPS #0x12				@ Switch to IRQ mode
	LDR R13, =STACK2			@ Point to IRQ stack
	ADD R13, R13, #0x1000			@ Point to top of STACK
	CPS #0x13				@ Back to SVC mode

@ Initialize GPIO1 clock
	MOV R0, #0x02				@ Value to enable clocks for GPIO
	LDR R1, =0x44E000AC			@ Address of GPIO1 clock control
	STR R0, [R1]				@ Store value to enable

@ Load addresses of base address for GPIOs being used
	LDR R0, =0x4804C000 			@ Base address for GPIO1	

@ Initialize GPIO1 outputs
	LDR R2, =0x01E00000 			@ LED bits
	ADD R3, R0, #0x190			@ GPIO1_CLEARDATAOUT
	STR R2, [R3]				@ Write to the address to clear
	ADD R4, R0, #0x134 			@ GPIO1 enable address
	LDR R5, [R4]				@ Read current GPIO1 enable address
	LDR R6, =0xFE1FFFFF			@ Word to enable GPIO1 as output
	AND R5, R6, R5				@ Clear bits
	STR R5, [R4]				@ Write to GPIO1 enable address

@ Initialize button at GPIO1_29
	ADD R1, R0, #0x14C			@ GPIO1_FALLINGDETECT
	MOV R2, #0x20000000			@ Bit GPIO1_29
	LDR R4, [R1]				@ Read GPIO1_FALLINGDETECT register
	ORR R4, R4, R2				@ Modify (set bit 29)
	STR R4, [R1]				@ Write to GPIO1_FALLINGDETECT register
	ADD R1, R0, #0x34			@ GPIO1_IRQSTATUS_SET_0 
	STR R2, [R1]				@ Enable GPIO1_29 request on POINTRPEND1
@ Initialize INTC
	LDR R1, =0x48200000			@ INTC
	MOV R2, #0x2				@ Value to reset INTC
	STR R2, [R1, #0x10]			@ Write to INTC config
	MOV R2, #0x80000000			@ Unmask value for 95
	STR R2, [R1, #0xC8]			@ INTC_MIR_CLEAR2
	MOV R2, #0x04				@ Unmask value for 98
	STR R2, [R1, #0xE8]			@ INTC_MIR_CLEAR3
@ Turn on Timer7 clock
	MOV R2, #0x2				@ Value to enable timer 7 clock
	LDR R1, =0x44E0007C			@ CM_PER_TIMER7_CLKCTRL
	STR R2, [R1]				@ Write to CM_PER_TIMER7_CLKCTRL
	LDR R1, =0x44E00504			@ PRCMCLKSEL_TIMER7
	STR R2, [R1]				@ Select 32KHz clock
@ Initialize timer 7 registers
	LDR R1, =0x4804A000			@ Base address for timer 7
	MOV R2, #0x1				@ Value to reset timer 7
	STR R2, [R1, #0x10]			@ Write to timer 7 config register
	MOV R2, #0x2				@ Value to enable overflow interrupt
	STR R2, [R1, #0x2C]			@ Write to timer 7 IRQENABLE_SET
	LDR R2, =0xFFFF0000			@ Count value for 2 second delay
	STR R2, [R1, #0x40]			@ Timer 7 TLDR load register (reload value)
	STR R2, [R1, #0x3C]			@ Write to timer 7 TCRR count register

@ Processor IRQ enabled in CPSR
	MRS R2, CPSR				@ Copy CPSR to R2
	BIC R2, #0x80				@ Clear bit 7
	MSR CPSR_c, R2				@ Write to CPSR

@ Wait for initial button push
LOOP: 
TST R0, #0x00000004				@ Test if LED rotation happens or not
	BEQ LOOP				@ If LEDs are off

@ LED rotation procedure
ROTATE:
	TST R0, #0x1				@ Test bit 1
	BEQ LOOP
@ Make sure base address is loaded 
	LDR R1, =0x4804C000 			@ Base address for GPIO1	
	TST R0, #0x2 				@ Check bit 1
	BEQ ODD
	@ Turn on LED0/LED3 and LED1/LED2 off
EVEN:
	ADD R4, R1, #0x190			@ GPIO1_CLEARDATAOUT
	ADD R3, R1, #0x194			@ GPIO1_SETDATAOUT
	LDR R2, =0x00C00000			@ LED1 and LED2
	STR R2, [R4]				@ Turn off LED1 and LED2
	LDR R2, =0x01200000 			@ LED0 and LED3
	STR R2, [R3]				@ Turn on LED0 and LED3
	MOV R0, #0x4				@ Value to switch LEDs from current status
	B LOOP					@ Repeat from top
	
	@ Turn off LED0/LED3 and LED1/LED2 on
ODD:
	ADD R4, R1, #0x190			@ GPIO1_CLEARDATAOUT
	ADD R3, R1, #0x194			@ GPIO1_SETDATAOUT
	LDR R2, =0x01200000 			@ LED0 and LED3
	STR R2, [R4]				@ Turn off LED1 and LED2
	LDR R2, =0x00C00000			@ LED1 and LED2
	STR R2, [R3]				@ Turn on LED0 and LED3
	MOV R0, #0x6				@ Value to switch LEDs from current status
	B LOOP					@ Repeat from top

@ INT_DIRECTOR procedure
INT_DIRECTOR: 
	STMFD SP!, {R1-R3, LR}			@ Push registers on stack
	LDR R3, =0x482000F8			@ INTC-PENDING_IRQ3
	LDR R1, [R3]				@ Read INTC-PENDING_IRQ3
	TST R1, #0x00000004			@ Test bit 2
	BEQ TCHK				@ Go back to initial wait loop
	LDR R3, =0x4804C02C			@ GPIO1_IRQSTATUS_0
	LDR R1, [R3]				@ Read status register
	TST R1, #0x20000000			@ Check bit GPIO1_29
	BNE BUTTON				@ If button pushed go to button procedure
	BEQ RETURN				@ If button not pushed return to initial wait loop

@ Return procedure
RETURN: 
	LDR R2, =0x48200048			@ INTC_CONTROL
	MOV R1, #1				@ Value to clear bit
	STR R1, [R2]				@ Write to INTC_CONTROL
	LDMFD SP!, {R1-R3, LR}			@ Pop back pushed registers
	SUBS PC, LR, #4				@ Return from interrupt to initial wait loop

@ Timer interrupt check
TCHK:
	LDR R1, =0x482000D8			@ INTC_PENDING_IRQ2
	LDR R2, [R1]				@ Read value
	TST R2, #0x80000000			@ Check interrupt timer 7
	BEQ RETURN				@ No, then return
	LDR R1, =0x4804A028			@ Timer 7 IRQSTATUS
	LDR R2, [R1]				@ Read value
	TST R2, #0x2				@ Check bit 1
	BEQ RETURN
	TST R0, #0x2			 	@ Check bit 1
	BEQ SWITCH2
SWITCH:
	LDR R1, =0x11111111
	AND R0, R0, R1				@ Value to switch LEDs from current status
	LDR R1, =0x4804A028			@ Timer 7 IRQSTATUS
	MOV R2, #0x2				@ Value to reset timer 7 overflow
	STR R2, [R1]				@ Write
	B RETURN
SWITCH2:
	LDR R1, =0x11111110
	AND R0, R0, R1				@ Value to switch LEDs from current status
	LDR R1, =0x4804A028			@ Timer 7 IRQSTATUS
	MOV R2, #0x2				@ Value to reset timer 7 overflow
	STR R2, [R1]				@ Write
	B RETURN

@ Button procedure
BUTTON:
	MOV R1, #0x20000000			@ Bit GPIO1_29
	STR R1, [R3]				@ Write to GPIO1_IRQSTATUS_0
@ Turn off NEWIRQA bit in INTC_CONTROL
	LDR R3, =0x48200048			@ INTC_CONTROL
	MOV R1, #1				@ Value to clear bit
	STR R1, [R3]				@ Write to INTC_CONTROL
@ Update return parameter in R0
	TST R0, #0x00000004			@ Test bit to see if rotation is on/off
	BEQ ON					@ Update to turn LED rotation on
	B OFF					@ Update to turn LED rotation off

@ Update procedure for off
OFF: 
	LDR R1, =0x4804C000 			@ Base address for GPIO1	
	LDR R2, =0x01E00000 			@ LED bits
	ADD R3, R1, #0x190			@ GPIO1_CLEARDATAOUT
	STR R2, [R3]				@ Write to the address to clear
	AND R0, #0x0				@ Value to start LED rotation
@ Return to initial wait loop
	B RETURN

@ Update procedure for on
ON: 

	MOV R0, #0x4				@ Value to start LED rotation
@ Return to initial wait loop
	B RETURN

.data
.align 2
STACK1:	.rept 1024
		.word 0x0000
		.endr
STACK2:	.rept 1024
		.word 0x0000
		.endr
.end
