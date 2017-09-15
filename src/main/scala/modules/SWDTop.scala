package modules

import chisel3._
import chisel3.util._
import chisel3.experimental._ // To enable experimental features

class Top extends Module {
	val io = IO(new Bundle {
		val MOSI = Input(Bool())
		val MISO = Output(Bool())
		val SCK  = Input(Bool())
		val SSEL = Input(Bool())

		val FLASH_MOSI = Output(Bool())
		val FLASH_MISO = Input(Bool())
		val FLASH_SCK  = Output(Bool())
		val FLASH_SSEL = Output(Bool())

		val SWCLK = Output(Bool())

/**************************************
* This sucks, but right now we may need to
* change this port to inout in the generated verilog.
* (depending on how smart your synthesis software is)
* plz friends, add support.
****************************************/
		val SWDIO = Output(Bool())
/**************************************/

//THESE PORTS ARE ONLY USED FOR SIMULATION
		val SPI_DATA = Input(UInt(32.W))
		val SPI_DATA_READY = Input(Bool())
		val SPI_READ_OUT = Output(UInt(24.W))

		val OUTPUT_ENABLE = Output(Bool())
		val D_OUT_0 = Output(Bool())
		val D_IN_0 = Input(Bool())

		val FAST_READ_DATA = Input(UInt(32.W))
		val FAST_READ_DATA_READY = Output(Bool())
	})

sys.props.get("testing") match {
case Some(x) =>
	//For top level simulation don't use PLL or spi slave

	//SPI command decoder
	val decoder = Module(new SPIDecode)
	decoder.io.dataIn := io.SPI_DATA
	decoder.io.trigger := io.SPI_DATA_READY

	//create the register map
	val status = Module(new StatusReg)
	status.io.din := decoder.io.dataOut(0)
	status.io.en := (decoder.io.addr === 1.U && decoder.io.wclk)

	val readAddr = Module(new AddrReg)
	readAddr.io.din := decoder.io.dataOut
	readAddr.io.en := (decoder.io.addr === 2.U && decoder.io.wclk)

	val length = Module(new LengthReg)
	length.io.din := decoder.io.dataOut
	length.io.en := (decoder.io.addr === 3.U && decoder.io.wclk)

	val ClkDiv = Module(new ClkDivReg)
	ClkDiv.io.din := decoder.io.dataOut
	ClkDiv.io.en := (decoder.io.addr === 4.U && decoder.io.wclk)

	val writeAddr = Module(new AddrReg)
	writeAddr.io.din := decoder.io.dataOut
	writeAddr.io.en := (decoder.io.addr === 5.U && decoder.io.wclk)

	when(decoder.io.addr === 0.U){ io.SPI_READ_OUT := 0x55.U } //hardware ID test code
	.elsewhen(decoder.io.addr === 1.U){ io.SPI_READ_OUT := status.io.dout }
	.elsewhen(decoder.io.addr === 2.U){ io.SPI_READ_OUT := readAddr.io.dout }
	.elsewhen(decoder.io.addr === 3.U){ io.SPI_READ_OUT := length.io.dout }
	.elsewhen(decoder.io.addr === 4.U){ io.SPI_READ_OUT := ClkDiv.io.dout }
	.elsewhen(decoder.io.addr === 5.U){ io.SPI_READ_OUT := writeAddr.io.dout }
	.otherwise{ io.SPI_READ_OUT := 0.U }

	io.FLASH_SSEL := ~status.io.dout(0)

	val ENr = Module(new EdgeBuffer)
	ENr.io.in := status.io.dout(0)

	val spiMaster = Module(new SPIFastRead())
	length.io.dec := spiMaster.io.DATA_READY //decrement length left to read
	spiMaster.io.ADDR := readAddr.io.dout
	io.FLASH_MOSI := spiMaster.io.MOSI
	spiMaster.io.MISO := io.FLASH_MISO
	io.FLASH_SCK := spiMaster.io.SCK


	val fifo = Module(new Fifo(32, 3)) //very small fifo for simulation
	fifo.io.enqDat := io.FAST_READ_DATA //fake the input data
	fifo.io.enqVal := spiMaster.io.DATA_READY && ENr.io.out

	//for simulation
	io.FAST_READ_DATA_READY := spiMaster.io.DATA_READY

	//stop reading when we hit the specified number of blocks
	spiMaster.io.EN := (length.io.dout != 0.U && ENr.io.out)
	spiMaster.io.enqRdy := fifo.io.enqRdy

	val db = Module(new DoubleBarrel())
	db.io.EN := ENr.io.out
	db.io.ADDR_IN := writeAddr.io.dout
	db.io.ADDR_SET := ENr.io.rising
	db.io.DATA_READY := fifo.io.deqVal
	db.io.DATA_IN := fifo.io.deqDat

	fifo.io.deqRdy := db.io.deqRdy

	val swd = Module(new SWD())
	io.SWCLK := swd.io.SWCLK
	swd.io.CLKDIV := ClkDiv.io.dout
	swd.io.DATA_READY := (db.io.dataVal && fifo.io.deqVal)
	swd.io.DATA := db.io.DATA_OUT
	swd.io.APnDP := 1.U
	swd.io.A := db.io.A
	swd.io.EN := ENr.io.out

	db.io.TRIGGER := swd.io.deqRdy

	io.OUTPUT_ENABLE := swd.io.OUTPUT_ENABLE
	io.D_OUT_0 := swd.io.D_OUT_0
	swd.io.D_IN_0 := io.D_IN_0

	//set done
	status.io.done := (length.io.dout === 0.U && ~fifo.io.deqVal)
	status.io.error := swd.io.ERROR
		
case _ => 
	//instantiate the PLL. We need to explicitly define the clock and reset
	val pll = Module(new SB_PLL40_CORE)
	pll.io.RESETB := 0.U
	pll.io.REFERENCECLK := this.clock

	withClock(pll.io.PLLOUTCORE){
		//create the SPI interface
		val spi = Module(new SPISlave(32))
		spi.io.MOSI := io.MOSI
		io.MISO := spi.io.MISO
		spi.io.SCK := io.SCK
		spi.io.SSEL := io.SSEL

		//SPI command decoder
		val decoder = Module(new SPIDecode)
		decoder.io.dataIn := spi.io.DATA
		decoder.io.trigger := spi.io.DATA_READY

		//create the register map
		val status = Module(new StatusReg)
		status.io.din := decoder.io.dataOut(0)
		status.io.en := (decoder.io.addr === 1.U && decoder.io.wclk)

		val readAddr = Module(new AddrReg)
		readAddr.io.din := decoder.io.dataOut
		readAddr.io.en := (decoder.io.addr === 2.U && decoder.io.wclk)

		val length = Module(new LengthReg)
		length.io.din := decoder.io.dataOut
		length.io.en := (decoder.io.addr === 3.U && decoder.io.wclk)

		val ClkDiv = Module(new ClkDivReg)
		ClkDiv.io.din := decoder.io.dataOut
		ClkDiv.io.en := (decoder.io.addr === 4.U && decoder.io.wclk)

		val writeAddr = Module(new AddrReg)
		writeAddr.io.din := decoder.io.dataOut
		writeAddr.io.en := (decoder.io.addr === 5.U && decoder.io.wclk)

		when(decoder.io.addr === 0.U){ spi.io.READ_OUT := 0x55.U } //hardware ID test code
		.elsewhen(decoder.io.addr === 1.U){ spi.io.READ_OUT := status.io.dout }
		.elsewhen(decoder.io.addr === 2.U){ spi.io.READ_OUT := readAddr.io.dout }
		.elsewhen(decoder.io.addr === 3.U){ spi.io.READ_OUT := length.io.dout }
		.elsewhen(decoder.io.addr === 4.U){ spi.io.READ_OUT := ClkDiv.io.dout }
		.elsewhen(decoder.io.addr === 5.U){ spi.io.READ_OUT := writeAddr.io.dout }
		.otherwise{ spi.io.READ_OUT := 0.U }

		io.FLASH_SSEL := ~status.io.dout(0)

		val ENr = Module(new EdgeBuffer)
		ENr.io.in := status.io.dout(0)

		val spiMaster = Module(new SPIFastRead())
		length.io.dec := spiMaster.io.DATA_READY //decrement length left to read
		spiMaster.io.ADDR := readAddr.io.dout
		io.FLASH_MOSI := spiMaster.io.MOSI
		spiMaster.io.MISO := io.FLASH_MISO
		io.FLASH_SCK := spiMaster.io.SCK


		val fifo = Module(new Fifo(32, 8))
		fifo.io.enqDat := spiMaster.io.DATA
		fifo.io.enqVal := spiMaster.io.DATA_READY && ENr.io.out

		//stop reading when we hit the specified number of blocks or when the FIFO is full
		spiMaster.io.EN := (length.io.dout != 0.U && ENr.io.out)
		spiMaster.io.enqRdy := fifo.io.enqRdy

		val db = Module(new DoubleBarrel())
		db.io.EN := ENr.io.out
		db.io.ADDR_IN := writeAddr.io.dout
		db.io.ADDR_SET := ENr.io.rising
		db.io.DATA_READY := fifo.io.deqVal
		db.io.DATA_IN := fifo.io.deqDat

		fifo.io.deqRdy := db.io.deqRdy

		val swd = Module(new SWD())
		swd.io.CLKDIV := ClkDiv.io.dout
		swd.io.DATA_READY := (db.io.dataVal && fifo.io.deqVal)
		swd.io.DATA := db.io.DATA_OUT
		swd.io.APnDP := 1.U
		swd.io.A := db.io.A
		swd.io.EN := ENr.io.out

		db.io.TRIGGER := swd.io.deqRdy

		val swclk = Module(new SB_IO)
		io.SWCLK := swclk.io.PACKAGE_PIN
		swclk.io.OUTPUT_ENABLE := ENr.io.out
		swclk.io.D_OUT_0 := swd.io.SWCLK

		val swdio = Module(new SB_IO)
		io.SWDIO := swdio.io.PACKAGE_PIN
		swdio.io.OUTPUT_ENABLE := swd.io.OUTPUT_ENABLE
		swdio.io.D_OUT_0 := swd.io.D_OUT_0
		swd.io.D_IN_0 := swdio.io.D_IN_0

		//set done
		status.io.done := (length.io.dout === 0.U && ~fifo.io.deqVal)
		status.io.error := swd.io.ERROR
	}
}
}

object TopDriver extends App{
  chisel3.Driver.execute(args, () => new Top())
}