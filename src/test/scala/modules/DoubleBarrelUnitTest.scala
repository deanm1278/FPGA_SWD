package modules.test

import chisel3.iotesters.{ChiselFlatSpec, Driver, PeekPokeTester}
import modules.DoubleBarrel
import org.scalatest.Matchers
import scala.util.Random

class DoubleBarrelUnitTester(c: DoubleBarrel) extends PeekPokeTester(c) {
  var r = Random
  //var addrStart = r.nextInt(1 << 24)
  var addrStart = 1024
  poke(c.io.ADDR_SET, 0)
  poke(c.io.DATA_READY, 0)
  poke(c.io.ADDR_IN, addrStart)
  poke(c.io.DATA_IN, 0)
  poke(c.io.TRIGGER, 0)

  step(5) //spin
  expect(c.io.ADDR_OUT, 0)

  poke(c.io.ADDR_SET, 1)
  step(1)
  poke(c.io.ADDR_SET, 0)
  step(1)
  expect(c.io.ADDR_OUT, addrStart)

  step(5)

  poke(c.io.DATA_READY, 1)

  step(5)

  var i = 0

  var dat = 0

  for(k <- 0 until 1035){
    if(peek(c.io.dataVal) == 1){
      if(i % 258 == 0 && i > 1){ 
        expect(c.io.DATA_OUT, addrStart + 1024)
        expect(c.io.A, 1)
      }
      else if(i == 1){
        expect(c.io.DATA_OUT, addrStart)
        expect(c.io.A, 1)
      }
      else { 
        expect(c.io.DATA_OUT, dat)
        expect(c.io.A, 3)
      }
    }

    if(peek(c.io.deqRdy) == 1){
      dat = r.nextInt(1 << 25)
      poke(c.io.DATA_IN, dat)
    }

    if(k % 4 == 0){  
      poke(c.io.TRIGGER, 1)
      i = i + 1
    }
    else{ 
      poke(c.io.TRIGGER, 0)
    }

    step(1)
  }
}

class DoubleBarrelTester extends ChiselFlatSpec with Matchers {
  private val backendNames = Array[String]("firrtl", "verilator")
  for ( backendName <- backendNames ) {
    "DoubleBarrel" should s"load address then data into DATA_OUT (with $backendName)" in {
      Driver(() => new DoubleBarrel(), backendName) {
        c => new DoubleBarrelUnitTester(c)
      } should be (true)
    }
  }
}