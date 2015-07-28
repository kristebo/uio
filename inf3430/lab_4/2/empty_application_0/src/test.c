
// Located in: microblaze_0/include/xparameters.h
#include "xparameters.h"

#include "stdio.h"

#include "xbasic_types.h"
#include "xgpio.h"

//====================================================

int main (void) {
print("-- Entering main() --\r\n");

  u32 status;

	print("\r\nBlinking LEDs...\r\n");
	while(1)
    status = GpioOutputExample(XPAR_LEDS_8BIT_DEVICE_ID,8);

	return 1;
}

