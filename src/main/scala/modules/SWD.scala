package modules

import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class SWD extends Module {
	val io = IO(new Bundle{
		val SWCLK = Output(Bool())
		val DATA = Input(UInt(32.W))
		val DATA_READY = Input(Bool())
		val deqRdy = Output(Bool())
		val CLKDIV = Input(UInt(4.W))
		val APnDP = Input(Bool())
		val A = Input(UInt(2.W))

		val D_IN_0 = Input(Bool())
		val D_OUT_0 = Output(Bool())
		val OUTPUT_ENABLE = Output(Bool())
		val ERROR = Output(Bool())

		val EN = Input(Bool())

//THESE PORTS ARE ONLY USED FOR SIMULATION
		val SWCLK_RISING = Output(Bool())
	})

	val swdio_out_reg = RegInit(0.asUInt(32.W))

	val swdio_response = RegInit(0.asUInt(3.W))

	val sIdle :: sPacket :: sTrn1 :: sAck :: sTrn2 :: sData :: sError :: Nil = Enum(7)
    val state = RegInit(sIdle)

	//generate SWCLK
	val SWCLKReg = RegInit(0.U)
    val tmr = Module(new Timer(4))
    tmr.io.period := io.CLKDIV
    tmr.io.en := 1.U

    val SWCLKr = Module(new EdgeBuffer)
    SWCLKr.io.in := SWCLKReg
    io.SWCLK := SWCLKr.io.out
    io.SWCLK_RISING := SWCLKr.io.rising //only used in simulation

    //SWCLK is disabled in ERROR state
    when(tmr.io.fire && state != sError && state != sIdle){ SWCLKReg := ~SWCLKReg }

    val deqRdyr = RegInit(true.B)
    io.deqRdy := (deqRdyr && io.EN)
    io.ERROR := state === sError

    val parity = RegInit(false.B)
    val outbit = RegInit(false.B)
    val outen = RegInit(false.B)
    val packet = Cat(Cat(Cat(2.U, 0.U), Cat(io.A, 0.U)), Cat(io.APnDP, 1.U))

    val bitcnt = Module(new Counter(46 + 7))
    bitcnt.io.inc := SWCLKr.io.rising
    bitcnt.io.amt := 1.U
    bitcnt.io.rst := 0.U

	when(state === sIdle){
		when(io.DATA_READY && io.EN && tmr.io.fire){ state := sPacket }
    	swdio_out_reg := packet
    	SWCLKReg := 0.U
    	parity := true.B
    	swdio_response := 0.U
    	outen := io.EN
	}
    when(state === sPacket){
		bitcnt.io.rst := 0.U
		deqRdyr := false.B

	    //clock out data on the falling edge
		when(SWCLKr.io.falling){
		   when(swdio_out_reg(0) === 1.U){ parity := ~parity } //count the 1s for the parity bit
		   swdio_out_reg := Cat(0.U, swdio_out_reg(31, 1))
		}
		when(bitcnt.io.tot === 5.U){ outbit := parity }
		.otherwise{ outbit := swdio_out_reg(0) }
	
		when(bitcnt.io.tot === 8.U){ 
			state := sTrn1
		}

		//SWDIO output is enabled
		outen := 1.U
    }
    when(state === sTrn1){
    	//tristate SWDIO until data stage
		outen := 0.U
    	when(bitcnt.io.tot === 9.U){
			//go to ACK state
			state := sAck
		}
    }
    when(state === sAck){
    	when(bitcnt.io.tot === 12.U){
    		state := sTrn2

			swdio_out_reg := io.DATA
		}
		when(SWCLKr.io.rising){
			swdio_response := Cat(io.D_IN_0, swdio_response(2, 1))
		}
		//tristate SWDIO until data stage
		outen := 0.U
    }
    when(state === sTrn2){

    	when(bitcnt.io.tot === 13.U && SWCLKr.io.falling){
			when(swdio_response === 1.U) { 
				state := sData
				outbit := swdio_out_reg(0)
				parity := swdio_out_reg(0)
				swdio_out_reg := Cat(0.U, swdio_out_reg(31, 1))
			} //transmit data if we have received an ACK
			.elsewhen(swdio_response === 2.U) { //WAIT
				outbit := 0.U
				bitcnt.io.rst := 1.U
				state := sIdle
			}
			.otherwise { state := sError }
		}
    }
    when(state === sData){
    	//reclaim SWDIO
    	outen := 1.U

    	//clock out data on the falling edge
		when(SWCLKr.io.falling){
		   when(swdio_out_reg(0) === 1.U){ parity := ~parity } //count the 1s for the parity bit
		   swdio_out_reg := Cat(0.U, swdio_out_reg(31, 1))

	   		when(bitcnt.io.tot === 45.U){ 
				outbit := parity
			}
			.otherwise{ 
				outbit := swdio_out_reg(0)
			}
		}

		when(bitcnt.io.tot === 0.U){
			state := sIdle
			deqRdyr := true.B
		}
    }
    when(state === sError){
    	//TODO: do something when ACK is not received
    }

    io.D_OUT_0 := outbit
    io.OUTPUT_ENABLE := outen
}