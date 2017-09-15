package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.Fifo
import org.scalatest.Matchers
import scala.util.Random

class FifoUnitTester(c: Fifo) extends PeekPokeTester(c) {
  val r = Random

  var data = Seq.fill(257)(r.nextInt(1 << 24 - 1))
  poke(c.io.enqVal, 0)
  poke(c.io.deqRdy, 0)
  step(5) //spin

  for(k <- 0 until 257){
    if(k < 256){ expect(c.io.enqRdy, 1) }
    else { expect(c.io.enqRdy, 0) }

    poke(c.io.enqDat, data(k))
    step(1)
    poke(c.io.enqVal, 1)
    step(1)
    poke(c.io.enqVal, 0)
  }

  for(k <- 0 until 257){
    if(k < 256) {
      expect(c.io.deqDat, data(k))
      expect(c.io.deqVal, 1)
    }
    else {
      expect(c.io.deqVal, 0)
    }
    step(1)
    poke(c.io.deqRdy, 1)
    step(1)
    poke(c.io.deqRdy, 0)
  }

  step(5);
}

class FifoTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "Fifo" should s"implement a FIFO structure (with $backendName)" in {
      Driver(() => new Fifo(32, 8), backendName) {
        c => new FifoUnitTester(c)
      } should be (true)
    }
  }
}