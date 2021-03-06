/*Program: I2C Step Motor Control
* Description: Program will use the I2C2 peripheral on the B3 to control a stepper motor.
* Ports/Pins: I2C2 is using pin 19 (SCL) and pin 20 (SDA) on port 9 (P9)
* Date: 03/20/2021
* Author: Ryan Nand
*/

//Defines section
#define HWREG(x) (*((volatile unsigned int *)(x)))
// Base registers for peripherals
#define CM_PER 0x44E00000
#define I2C2 0x4819C000
#define CONF 0x44E10000
#define INTC 0x48200000
#define I2C2_CON 0x4819C0A4

// Function declarations
void I2C2_SVC();
void DELAY();
// I2C2 variables
int SCLL = 0x8, SCLH = 0xA, SA = 0x60, PSC = 3;
// Data variables
int i = 1, init = 1, count = 1, count2 = 1;
// Data to be transferred
int DATA[16] = {0x1B, 0x00, 0x1F, 0x10, 0x17, 0x00, 0x13, 0x10, 0x1F, 0x00, 0x1B, 0x10, 0x13, 0x00, 0x17, 0x10};
int INIT[20] = {0x00, 0x11, 0xFE, 0x05, 0x00, 0x00, 0x00, 0x81, 0x01, 0x04, 0xFD, 0x00, 0x0F, 0x10, 0x23, 0x10, 0x17, 0x10, 0x1B, 0x10};
// Stack variables
volatile unsigned int USR_STACK[100];
volatile unsigned int INT_STACK[100];

int main(void){
    // Set up stacks
    asm("LDR R13, =USR_STACK");        // Initialize USR stack
    asm("ADD R13, R13, #0x100");
    // Initialize IRQ stack
    asm("CPS #0x12");
    asm("LDR R13, =INT_STACK");
    asm("ADD R13, R13, #0x100");
    asm("CPS #0x13");
    // Initialize clocks
    HWREG(CM_PER + 0x44) = 0x2;        // Initialize I2C2 clock
    // Initialize INTC
    HWREG(INTC + 0x10) = 0x2;          // Reset INTC
    HWREG(INTC + 0x88) = 0x40000000;   // Unmask INT 30-I2C2
    // Map I2C2
    HWREG(CONF + 0x97C) = 0x33;        // Configure MODE3/pull-up for I2C2_SCL pin 19 PORT P9
    HWREG(CONF + 0x978) = 0x33;        // Configure MODE3/pull-up for I2C2_SDA pin 20 PORT P9
    // Configure I2C2 module
    HWREG(I2C2 + 0xB0) = PSC;
    HWREG(I2C2 + 0xB4) = SCLL;
    HWREG(I2C2 + 0xB8) = SCLH;
    // Initialize I2C2
    HWREG(I2C2_CON) = 0x8600;
    // Input slave address
    HWREG(I2C2 + 0xAC) = SA;
    for(int j = 0; j <= 1000000; j++){
        // Delay loop
        asm("NOP");
    }
while(1){
    // Number of data bytes to transfer
    HWREG(I2C2 + 0x98) = 2;
    // Initiate I2C transfer
    HWREG(I2C2_CON) = 0x8603;
    // Loop to transfer data over I2C
    while(count < 3){
        // Poll XRDY flag
        while((HWREG(I2C2 + 0x24) & 0x10) != 0x10){
            // Polling XRDY flag
        }
        // Write data to data register
        I2C2_SVC();                    // Select correct data and transfer
        count2++;                      // Counter for shutdown fault
    }
    // Counter for switching data arrays
    count = 1;                         // Switch between data or init array
    DELAY();                           // Delay loop
    // Switch back init - fault in circuitry
    if(count2 >= 40){
        count2 = 1;                    // Variable to switch back to init array
        init = 1;                      // Switch to init data
        i = 1;                         // Go back to first index
    }
}
    // End of program
    return 0;
}
// Delay loop
void DELAY(void){
    // I2C transmission is over
    for(int k = 0; k <= 300000; k++){
        // Delay loop
        asm("NOP");                    // Do nothing
    }
}
// Select data and write to data register
void I2C2_SVC(void){
    // Select init array
    if(init == 1){
        // Write init data to data register
        HWREG(I2C2 + 0x9C) = INIT[i-1];
        // If reached end of array switch to DATA array
        if(i == 20){
            i = 1;                     // Go to first index
            init = 2;                  // Switch to DATA array
        }
        // Keep indexing if end of array not reached
        else i++;                      // Increment index
    }
    // Select DATA array
    else{
        // Write DATA array to data register
        HWREG(I2C2 + 0x9C) = DATA[i-1];
        // If reached end of array, loop back to the beginning of DATA array
        if(i == 16){
            i = 1;                     // Go back to first index
        }
        // Keep indexing if end of array not reached
        else i++;
    }
    // Increment data counter
    count++;
}
