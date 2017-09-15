package modules

import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class DoubleBarrel extends Module {
	val io = IO(new Bundle{
		val ADDR_IN = Input(UInt(32.W))
		val ADDR_SET = Input(Bool())
		val ADDR_OUT = Output(UInt(32.W))
		val DATA_READY = Input(Bool())
		val DATA_IN = Input(UInt(32.W))
		val DATA_OUT = Output(UInt(32.W))
		val TRIGGER = Input(Bool())	
		val deqRdy = Output(Bool())
		val dataVal = Output(Bool())
		val EN = Input(Bool())

    val A = Output(UInt(2.W))
	})

	val addr = RegInit(0.asUInt(32.W))
	when(io.ADDR_SET) { addr := io.ADDR_IN }

	io.ADDR_OUT := addr

	val sStopped :: sAddr :: sData :: Nil = Enum(3)
	val state = RegInit(sStopped)

	val rdy = Module(new EdgeBuffer) //producer has available data and consumer is ready to read
	rdy.io.in := io.DATA_READY && io.TRIGGER && io.EN
	io.deqRdy := rdy.io.rising && state === sData

	io.dataVal := state != sStopped && ~rdy.io.rising //notify the consumer that data is valid

	val addrCnt = Module(new Counter(256))
	addrCnt.io.inc := rdy.io.rising && state != sStopped
	addrCnt.io.amt := 1.U

	when(state === sStopped) { 
		io.DATA_OUT := 0.U
		when(rdy.io.rising) { state := sAddr }
	}

	when(state === sAddr){
		io.A := 1.U //TAR
		io.DATA_OUT := addr
		when(rdy.io.rising){
			state := sData
		}
	}
	when(state === sData){
		io.DATA_OUT := Cat(io.DATA_IN(7,0), Cat(io.DATA_IN(15,8), Cat(io.DATA_IN(23,16), io.DATA_IN(31,24))))
		io.A := 3.U //DRW
		when(rdy.io.rising){
			when(addrCnt.io.tot === 256.U){ state := sAddr }
			addr := addr + 4.U
		}
	}
}