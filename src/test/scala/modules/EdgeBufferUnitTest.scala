package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.EdgeBuffer
import org.scalatest.Matchers
import scala.util.Random

class EdgeBufferUnitTester(c: EdgeBuffer) extends PeekPokeTester(c) {

  val r = Random
  //val spin: Int = r.nextInt(Integer.MAX_VALUE)

  poke(c.io.in, 0)

  // let it spin for a bit
  for (i <- 0 until 10) {
    step(1)
  }

  expect(c.io.rising, 0)
  expect(c.io.falling, 0)
  expect(c.io.out, 0)

  poke(c.io.in, 1)

  expect(c.io.rising, 0)
  expect(c.io.falling, 0)
  expect(c.io.out, 0)

  step(2)
  expect(c.io.rising, 1)
  expect(c.io.falling, 0)
  expect(c.io.out, 1)

  // let it spin for a bit
  for (i <- 0 until 12) {
    step(1)
  }
  expect(c.io.rising, 0)
  expect(c.io.falling, 0)
  expect(c.io.out, 1)

  poke(c.io.in, 0)
  step(2)

  expect(c.io.rising, 0)
  expect(c.io.falling, 1)
  expect(c.io.out, 0)

  step(1)

  expect(c.io.rising, 0)
  expect(c.io.falling, 0)
  expect(c.io.out, 0)
}

class EdgeBufferTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "EdgeBuffer" should s"detect rising and falling edges (with $backendName)" in {
      Driver(() => new EdgeBuffer, backendName) {
        c => new EdgeBufferUnitTester(c)
      } should be (true)
    }
  }
}