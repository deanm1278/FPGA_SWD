package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.Timer
import org.scalatest.Matchers
import scala.util.Random

class TimerUnitTester(c: Timer) extends PeekPokeTester(c) {

  poke(c.io.period, 0)
  poke(c.io.en, 1)

  // let it spin for a bit
  step(5)

  for (i <- 0 until 10) {
    val period = rnd.nextInt((1 << 4) - 1)
    poke(c.io.period, period)
    for(k <- 0 until (period + 1)){
      step(1)
      if(k == period){ expect(c.io.fire, 1) }
      else { expect(c.io.fire, 0) }
    }
  }
}

class TimerTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "Timer" should s"count to passed value (with $backendName)" in {
      Driver(() => new Timer(4), backendName) {
        c => new TimerUnitTester(c)
      } should be (true)
    }
  }
}