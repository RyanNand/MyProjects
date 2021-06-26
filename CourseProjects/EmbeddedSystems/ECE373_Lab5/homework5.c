/*******************************************************************************
 * Program: homework5.c
 * Author: Ryan Nand
 * Date: 6/2/2021
 * Description: A userspace driver to control the LEDs in the 82575eb network
 *              device. 
 ******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <getopt.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <pci/pci.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>
#include <linux/types.h>
#include <errno.h>
#include <time.h>

#define IFNAMSIZ 16

#define MEM_WINDOW_SZ  0x00010000

/* LED Control */
#define E1000_LEDCTL	0x00E00	/* LED Control - RW */

// Global variables
volatile void *e1000e_mem;
char *portname;
char *pci_bus_slot;

/* map the network device into our memory space */
int open_dev(off_t base_addr, volatile void **mem)
{
	int fd;

	fd = open("/dev/mem", O_RDWR);
	if (fd < 0) {
		perror("open");
		return -1;
	}

	*mem = mmap(NULL, MEM_WINDOW_SZ, (PROT_READ|PROT_WRITE), MAP_SHARED, fd,
			base_addr);
	if (*mem == MAP_FAILED) {
		perror("mmap/readable - try rebooting with iomem=relaxed");
		close(fd);
		return -1;
	}

	return fd;
}

/* write to a device register */
void ew32(u32 reg, u32 value)
{
	u32 *p = (u32 *)(e1000e_mem + reg);
	*p = value;
}

/* read from a device register */
u32 er32(u32 reg)
{
	u32 *p = (u32 *)(e1000e_mem + reg);
	u32 v = *p;
	return v;
}

/* print a simple ASCII representation of the 4 LEDs */
void homework5()
{
	u32 ledctl, temp, saved;
	time_t start, now, diff;
	int on_off = 0;

	ledctl = er32(E1000_LEDCTL);
	
	// Save original contents of register
	saved = ledctl;

	printf("Initial LED control register value: %x\n", ledctl);

	// Turn on LED2 and LED0 and turn off LED1
	temp = ledctl & 0xFFF0F0F0;
	temp = temp | 0xE0E0E;

	// Write into control register
	ew32(E1000_LEDCTL, temp);

	// Wait 2 seconds
	time(&start);
	while(diff != 2){
		time(&now);
		diff = difftime(now, start);
	}
	
	// Turn all off
	ledctl = er32(E1000_LEDCTL);
	temp = ledctl & 0xFFF0F0F0;
        temp = temp | 0xF0E0F;
	// Write to register
	ew32(E1000_LEDCTL, temp);

	// Wait 1 second
	diff = 0;
        time(&start);
        while(diff != 2){
                time(&now);
                diff = difftime(now, start);
        }

	// Looping 5 times though the LEDs turning them on/off
	for(int z = 0; z < 10; z++){
		ledctl = er32(E1000_LEDCTL);
		temp = ledctl & 0xFFF0F0F0;
		if(on_off == 0){
			//Turn on all LEDs
			temp = temp | 0xE0F0E;
			ew32(E1000_LEDCTL, temp);
			on_off = 1;
		}
		else{
			// Turn off all LEDs
			temp = temp | 0xF0E0F;
			ew32(E1000_LEDCTL, temp);
			on_off = 0;
		}
		time(&start);
		diff = 0;
		while(diff != 1){
			time(&now);
			diff = difftime(now, start);
		}
	}

	// Restore initial value
	ew32(E1000_LEDCTL, saved);

	// Read LED control register
        ledctl = er32(E1000_LEDCTL);
        // Print to user the contents of the register
        printf("LED control register after run through: %x\n", ledctl);

	temp = er32(0x04074);
	printf("The contents of the Good Packets Received: %x\n\n", temp);

}

int main(int argc, char **argv)
{
	int dev_mem_fd;
	char buf[128] = { 0 };
	char pci_entry[128] = { 0 };
	char addr_str[10] = { 0 };
	off_t base_addr;
	FILE *input;
	int ret = 0;
	int len;

	pci_bus_slot = "00:03.0";

	/* Does pci device specified by the user exist? */
	snprintf(buf, sizeof(buf), "lspci -s %s", pci_bus_slot);
	input = popen(buf, "r");
	if (!input) {
		perror(pci_bus_slot);
		exit(1);
	}

	fgets(pci_entry, sizeof(pci_entry), input);
	fclose(input);
	len = strlen(pci_entry);
	if (len <= 1) {
		fprintf(stderr, "%s not found\n", pci_bus_slot);
		exit(1);
	}

	/* Let's make sure this is an Intel ethernet device.  A better
	 * way for doing this would be to look at the vendorId and the
	 * deviceId, but we're too lazy to find all the deviceIds that
	 * will work here, so we'll live a little dangerously and just
	 * be sure it is an Intel device according to the description.
	 * Oh, and this is exactly how programmers get into trouble.
	 */
	if (!strstr(pci_entry, "Ethernet controller") ||
	    !strstr(pci_entry, "Intel")) {
		fprintf(stderr, "%s wrong pci device\n", pci_entry);
		exit(1);
	}

	/* Only grab the first memory bar */
	snprintf(buf, sizeof(buf),
		 "lspci -s %s -v | awk '/Memory at/ { print $3 }' | head -1",
		 pci_bus_slot);
	input = popen(buf, "r");
	if (!input) {
		printf("%s\n", buf);
		perror("getting device mem info");
		exit(1);
	}
	fgets(addr_str, sizeof(addr_str), input);
	fclose(input);

        base_addr = strtol(addr_str, NULL, 16);
        if (len <= 1) {
                fprintf(stderr, "%s memory address invalid\n", addr_str);
                exit(1);
        }

	/* open and read memory */
	dev_mem_fd = open_dev(base_addr, &e1000e_mem);
	if (dev_mem_fd >= 0 && e1000e_mem) {
		homework5();
	}

	close(dev_mem_fd);
	munmap((void *)e1000e_mem, MEM_WINDOW_SZ);

	return ret;
}
