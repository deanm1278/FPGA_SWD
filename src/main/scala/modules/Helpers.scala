package modules

import chisel3._
import chisel3.experimental._ // To enable experimental features
import chisel3.util._

class EdgeBuffer extends Module {
  val io = IO(new Bundle {
    val in  = Input(Bool())
    val out = Output(Bool())
    val rising = Output(Bool())
    val falling = Output(Bool())
  })
  val r0 = RegNext(io.in)
  val r1 = RegNext(r0)
  val r2 = RegNext(r1)
  io.out := r1

  io.rising := (!r2 && r1)
  io.falling := (r2 && !r1)
}

object ShiftIn {
  def shift(w: Int, en: Bool, v: Bool): UInt = {
    val x = RegInit(0.U(w.W))
    when (en) { x := Cat(x, v) }
    x
  }
}

object Counter {

  def wrapAround(n: UInt, max: UInt) = 
    Mux(n > max, 0.U, n)

  def counter(max: UInt, en: Bool, amt: UInt = 1.U, rst: Bool = false.B): UInt = {
    val x = RegInit(0.U(max.getWidth.W))
    when (en) { x := wrapAround(x + amt, max) }
    .elsewhen(rst) { x := 0.U }
    x
  }

}

class Counter(val w: Int) extends Module {
  val io = IO(new Bundle {
    val inc = Input(Bool())
    val tot = Output(w.U)
    val amt = Input(w.U)
    val rst = Input(Bool())
  })

  io.tot := Counter.counter(w.U, io.inc, io.amt, io.rst)
}

class Timer(val w: Int) extends Module {
	val io = IO(new Bundle{
		val period = Input(UInt(w.W))
		val fire = Output(Bool())
    val en = Input(Bool())
	})

	val cnt = Counter.counter(io.period, io.en, 1.U)
	io.fire := RegNext(cnt === io.period)
}

class SB_IO extends BlackBox(Map("PIN_TYPE" -> "6'b101001",
  "PULLUP" -> 0)) {

  val io = IO(new Bundle {
    val PACKAGE_PIN = Output(Bool())
    val OUTPUT_ENABLE = Input(Bool())
    val D_OUT_0 = Input(Bool())
    val D_IN_0 = Output(Bool())
  })
}

//we need to declare the PLL as a black box since it's got a device-specific implementation
class SB_PLL40_CORE extends BlackBox(Map("FEEDBACK_PATH" -> "SIMPLE",
  "PLLOUT_SELECT" -> "GENCLK",
  "DIVR" -> 0,
  "DIVF" -> 23,
  "DIVQ" -> 2,
  "FILTER_RANGE" -> 2)) {

  val io = IO(new Bundle {
    val LOCK = Output(Bool())
    val RESETB = Input(Bool())
    val BYPASS = Input(Bool())
    val REFERENCECLK = Input(Clock())
    val PLLOUTCORE = Output(Clock())
  })
}

class AddrReg extends Module {
  val io = IO(new Bundle {
    val en = Input(Bool())
    val din = Input(UInt(24.W))
    val dout = Output(UInt(24.W))
  })

  val x = RegInit(0.U(24.W))
  when(io.en) { x := io.din }

  io.dout := x
}

class ClkDivReg extends Module {
  val io = IO(new Bundle {
    val en = Input(Bool())
    val din = Input(UInt(4.W))
    val dout = Output(UInt(4.W))
  })

  val x = RegInit(0.U(4.W))
  when(io.en) { x := io.din }

  io.dout := x
}

class LengthReg extends Module {
  val io = IO(new Bundle {
    val en = Input(Bool())
    val dec = Input(Bool())
    val din = Input(UInt(24.W))
    val dout = Output(UInt(24.W))
  })

  val x = RegInit(0.U(24.W))
  when(io.en) { x := io.din }
  when(io.dec) { x := x - 1.U }

  io.dout := x
}

class StatusReg extends Module {
  val io = IO(new Bundle{
    val en = Input(Bool())
    val din = Input(Bool())
    val dout = Output(UInt(2.W))
    val done = Input(Bool())
    val error = Input(Bool())
  })

  val x = RegInit(0.U)
  when(io.en) { x := io.din }

  val out = RegInit(0.U(2.W))
  out := Cat(io.error, Cat(io.done, x))

  io.dout := out
}