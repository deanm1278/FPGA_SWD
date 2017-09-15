package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.SPIFastRead
import org.scalatest.Matchers
import scala.util.Random

class SPIFastReadUnitTester(c: SPIFastRead) extends PeekPokeTester(c) {

  val r = Random
  val addr = r.nextInt(1<<24 - 1)
  val data = r.nextInt(1<<24 - 1) //data that will be sent
  var miso = data
  poke(c.io.EN, 0)
  poke(c.io.ADDR, addr)

  step(4)
  poke(c.io.EN, 1)

  var i = 0
  var received = 0
  for(k <- 0 until 500){
    if(peek(c.io.SCK_RISING) == 1){
      //shift in data on the rising edge of SCK
      received = (received << 1) | (if (peek(c.io.MOSI) ==1 ) 1 else 0)
      i = i + 1

      //first byte should be fast read command
      if(i == 8){ expect(received == 0x0B, s"expected cmd 11, received $received") }

      //next 24 bytes should be the address
      if(i == 32){
        val a = (received & 0xFFFFFF)
        expect(a == addr, s"expected addr $addr, got $a")
      }

      //after 8 cycles the flash chip will start shifting out data
      if(i > (32 + 8)){
        val miso_bit = ((miso & 0x80000000) >> 31) & 0x01
        poke(c.io.MISO, miso_bit)
        miso = (miso << 1)
      }

      //module asserts DATA_READY when it's received 32 bytes
      if(peek(c.io.DATA_READY) == 1){
        expect(c.io.DATA, data)
      }
    }

    step(1)
  }
}

class SPIFastReadTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "SPIFastRead" should s"fast read out from an SPI flash chip (with $backendName)" in {
      Driver(() => new SPIFastRead(), backendName) {
        c => new SPIFastReadUnitTester(c)
      } should be (true)
    }
  }
}