#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>

int main(void){
	int fd, buff, msg = 50;

	fd = open("/dev/homework2", O_RDWR);
	printf("\nfd = %d\n", fd);
	if(fd != -1){
		//Print to user that file has been accessed
		printf("/dev/homework2 opened with read/write access\n");
		// Read initial value in kernel variable
		read(fd, &buff, sizeof(msg));
		// Print initial value in kernel variable
                printf("Read the following: %d\n", buff);
		// Notifiy user that a write operation is happening
		printf("Writing the following: %d\n", msg);
		// Write new value into variable in the kernel
		write(fd, &msg, sizeof(msg));
		// Close file
		close(fd);
		// Open file 
		fd = open("/dev/homework2", O_RDWR);
		// Read the written value back from kernel
		read(fd, &buff, sizeof(msg));
		// Print the written value back from kernel to user
		printf("Read the following on second read: %d\n\n", buff);
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
