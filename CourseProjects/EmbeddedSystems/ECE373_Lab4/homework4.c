/*
 * Ryan Nand
 * 5/16/2021
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
#include <linux/timer.h>

#define DEVCNT 5
#define DEVNAME "Ryans_module"

char my_driver_name[] = "my_cool_driver";

static struct class *my_class;

// Global struct for PCI device
static struct mypci{
	struct pci_dev *pdev;
	void *hw_addr;
} mypci;

// Timer struct
static struct my_timer_struct{
	int foo;
	unsigned long jiff;
	struct timer_list my_timer;
} my_str;

// Global struct for character device
static struct mydev_dev {
	struct cdev my_cdev;
	dev_t mydev_node;
	/* more stuff will go in here later... */
	int syscall_val;
	u32 temp;
	int on_off;
} mydev;

/* this shows up under /sys/modules/homework4/parameters */
static int blink_rate = 2;
module_param(blink_rate, int, S_IRUSR | S_IWUSR);

// Timer callback function
static void my_timer_cb(struct timer_list *t){

        struct my_timer_struct *val = from_timer(val, t, my_timer);

 //       printk(KERN_INFO "blink_rate = %u elasped time = %lu\n", val->foo, (jiffies - val->jiff));

        // Update/change data
	val->foo = blink_rate;
        val->jiff = jiffies;
        mydev.temp = readl(mypci.hw_addr + 0x00E00);
        if(mydev.on_off == 0){
                mydev.temp = mydev.temp & 0xFFFFFFF0;
                mydev.temp = mydev.temp | 0xE;
                writel(mydev.temp, mypci.hw_addr + 0x00E00);
                mydev.on_off = 1;
        }
        else{
                mydev.temp = mydev.temp & 0xFFFFFFF0;
                mydev.temp = mydev.temp | 0xF;
                writel(mydev.temp, mypci.hw_addr + 0x00E00);
                mydev.on_off = 0;;
}
        // Restart timer
        mod_timer(&my_str.my_timer, (jiffies + (1 * HZ)/val->foo));
}

// Userspace open function
static int my_open(struct inode *inode, struct file *file){
	printk(KERN_INFO "successfully opened!\n");

	printk(KERN_INFO "Timer has started, HZ = %d, blink_rate = %d, syscall_val = %d\n", HZ, blink_rate, mydev.syscall_val);

	if(mydev.syscall_val > 0){
		blink_rate = mydev.syscall_val;
	}

	timer_setup(&my_str.my_timer, my_timer_cb, 0);

        mod_timer(&my_str.my_timer, (jiffies + (1 * HZ)/blink_rate));

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
	
	// Read the blink_rate
	mydev.syscall_val = blink_rate;

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

	// Update blink_rate
	if(mydev.syscall_val > 0){
		printk("syscall_val changed to %d", mydev.syscall_val);
		blink_rate = mydev.syscall_val;
		printk("The blink rate is now: %d", blink_rate);
	}
	else if(mydev.syscall_val == 0){
		printk("Zero will not change the current blink rate.");
	}		
	else {
		ret = -EINVAL;
		goto mem_out;
	}

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
	printk(KERN_INFO "Ryan's module loading... blink_rate=%d\n", blink_rate);
        
	//Ryan - Moved variable initialization from open to init
	mydev.syscall_val = blink_rate;
	mydev.on_off = 0;

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

	// Now instantiate the device class hierarchy and create the device
	my_class = class_create(THIS_MODULE, DEVNAME);
	device_create(my_class, NULL, mydev.mydev_node, NULL, DEVNAME);
	printk(KERN_INFO "Device file was created: /dev/%s with major: %d and minor: %d\n", DEVNAME, 
		MAJOR(mydev.mydev_node), MINOR(mydev.mydev_node));

	pci_register_driver(&my_driver);

	return 0;
}

// Module exit function
static void __exit my_exit(void){

	del_timer_sync(&my_str.my_timer);

	// PCI unregister
	pci_unregister_driver(&my_driver);

	// Destroy the dev entry and device class
	device_destroy(my_class, mydev.mydev_node);
	class_destroy(my_class);

	/* destroy the cdev */
	cdev_del(&mydev.my_cdev);

	/* clean up the devices */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);

	printk(KERN_INFO "Ryans module unloaded!\n");
}

MODULE_AUTHOR("Ryan Nand");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(my_init);
module_exit(my_exit);
