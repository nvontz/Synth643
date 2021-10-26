#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <time.h>
#include <stdlib.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

/* globals */
#define BUF_SIZE 80000  // about 10 seconds of buffer (@ 8K samples/sec)
#define BUF_THRESHOLD 96 // 75% of 128 word buffers


int main() {

volatile int * audio_ptr = (int *) 0xFF203040; // audio port address
int fifospace;
int buffer_index = 0;
int BUF_SIZE = 
int left_buffer[BUF_SIZE];
int right_buffer[BUF_SIZE];

fifospace = *(audio_ptr + 1); // read the audio port fifospace register
if ( (fifospace & 0x000000FF) > 96) // check RARC, for > 75% full
{
/* store data until the audio-in FIFO is empty or the memory buffer is full */
while ( (fifospace & 0x000000FF) && (buffer_index < BUF_SIZE) )
{
left_buffer[buffer_index] = *(audio_ptr + 2); //Leftdata
right_buffer[buffer_index] = *(audio_ptr + 3); //Rightdata
++buffer_index;
fifospace = *(audio_ptr + 1); // read the audio port fifospace register
}
}


	return( 0 );
}


