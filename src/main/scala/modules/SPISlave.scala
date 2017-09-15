package modules

import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class SPISlave(val w: Int, val outWidth: Int = 24) extends Module {
	val io = IO(new Bundle {
		val MOSI = Input(Bool())
		val MISO = Output(Bool())
		val SCK = Input(Bool())
		val SSEL = Input(Bool())
		val DATA_READY = Output(Bool())
		val DATA = Output(UInt(w.W))
    val READ_OUT = Input(UInt(outWidth.W))
	})

	val MOSI_DATA = ShiftRegister(io.MOSI, 1)
  val SCKr = Module(new EdgeBuffer)
  SCKr.io.in := io.SCK

  val SSELr = Module(new EdgeBuffer)
  SSELr.io.in := io.SSEL

  val byte_data_sent = RegInit(0.U(outWidth.W))

  withReset(SSELr.io.out){
  	val bitcnt = Module(new Counter(w - 1))
    bitcnt.io.inc := SCKr.io.rising
    bitcnt.io.amt := 1.U
    
    val byte_received = RegNext(bitcnt.io.tot === (w - 1).U && SCKr.io.rising)

    io.DATA_READY := byte_received
  }

  io.DATA := ShiftIn.shift(w, SCKr.io.rising && !SSELr.io.out, MOSI_DATA)

  //output data to the master on the rising edge of SCK
  when(SSELr.io.falling){
    byte_data_sent := io.READ_OUT
  }
  .elsewhen(SCKr.io.rising && !SSELr.io.out){
    byte_data_sent := Cat(byte_data_sent(outWidth - 2, 0), false.B)
  }
  io.MISO := byte_data_sent(outWidth - 1)

}