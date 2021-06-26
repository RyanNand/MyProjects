/*
 * Ryan Nand
 * 4/20/2021
 * ECE 373
 *
 * My driver/module
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/uaccess.h>
#include <linux/pci.h>
#include <linux/init.h>
#include <linux/netdevice.h>

#define DEVCNT 5
#define DEVNAME "Ryans_module"

char my_driver_name[] = "my_cool_driver";

static struct mypci{
	struct pci_dev *pdev;
	void *hw_addr;
} mypci;

// Global struct for character device
static struct mydev_dev {
	struct cdev my_cdev;
	dev_t mydev_node;
	/* more stuff will go in here later... */
	u32 syscall_val;
} mydev;

/* this shows up under /sys/modules/Ryans_module/parameters */
static int exam = 42;
module_param(exam, int, S_IRUSR | S_IWUSR);

// Module open function
static int my_open(struct inode *inode, struct file *file){
	printk(KERN_INFO "successfully opened!\n");

	return 0;
}

// Userspace read function
static ssize_t my_read(struct file *file, char __user *buf, size_t len, loff_t *offset){
	/* Get a local kernel buffer set aside */
	int ret;

	if (*offset >= sizeof(int))
		return 0;

	/* Make sure our user wasn't bad... */
	if (!buf) {
		ret = -EINVAL;
		goto out;
	}
	
	// Read the register and store the data
	u32 temp;
        temp = readl(mypci.hw_addr + 0x00E00);
	mydev.syscall_val = temp;
	printk(KERN_INFO "The LED register is 0x%06x\n", mydev.syscall_val);

	if (copy_to_user(buf, &mydev.syscall_val, sizeof(int))) {
		ret = -EFAULT;
		goto out;
	}
	ret = sizeof(int);
	*offset += sizeof(int);


	/* Good to go, so printk the thingy */
	printk(KERN_INFO "User got from us 0x%x\n", mydev.syscall_val);

out:
	return ret;
}

// Userspace write function
static ssize_t my_write(struct file *file, const char __user *buf, size_t len, loff_t *offset){
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

	// Write data to register
	writel(mydev.syscall_val, mypci.hw_addr + 0x00E00);

	ret = len;

	/* print what userspace gave us */
	//Ryan - Pointer because changed kern_buf's type
	printk(KERN_INFO "Userspace wrote \"0x%x\" to us\n", *kern_buf);

mem_out:
	kfree(kern_buf);
out:
	return ret;
}

static int my_probe(struct pci_dev *pdev, const struct pci_device_id *ent){
	resource_size_t mmio_start, mmio_len;
	unsigned long bars; 
	int err;

	err = pci_enable_device_mem(pdev);
	if(err) return err;

	bars = pci_select_bars(pdev, IORESOURCE_MEM);
	printk(KERN_INFO "bar = %lx", bars);

	err = pci_request_selected_regions(pdev, bars, my_driver_name);
	if(err){
		pci_disable_device(pdev);
		return err;
}
	pci_set_master(pdev);

	mmio_start = pci_resource_start(pdev, 0);
	mmio_len = pci_resource_len(pdev, 0);

	mypci.hw_addr = ioremap(mmio_start, mmio_len);

	return 0;
}

//File operations for our device
static struct file_operations mydev_fops = {
	.owner 		= THIS_MODULE,
	.open 		= my_open,
	.read		= my_read,
	.write 		= my_write,
};

// PCI ID struct
static const struct pci_device_id my_pci_tbl[] = {
	{PCI_DEVICE(0x8086, 0x100e)},
	{} 		// terminate list
};
MODULE_DEVICE_TABLE(pci, my_pci_tbl);

// PCI remove function
static void my_remove(struct pci_dev *pdev){
	iounmap(mypci.hw_addr);
	pci_release_mem_regions(pdev);
	pci_disable_device(pdev);
}

// PCI device struct
static struct pci_driver my_driver = {
        .name           = my_driver_name,
        .id_table       = my_pci_tbl,
        .probe          = my_probe,
        .remove         = my_remove
};

// Module init function
static int __init my_init(void){
	printk(KERN_INFO "Ryan's module loading... exam=%d\n", exam);
        
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

	pci_register_driver(&my_driver);

	return 0;
}

// Module exit function
static void __exit my_exit(void){

	// PCI unregister
	pci_unregister_driver(&my_driver);

	/* destroy the cdev */
	cdev_del(&mydev.my_cdev);

	/* clean up the devices */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);

	printk(KERN_INFO "homework2 module unloaded!\n");
}

MODULE_AUTHOR("Ryan Nand");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(my_init);
module_exit(my_exit);
