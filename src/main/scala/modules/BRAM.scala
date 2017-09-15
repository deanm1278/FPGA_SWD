package modules

import chisel3._
import chisel3.experimental._ // To enable experimental features
import chisel3.util._


class SB_RAM40_4K extends BlackBox(Map("READ_MODE" -> 0,
	"WRITE_MODE" -> 0)) {

	val io = IO(new Bundle {
		val RDATA = Output(UInt(16.W))
		val RADDR = Input(UInt(8.W))
		val RCLK = Input(Clock())
		val RCLKE = Input(Bool())
		val RE = Input(Bool())
		val WADDR = Input(UInt(8.W))
		val WCLK = Input(Clock())
		val WCLKE = Input(Bool())
		val WDATA = Input(UInt(16.W))
		val WE = Input(Bool())
		val MASK = Input(UInt(16.W))
	})
}

class SB_RAM40_4K_sim extends Module {

	val io = IO(new Bundle {
		val RDATA = Output(UInt(16.W))
		val RADDR = Input(UInt(8.W))
		val RCLK = Input(Clock())
		val RCLKE = Input(Bool())
		val RE = Input(Bool())
		val WADDR = Input(UInt(8.W))
		val WCLK = Input(Clock())
		val WCLKE = Input(Bool())
		val WDATA = Input(UInt(16.W))
		val WE = Input(Bool())
		val MASK = Input(UInt(16.W))
	})

	val bram = Mem(256, UInt(16.W))
	when (io.WE && io.WCLKE) { bram(io.WADDR) := io.WDATA }
	when (io.RE && io.RCLKE) { io.RDATA := bram(io.RADDR) }
}