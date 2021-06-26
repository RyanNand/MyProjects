#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <stdint.h>

int main(void){
	uint32_t fd, buff, msg;

	fd = open("/dev/homework3", O_RDWR);
	printf("\nfd = %d\n", fd);
	if(fd != -1){
		//Print to user that file has been accessed
		printf("/dev/homework3 opened with read/write access\n");

		// Read initial value in kernel variable (aka LEDCTL register value)
		read(fd, &buff, sizeof(msg));

		// Print initial value in kernel variable
                printf("1st read: LEDCTL register: 0x%x\n", buff);
		
		// Perform RMW (read, modify, and write)		
		// Mask the upper bits (excluding bits 3:0)
		msg = buff & 0xFFFFFFF0;

		// Update value to write back (bits 3:0)
		msg = msg | 0xE; 

		// Notifiy user that a write operation is happening
		printf("Writing the following to the LEDCTL register: 0x%x\n", msg);
		
		// Write new value into variable in the kernel
		write(fd, &msg, sizeof(msg));

		// Close file
		close(fd);
		
		// Open file 
		fd = open("/dev/homework3", O_RDWR);

		// Read value in kernel variable after updated (aka LEDCTL register value)
		read(fd, &buff, sizeof(msg));

		// Print initial value in kernel variable
                printf("2nd read: LEDCTL register: 0x%x\n", buff);

		// Delay 2 seconds while LED is on
		sleep(2);
				
		// Perform RMW (read, modify, and write)		
		// Mask the upper bits (excluding bits 3:0)
		msg = buff & 0xFFFFFFF0;

		// Update value to write back (bits 3:0)
		msg = msg | 0xF; 

		// Notifiy user that a write operation is happening
		printf("Writing the following to the LEDCTL register: 0x%x\n", msg);

		// Write new value into variable in the kernel
		write(fd, &msg, sizeof(msg));

		// Close file
		close(fd);
	}
	else {
		// Save error number
		int errsv = errno;
		// Print error message and value
		printf("\nSomething is wrong: %d\n", errsv);
	}
	return 0;
}
