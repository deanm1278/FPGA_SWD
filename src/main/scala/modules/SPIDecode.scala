package modules

import chisel3._

class SPIDecode extends Module {
	val io = IO(new Bundle {
		val dataIn = Input(UInt(28.W))
		val dataOut = Output(UInt(24.W))
		val addr    = Output(UInt(3.W))
		val trigger = Input(Bool())
		val wclk	= Output(Bool())
	})
	val addr = RegInit(0.U(24.W))

	io.addr := io.dataIn(26, 24)
	io.dataOut := io.dataIn(23, 0)

	io.wclk := RegNext(io.dataIn(27) && io.trigger)
}