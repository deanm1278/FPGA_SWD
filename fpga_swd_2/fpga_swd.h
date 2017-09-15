#ifndef LIB_FPGA_SWD_H
#define LIB_FPGA_SWD_H

#include <SPI.h>

#define ICESWD_DID 0x00
#define ICESWD_STATUS 0x01
#define ICESWD_ADDR_READ 0x02
#define ICESWD_LENGTH 0x03
#define ICESWD_CLKDIV 0x04
#define ICESWD_ADDR_WRITE 0x05

#define ICESWD_HW_ID_CODE 0x55

class ICESWD {
public:
  ICESWD(uint8_t cs, uint8_t reset) : _cs(cs), _reset(reset) {}
  ~ICESWD() {}

  bool begin()
  {
    pinMode (_reset, OUTPUT);
    digitalWrite(_reset, HIGH); //hold in reset
    pinMode (_cs, OUTPUT);
    digitalWrite(_cs, HIGH);
    
    // initialize SPI:
    SPI.begin();

    return true;
  }

  bool program(uint32_t readAddr, uint32_t writeAddr, uint32_t len, uint8_t clkdiv = 7){
    digitalWrite(_reset, LOW); //start

    if(readReg(ICESWD_DID) != 0x55){
      return false;
    }

    writeReg(ICESWD_ADDR_READ, readAddr);
    writeReg(ICESWD_ADDR_WRITE, writeAddr);
    writeReg(ICESWD_LENGTH, len);

    writeReg(ICESWD_CLKDIV, clkdiv);

    writeReg(ICESWD_STATUS, 1);

    return true;
  }

  uint32_t readReg(uint8_t reg)
  {
    digitalWrite(_cs, LOW);
    SPI.transfer(reg);
    SPI.transfer(0);
    SPI.transfer16(0);
    digitalWrite(_cs, HIGH);
    
    digitalWrite(_cs, LOW);
    //gives 24 bit output
    uint8_t b3 = SPI.transfer(0x01);
    uint8_t b2 = SPI.transfer(0x00);
    uint8_t b1 = SPI.transfer(0x00);
    digitalWrite(_cs, HIGH);
  
    uint32_t val = ((uint32_t)b3 << 16) | ((uint32_t)b2 << 8) | b1;
  
    return val;
  }

  void writeReg(uint8_t reg, uint32_t val)
  {
    uint8_t cmd = (1 << 3) | reg;
  
    uint8_t dHigh = (val >> 16) & 0xFF;
    uint16_t dLow = val & 0xFFFF;
  
    digitalWrite(_cs, LOW);
    SPI.transfer(cmd);
    SPI.transfer(dHigh);
    SPI.transfer16(dLow);
    digitalWrite(_cs, HIGH);
  }

private:
  uint8_t _cs, _reset;
};

#endif
