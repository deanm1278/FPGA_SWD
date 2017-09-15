import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.SPIDecode
import org.scalatest.Matchers
import scala.util.Random

class SPIDecodeTest(c: SPIDecode) extends PeekPokeTester(c) {
  val r = Random
  poke(c.io.trigger, 0)
  poke(c.io.dataIn, 0)
  step(10)

  for(n <- 1 to 10) {
      val datain = r.nextInt(1 << 28)
      poke(c.io.dataIn, datain)
      
      expect(c.io.addr, (datain >> 24) & 0x7)
      expect(c.io.dataOut, datain & 0xFFFFFF)

      poke(c.io.trigger, 1)
      step(1)
      poke(c.io.trigger, 0)

      if( ((datain >> 27) & 0x01) == 1){
        expect(c.io.wclk, 1)
      }
      else { expect(c.io.wclk, 0) }

      step(1)

  }
}

class SPIDecodeTester extends ChiselFlatSpec {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "SPIDecode" should s"receive SPI data (with $backendName)" in {
      Driver(() => new SPIDecode, backendName) {
        c => new SPIDecodeTest(c)
      } should be (true)
    }
  }
}