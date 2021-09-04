/*Program: I2C Startup
* Description: Program will startup the I2C2 peripheral on the B3 and send the slave address
* (0x60). The transmission will end and enter an endless loop after the slave address is
* transmitted. The purpose of this program is to test the procedure of I2C on the B3 with a
* logic analyzer. No external pull-up resistor needed.
* Ports/Pins: I2C2 is using pin 19 (SCL) and pin 20 (SDA) on port 9 (P9)
* Date: 02/28/2021
* Author: Ryan Nand
*/

    //Defines section
    #define HWREG(x) (*((volatile unsigned int *) (x))) //Variable to access registers

    //Base addresses
    #define I2C2 0x4819C000 //I2C2 module base address
    #define CONF 0x44E10000 //Control module base address

    //Direct addresses
    #define I2C2_CON 0x4819C0A4 //I2C2 configure register address

    // Single use registers and register offsets
    /* I2C2 clock module address: CM_PER_I2C2_CLKCTRL 0x44E00044
    * Register for port 9 pin 19: MODE0: uart1_rtsn (offset: 0x97C) -> MODE3: I2C2_SCL
    * Register for port 9 pin 20: MODE0: uart1_ctsn (offset: 0x978) -> MODE3: I2C2_SDA
    * I2C clock prescaler register: I2C_PSC (offset: 0xB0)
    * I2C low time register: I2C_SCLL (offset: 0xB4)
    * I2C high time register: I2C_SCLH (offset: 0xB8)
    * I2C own address register: I2C_OA (offset: 0xA8)
    * I2C slave address register: I2C_SA (offset: 0xAC)
    * I2C status register: I2C_IRQSTATUS_RAW (offset: 0x24)
    */

    /**SCLL and SCLH**/
    /* 50% duty cycle at 400kbps and 12MHz clock
    * 1 / (400 * 10^3) => divide by 2 for 50% duty cycle => 1.25 microseconds = tLOW = tHIGH
    * tLOW = (SCLL + 7) * ICLK
    * tHIGH = (SCLH + 5) * ICLK
    */

    // Global variables
    int SCLL = 0x8, SCLH = 0xA;
    // Own address
    int OA = 0x40;
    // Slave address
    int SA = 0x60;
    // Ex: 48Mhz default I2C clock, need 12MHz
    // Prescale divider = (PSC + 1)
    int PSC = 3;

int main(void)
{
    HWREG(0x44E00044) = 0x0;                  // Reset I2C2 clock

    //Local variable
    int POLL = 1;

    // Map I2C2
    HWREG(CONF + 0x97C) = 0x33;               // Configure MODE3/pull-up for I2C2_SCL pin 19
    HWREG(CONF + 0x978) = 0x33;               // Configure MODE3/pull-up for I2C2_SDA pin 20

    // Initialize I2C2 clock
    HWREG(0x44E00044) = 0x2;                  // Enable I2C2 clock

    // Configure I2C2 module
    HWREG(I2C2 + 0xB0) = PSC;                 // Set prescale divisor to 4 for ICLK = 12MHz
    HWREG(I2C2 + 0xB4) = SCLL;                // Set SCLL for 1.25 microseconds low time
    HWREG(I2C2 + 0xB8) = SCLH;                // Set SCLH for 1.25 microseconds high time
    //HWREG(I2C2 + 0xA8) = OA;                // Set own I2C address to chosen value

    // Initialize I2C2
    HWREG(I2C2_CON) = 0x8600;                 // Set device to master transmitter

    // Configure slave address and DATA counter
    HWREG(I2C2 + 0xAC) = SA;                  // Set slave address
    HWREG(I2C2 + 0x98) = 1;                   // Set DATA counter
    //while loop
    while(1){
        // Poll busy bit (bit 12) to see if I2C line is busy
        while(POLL == 1){                     // Keep polling if bit 12 set
            // Check bit 12 in status register
            if((HWREG(I2C2 + 0x24) & 0x1000) == 0x1000){
                POLL = 1;                     // Keep polling
            }
            else{                             // Continue program if bit is not set
                POLL = 0;                     // Leave polling loop
            }
        }
        // Initiate a transfer
        HWREG(I2C2_CON) = 0x8603;             // Set STT & STP for I2C activity: S-A-D..(n)..D-P
        HWREG(I2C2 + 0x98) = 1;               // Set DATA counter
        // Poll XRDY (bit 4) to see if I2C is ready for data
        while(POLL == 0){                     // Keep polling if bit 4 is not set
            // Check bit 4 in status register
            if((HWREG(I2C2 + 0x24) & 0x10) == 0x10){
                POLL = 1;                     // Leave polling because bit 4 is set
                //HWREG(I2C2 + 0x24) = 0x10;  // Reset bit 4 to zero
                HWREG(I2C2 + 0x9C) = 0xCC;    // Enter data into data buffer
            }
            else{                             // Keep polling if bit 4 is not set
                POLL = 0;                     // Continue polling
            }
        }

    }
}
