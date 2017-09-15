package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.Top
import org.scalatest.Matchers
import scala.util.Random

class TopUnitTester(c: Top) extends PeekPokeTester(c) {
   val r = Random

   def writeReg(reg : Int, value : Int){
		poke(c.io.SPI_DATA, ( (1 << 27) | (reg << 24) | value) )
		poke(c.io.SPI_DATA_READY, 1)
		step(1)
		poke(c.io.SPI_DATA_READY, 0)
		step(1)
   }

   poke(c.io.SPI_DATA_READY, 0)
   poke(c.io.SPI_DATA, 0)
   poke(c.io.D_IN_0, 0)
   poke(c.io.FAST_READ_DATA, 0)

   step(3) //spin

   writeReg(1, 0)
   writeReg(2, 3) //start reading at address 3
   writeReg(3, 8) //write 8 blocks
   writeReg(4, 2) //clkdiv 2
   writeReg(1, 1)

   var bitcnt = 0
   var swclk_state = false
   var txn_started = false

   var spi_data = 0

   for(k <- 0 until 4000){
   	//test for start condition
   	if(peek(c.io.SWCLK) == 1 && peek(c.io.D_OUT_0) == 1){ txn_started = true }

   	//increment bitcount when we get a rising edge
   	if(peek(c.io.SWCLK) == 1 && swclk_state == false && txn_started == true){
   		bitcnt = bitcnt + 1
   	}
   	swclk_state = (if (peek(c.io.SWCLK) == 1) true else false)

   	//send ack when we get to the turnaround
   	poke(c.io.D_IN_0, if (bitcnt == 10) 1 else 0)

   	//check for start condition
   	if( bitcnt > 46 ){ bitcnt = 0; txn_started = false; }

   	//do SPI flash stuff
   	if(peek(c.io.FAST_READ_DATA_READY) == 1){
   		spi_data = spi_data + 1
   		poke(c.io.FAST_READ_DATA, spi_data)
   	}

   	step(1)
   }
}

class TopTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "Top" should s"do all the stuff the circuit does (with $backendName)" in {
      Driver(() => new Top, backendName) {
        c => new TopUnitTester(c)
      } should be (true)
    }
  }
}