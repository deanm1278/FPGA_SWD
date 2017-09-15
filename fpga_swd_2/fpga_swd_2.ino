#include "Adafruit_DAP.h"
#include "fpga_swd.h"

#define SWDIO 8
#define SWCLK 9
#define SWRST 11

#define ICECS 10
#define ICERST 4

#define READ_ADDR 140288
#define WRITE_ADDR 0x00
#define LENGTH (186608 / 4)

//create a DAP for programming Atmel SAM devices
Adafruit_DAP_SAM dap;

ICESWD ice(10, 4);

// Function called when there's an SWD error
void error(const char *text) {
  Serial.println(text);
  while (1);
}


void setup() {
  pinMode(13, OUTPUT);
  Serial.begin(115200);
  while(!Serial) {
    delay(1);         // will pause the chip until it opens serial console
  }

  //init the fpga
  ice.begin();

  dap.begin(SWCLK, SWDIO, SWRST, &error);
  
  Serial.print("Connecting...");  
  if (! dap.dap_disconnect())                      error(dap.error_message);
  
  char debuggername[100];
  if (! dap.dap_get_debugger_info(debuggername))   error(dap.error_message);
  Serial.print(debuggername); Serial.print("\n\r");
  
  if (! dap.dap_connect())                         error(dap.error_message);
  
  if (! dap.dap_transfer_configure(0, 128, 128))   error(dap.error_message);
  if (! dap.dap_swd_configure(0))                  error(dap.error_message);
  if (! dap.dap_reset_link())                      error(dap.error_message);
  if (! dap.dap_swj_clock(50))               error(dap.error_message);
  dap.dap_target_prepare();

  uint32_t dsu_did;
  if (! dap.select(&dsu_did)) {
    Serial.print("Unknown device found 0x"); Serial.print(dsu_did, HEX);
    error("Unknown device found");
  }
  for (device_t *device = dap.devices; device->dsu_did > 0; device++) {
    if (device->dsu_did == dsu_did) {
      Serial.print("Found Target: ");
      Serial.print(device->name);
      Serial.print("\tFlash size: ");
      Serial.print(device->flash_size);
      Serial.print("\tFlash pages: ");
      Serial.println(device->n_pages);
      //Serial.print("Page size: "); Serial.println(device->flash_size / device->n_pages);
    }
  }
        
  Serial.println(" done.");

  Serial.print("Erasing... ");
  dap.erase();
  Serial.println(" done.");

  unsigned long t = millis();
  Serial.print("Programming... ");
  //program here
  pinMode(SWDIO, INPUT);
  pinMode(SWCLK, INPUT);
  
  if(!ice.program(READ_ADDR, WRITE_ADDR, LENGTH)){
    error("failed to communicate with ICESWD!");
  }

  //wait to finish
  while(ice.readReg(ICESWD_STATUS) != 0x03){
    delay(1);
  }
  
  ice.writeReg(ICESWD_STATUS, 0);

  pinMode(SWDIO, OUTPUT);
  pinMode(SWCLK, OUTPUT);

  Serial.print("\nDone!...");
  Serial.print( (LENGTH * 4) / (millis() - t) * 1000 );
  Serial.println(" b/s");
  dap.dap_set_clock(50);

  dap.deselect();
  dap.dap_disconnect();
}

void loop() {
  //blink led on the host to show we're done
  digitalWrite(13, HIGH);
  delay(500); 
  digitalWrite(13, LOW);
  delay(500);  
}
