

/*Linux kernel device driver code 
 * 
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <sys/mman.h>
       #include <sys/stat.h>
       #include <fcntl.h>
       #include <stdio.h>
       #include <stdlib.h>
       #include <unistd.h>

#define MAP_SIZE 16384UL
#define MAP_MASK (MAP_SIZE -1)

  #define handle_error(msg) \
           do { perror(msg); exit(EXIT_FAILURE); } while (0)

       int
       main()
       {

	  FILE *fp;

           void *mapped_base, *mapped_dev_base;
           int memfd;
           off_t dev_base=0x43C00000;
	   int i;
memfd = open("/dev/mem", O_RDWR | O_SYNC);
if(memfd==-1)
{ 
printf("can open /dev/mem");
exit(0);
}
printf("opened /dev/mem");
           size_t length;
           ssize_t s;
	

mapped_base = mmap(0, MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, memfd, dev_base & ~MAP_MASK);


if (mapped_base == (void*) -1)
{
    printf("mmap failure");
exit(0);
}

printf("mapped address  = %08x\n", mapped_base);
       
mapped_dev_base= mapped_base + (dev_base & MAP_MASK);
printf("entering value");
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
printf("first value");
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;
*((volatile unsigned int *) (mapped_dev_base + 0)) = 0x20273533;

*((volatile unsigned int *) (mapped_dev_base + 4)) = 0xffffffff;
*((volatile unsigned int *) (mapped_dev_base + 8)) = 0x33333333;


sleep(2);

unsigned int product= *(( volatile unsigned int *) (mapped_dev_base +4 ));
printf("product value");

while ( product != 1)
{
unsigned int product= *(( volatile unsigned int *) (mapped_dev_base +4 ));

}

for (i=0 ; i < 8 ; i++)
{
unsigned int product= *(( volatile unsigned int *) (mapped_dev_base +8 ));

printf("fft %d  %08x   \n" , i , product);
 
}



sleep(2);

dev_base= *(addr+1);         

           munmap(mapped_base, 4096);
           close(memfd);
fclose(fp);
printf(" product: %lu \n" , dev_base);
           //exit(EXIT_SUCCESS);
return 1;
       }


	
