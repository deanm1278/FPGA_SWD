package modules

import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class SPIFastRead(val w: Int = 32, val dummyCycles: Int = 8, val clkDiv: Int = 2, val cmd: Int = 0x0B, val addrWidth: Int = 24) extends Module {
	val io = IO(new Bundle {
		val MOSI = Output(Bool())
		val MISO = Input(Bool())
		val SCK = Output(Bool()) 
		val DATA_READY = Output(Bool())
		val DATA = Output(UInt(w.W))
    val ADDR = Input(UInt( addrWidth.W ) )
    val EN = Input(Bool())
    val enqRdy = Input(Bool())

//THESE PORTS ARE ONLY USED FOR SIMULATION
    val SCK_RISING = Output(Bool())
	})

  withReset(~io.EN){
    val MISO_DATA = ShiftRegister(io.MISO, 1)

    val sSetup :: sRead :: Nil = Enum(2)
    val state = RegInit(sSetup)

    val SCKReg = RegInit(0.U)

    //generate SCK
    val cd = Module(new Counter(clkDiv))
    cd.io.amt := 1.U
    cd.io.inc := io.enqRdy
    when(cd.io.tot === clkDiv.U){ SCKReg := ~SCKReg }

    val SCKr = Module(new EdgeBuffer)
    SCKr.io.in := SCKReg
    io.SCK_RISING := SCKr.io.rising //SIMULATION ONLY

    val startCnt = Module(new Counter(9 + addrWidth + dummyCycles))
    startCnt.io.amt := 1.U
    startCnt.io.inc := SCKr.io.rising

    //bit counter for reading data
    val bitcnt = Module(new Counter(w - 1))
    bitcnt.io.amt := 1.U
    val byte_received = RegNext(bitcnt.io.tot === (w - 1).U && SCKr.io.rising)

    //read data, set data ready flag when done
    io.DATA_READY := byte_received

    val mosi_out = RegInit(0.asUInt(addrWidth.W))

    when(state === sSetup){

      bitcnt.io.inc := 0.U

      //send the command
      when(startCnt.io.tot === 0.U){ mosi_out := Cat(cmd.U, 0.asUInt( ( addrWidth - 8).W ) ) }

      //clock out data on the falling edge
      when(SCKr.io.falling){
        mosi_out := Cat(mosi_out(addrWidth - 2, 0), 0.U)

        //send the address
        when(startCnt.io.tot === 8.U){ mosi_out := io.ADDR }

        //send dummy cycles and then start reading data
        when(startCnt.io.tot === ( 8 + addrWidth + dummyCycles).U ){ state := sRead }

      }
      io.MOSI := mosi_out(addrWidth - 1)
      io.DATA := 0.U
    }

    when(state === sRead){
      bitcnt.io.inc := SCKr.io.rising

      io.DATA := ShiftIn.shift(w, SCKr.io.rising, MISO_DATA)
      io.MOSI := 0.U
    }

    io.SCK := SCKr.io.out
  }
}