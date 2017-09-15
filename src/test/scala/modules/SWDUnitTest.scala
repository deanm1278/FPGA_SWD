package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.SWD
import org.scalatest.Matchers
import scala.util.Random

class SWDUnitTester(c: SWD) extends PeekPokeTester(c) {
  var r = Random
  poke(c.io.APnDP, 1)
  poke(c.io.A, 2)
  poke(c.io.CLKDIV, 0)
  poke(c.io.DATA_READY, 0)
  poke(c.io.EN, 0)

  step(10)
  poke(c.io.DATA_READY, 1)
  poke(c.io.EN, 1)
  poke(c.io.D_IN_0, 0)

  val data = r.nextInt(1 << 24)
  poke(c.io.DATA, data)

  var received = 0
  var bitcount = 0
  var parity = false

  for(k <- 0 until 120){
    if(peek(c.io.SWCLK_RISING) == 1){
      if(bitcount < 13){
        received = received | ( (if ( peek(c.io.D_OUT_0) == 1 ) 1 else 0) << bitcount )
        if(peek(c.io.D_OUT_0) == 1){ parity = !parity }
        if(bitcount == (13 + 32) ){
          //check parity bit
          expect(c.io.D_OUT_0, parity)
        }
      }
      else{
        received = received | ( (if ( peek(c.io.D_OUT_0) == 1 ) 1 else 0) << (bitcount - 13) )
      }
      bitcount = bitcount + 1

      //  10 0 10 011
      if(bitcount == 8){
        expect(received == 0x93, s"packet value expected 0xB1 received: $received")
      }

      poke(c.io.D_IN_0, if (bitcount == 10) 1 else 0)

      if(bitcount == 13) { received = 0 }

      if(bitcount == (13 + 32) ){
        expect(received == data, s"data value expected $data received: $received")
        received = 0
      }

    }

    step(1)
  }
}

class SWDTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "SWD" should s"write data over SWD protocol (with $backendName)" in {
      Driver(() => new SWD(), backendName) {
        c => new SWDUnitTester(c)
      } should be (true)
    }
  }
}