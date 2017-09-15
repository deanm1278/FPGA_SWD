import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.SPISlave
import org.scalatest.Matchers
import scala.util.Random

class SPISlaveTest(c: SPISlave) extends PeekPokeTester(c) {
  val r = Random
  poke(c.io.SSEL, 1)
  poke(c.io.SCK, 0)

  step(10)

  for(n <- 1 to 100) {
    val dataIn = r.nextInt(Integer.MAX_VALUE);
    val readOut = r.nextInt(1 << 16)

    var mosi = dataIn

    poke(c.io.READ_OUT, readOut)
    poke(c.io.SSEL, 0)

    //spin
    step(10)

    for(i <- 1 to c.w) {
      val mosi_bit = ((mosi & 0x80000000) >> 31) & 0x01
      poke(c.io.MOSI, mosi_bit)

      step(2)
      poke(c.io.SCK, 1)
      step(4)
      poke(c.io.SCK, 0)
      mosi = mosi << 1
      step(3)
    }

    //spin
    step(5)
    expect(c.io.DATA, dataIn)

    poke(c.io.SSEL, 1)
    step(5)
  }
}

class SPISlaveTester extends ChiselFlatSpec {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "SPISlave" should s"receive SPI data (with $backendName)" in {
      Driver(() => new SPISlave(32, 16), backendName) {
        c => new SPISlaveTest(c)
      } should be (true)
    }
  }
}