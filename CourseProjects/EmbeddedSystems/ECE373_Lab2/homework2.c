/*
 * Ryan Nand
 * 4/20/2021
 * ECE 373
 *
 * Homework 2: Give stuff to the driver, get stuff from the driver
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>

#define DEVCNT 5
#define DEVNAME "homework2"

static struct mydev_dev {
	struct cdev my_cdev;
	dev_t mydev_node;
	/* more stuff will go in here later... */
	int syscall_val;
} mydev;

/* this shows up under /sys/modules/example5/parameters */
static int exam = 42;
module_param(exam, int, S_IRUSR | S_IWUSR);


static int homework2_open(struct inode *inode, struct file *file)
{
	printk(KERN_INFO "successfully opened!\n");

	return 0;
}

static ssize_t homework2_read(struct file *file, char __user *buf,
                             size_t len, loff_t *offset)
{
	/* Get a local kernel buffer set aside */
	int ret;

	if (*offset >= sizeof(int))
		return 0;

	/* Make sure our user wasn't bad... */
	if (!buf) {
		ret = -EINVAL;
		goto out;
	}

	if (copy_to_user(buf, &mydev.syscall_val, sizeof(int))) {
		ret = -EFAULT;
		goto out;
	}
	ret = sizeof(int);
	*offset += sizeof(int);


	/* Good to go, so printk the thingy */
	printk(KERN_INFO "User got from us %d\n", mydev.syscall_val);

out:
	return ret;
}

static ssize_t homework2_write(struct file *file, const char __user *buf,
                              size_t len, loff_t *offset)
{
	/* Have local kernel memory ready */
	int *kern_buf;
	int ret;

	/* Make sure our user isn't bad... */
	if (!buf) {
		ret = -EINVAL;
		goto out;
	}

	/* Get some memory to copy into... */
	kern_buf = kmalloc(len, GFP_KERNEL);

	/* ...and make sure it's good to go */
	if (!kern_buf) {
		ret = -ENOMEM;
		goto out;
	}

	/* Copy from the user-provided buffer */
	if (copy_from_user(kern_buf, buf, len)) {
		/* uh-oh... */
		ret = -EFAULT;
		goto mem_out;
	}
	
	//Ryan - update syscall_val variable
	mydev.syscall_val = *kern_buf;
	ret = len;

	/* print what userspace gave us */
	//Ryan - Pointer because changed kern_buf's type
	printk(KERN_INFO "Userspace wrote \"%d\" to us\n", *kern_buf);

mem_out:
	kfree(kern_buf);
out:
	return ret;
}

/* File operations for our device */
static struct file_operations mydev_fops = {
	.owner = THIS_MODULE,
	.open = homework2_open,
	.read = homework2_read,
	.write = homework2_write,
};

static int __init homework2_init(void)
{
	printk(KERN_INFO "homework2 module loading... exam=%d\n", exam);
        
	//Ryan - Moved variable initialization from open to init
	mydev.syscall_val = exam;

	if (alloc_chrdev_region(&mydev.mydev_node, 0, DEVCNT, DEVNAME)) {
		printk(KERN_ERR "alloc_chrdev_region() failed!\n");
		return -1;
	}

	printk(KERN_INFO "Allocated %d devices at major: %d\n", DEVCNT,
	       MAJOR(mydev.mydev_node));

	/* Initialize the character device and add it to the kernel */
	cdev_init(&mydev.my_cdev, &mydev_fops);
	mydev.my_cdev.owner = THIS_MODULE;

	if (cdev_add(&mydev.my_cdev, mydev.mydev_node, DEVCNT)) {
		printk(KERN_ERR "cdev_add() failed!\n");
		/* clean up chrdev allocation */
		unregister_chrdev_region(mydev.mydev_node, DEVCNT);

		return -1;
	}

	return 0;
}

static void __exit homework2_exit(void)
{
	/* destroy the cdev */
	cdev_del(&mydev.my_cdev);

	/* clean up the devices */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);

	printk(KERN_INFO "homework2 module unloaded!\n");
}

MODULE_AUTHOR("Ryan Nand");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(homework2_init);
module_exit(homework2_exit);
