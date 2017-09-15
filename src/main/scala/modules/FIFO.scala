package modules

import chisel3._
import chisel3.util._

class Fifo(w: Int, n: Int) extends Module {
  val io = IO(new Bundle {
    val enqVal = Input(Bool())
    val enqRdy = Output(Bool())
    val deqVal = Output(Bool())
    val deqRdy = Input(Bool())
    val enqDat = Input(UInt(w.W))
    val deqDat = Output(UInt(w.W))
  })
	val enqPtr     = RegInit(0.asUInt(n.W))
	val deqPtr     = RegInit(0.asUInt(n.W))
	val isFull     = RegInit(false.B)
	val doEnq      = io.enqRdy && io.enqVal
	val doDeq      = io.deqRdy && io.deqVal
	val isEmpty    = !isFull && (enqPtr === deqPtr)
	val deqPtrInc  = deqPtr + 1.U
	val enqPtrInc  = enqPtr + 1.U
	val isFullNext = Mux(doEnq && ~doDeq && (enqPtrInc === deqPtr),
	                     true.B, Mux(doDeq && isFull, false.B,
	                     isFull))
	enqPtr := Mux(doEnq, enqPtrInc, enqPtr)
	deqPtr := Mux(doDeq, deqPtrInc, deqPtr)
	isFull := isFullNext

	//ram banks for the FIFO
sys.props.get("testing") match {
  		case Some(x) => 
  			val banks = Range(0, 2).map(_ => Module(new SB_RAM40_4K_sim))
			for (k <- 0 until 2) {
				banks(k).io.RADDR := deqPtr
				banks(k).io.RCLK := this.clock
				banks(k).io.RCLKE := true.B
				banks(k).io.RE := true.B
				banks(k).io.WADDR := enqPtr
				banks(k).io.WCLK := this.clock
				banks(k).io.WCLKE := true.B
				banks(k).io.WE := doEnq
				banks(k).io.MASK := 0x0000.U
			}
			banks(0).io.WDATA := io.enqDat(31, 16) //high bank
			banks(1).io.WDATA := io.enqDat(15, 0) //low bank

			io.deqDat := Cat(banks(0).io.RDATA, banks(1).io.RDATA)

  		case _ => 
  			val banks = Range(0, 2).map(_ => Module(new SB_RAM40_4K))
			for (k <- 0 until 2) {
				banks(k).io.RADDR := deqPtr
				banks(k).io.RCLK := this.clock
				banks(k).io.RCLKE := true.B
				banks(k).io.RE := true.B
				banks(k).io.WADDR := enqPtr
				banks(k).io.WCLK := this.clock
				banks(k).io.WCLKE := true.B
				banks(k).io.WE := doEnq
				banks(k).io.MASK := 0x0000.U
			}
			banks(0).io.WDATA := io.enqDat(31, 16) //high bank
			banks(1).io.WDATA := io.enqDat(15, 0) //low bank

			io.deqDat := Cat(banks(0).io.RDATA, banks(1).io.RDATA)
}

	io.enqRdy := !isFull
	io.deqVal := !isEmpty
}