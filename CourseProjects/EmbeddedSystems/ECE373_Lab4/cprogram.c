#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

int main(void){
	int fd, buff, msg = 4;

	fd = open("/dev/Ryans_module", O_RDWR);
	printf("\nfd = %d\n", fd);
	if(fd != -1){
		//Print to user that file has been accessed
		printf("/dev/Ryans_module opened with read/write access\n");
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
	}
	else {
		// Save error number
		int errsv = errno;
		// Print error message and value
		printf("\nSomething is wrong: %d\n", errsv);
	}
	return 0;
}
