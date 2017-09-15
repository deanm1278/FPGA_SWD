`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif

module EdgeBuffer(
  input   clock,
  input   io_in,
  output  io_out,
  output  io_rising,
  output  io_falling
);
  reg  r0;
  reg [31:0] _RAND_0;
  reg  r1;
  reg [31:0] _RAND_1;
  reg  r2;
  reg [31:0] _RAND_2;
  wire  _T_10;
  wire  _T_11;
  wire  _T_13;
  wire  _T_14;
  assign _T_10 = r2 == 1'h0;
  assign _T_11 = _T_10 & r1;
  assign _T_13 = r1 == 1'h0;
  assign _T_14 = r2 & _T_13;
  assign io_out = r1;
  assign io_rising = _T_11;
  assign io_falling = _T_14;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  r0 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  r1 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  r2 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    r0 <= io_in;
    r1 <= r0;
    r2 <= r1;
  end
endmodule
module Counter(
  input        clock,
  input        reset,
  input        io_inc,
  output [4:0] io_tot
);
  reg [4:0] _T_9;
  reg [31:0] _RAND_0;
  wire [5:0] _T_10;
  wire [4:0] _T_11;
  wire [4:0] _GEN_1;
  assign _T_10 = _T_9 + 5'h1;
  assign _T_11 = _T_10[4:0];
  assign _GEN_1 = io_inc ? _T_11 : _T_9;
  assign io_tot = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_9 = _RAND_0[4:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_9 <= 5'h0;
    end else begin
      if (io_inc) begin
        _T_9 <= _T_11;
      end
    end
  end
endmodule
module SPISlave(
  input         clock,
  input         reset,
  input         io_MOSI,
  output        io_MISO,
  input         io_SCK,
  input         io_SSEL,
  output        io_DATA_READY,
  output [31:0] io_DATA,
  input  [23:0] io_READ_OUT
);
  reg  MOSI_DATA;
  reg [31:0] _RAND_0;
  wire  SCKr_clock;
  wire  SCKr_io_in;
  wire  SCKr_io_out;
  wire  SCKr_io_rising;
  wire  SCKr_io_falling;
  wire  SSELr_clock;
  wire  SSELr_io_in;
  wire  SSELr_io_out;
  wire  SSELr_io_rising;
  wire  SSELr_io_falling;
  reg [23:0] byte_data_sent;
  reg [31:0] _RAND_1;
  wire  Counter_clock;
  wire  Counter_reset;
  wire  Counter_io_inc;
  wire [4:0] Counter_io_tot;
  wire  _T_15;
  wire  _T_16;
  reg  _T_18;
  reg [31:0] _RAND_2;
  wire  _T_20;
  wire  _T_21;
  reg [31:0] _T_24;
  reg [31:0] _RAND_3;
  wire [32:0] _T_25;
  wire [32:0] _GEN_1;
  wire [22:0] _T_29;
  wire [23:0] _T_31;
  wire [23:0] _GEN_2;
  wire [23:0] _GEN_3;
  wire  _T_32;
  EdgeBuffer SCKr (
    .clock(SCKr_clock),
    .io_in(SCKr_io_in),
    .io_out(SCKr_io_out),
    .io_rising(SCKr_io_rising),
    .io_falling(SCKr_io_falling)
  );
  EdgeBuffer SSELr (
    .clock(SSELr_clock),
    .io_in(SSELr_io_in),
    .io_out(SSELr_io_out),
    .io_rising(SSELr_io_rising),
    .io_falling(SSELr_io_falling)
  );
  Counter Counter (
    .clock(Counter_clock),
    .reset(Counter_reset),
    .io_inc(Counter_io_inc),
    .io_tot(Counter_io_tot)
  );
  assign _T_15 = Counter_io_tot == 5'h1f;
  assign _T_16 = _T_15 & SCKr_io_rising;
  assign _T_20 = SSELr_io_out == 1'h0;
  assign _T_21 = SCKr_io_rising & _T_20;
  assign _T_25 = {_T_24,MOSI_DATA};
  assign _GEN_1 = _T_21 ? _T_25 : {{1'd0}, _T_24};
  assign _T_29 = byte_data_sent[22:0];
  assign _T_31 = {_T_29,1'h0};
  assign _GEN_2 = _T_21 ? _T_31 : byte_data_sent;
  assign _GEN_3 = SSELr_io_falling ? io_READ_OUT : _GEN_2;
  assign _T_32 = byte_data_sent[23];
  assign io_MISO = _T_32;
  assign io_DATA_READY = _T_18;
  assign io_DATA = _T_24;
  assign SCKr_io_in = io_SCK;
  assign SCKr_clock = clock;
  assign SSELr_io_in = io_SSEL;
  assign SSELr_clock = clock;
  assign Counter_io_inc = SCKr_io_rising;
  assign Counter_clock = clock;
  assign Counter_reset = SSELr_io_out;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  MOSI_DATA = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  byte_data_sent = _RAND_1[23:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  _T_18 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  _T_24 = _RAND_3[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    MOSI_DATA <= io_MOSI;
    if (reset) begin
      byte_data_sent <= 24'h0;
    end else begin
      if (SSELr_io_falling) begin
        byte_data_sent <= io_READ_OUT;
      end else begin
        if (_T_21) begin
          byte_data_sent <= _T_31;
        end
      end
    end
    _T_18 <= _T_16;
    if (reset) begin
      _T_24 <= 32'h0;
    end else begin
      _T_24 <= _GEN_1[31:0];
    end
  end
endmodule
module SPIDecode(
  input         clock,
  input  [27:0] io_dataIn,
  output [23:0] io_dataOut,
  output [2:0]  io_addr,
  input         io_trigger,
  output        io_wclk
);
  wire [2:0] _T_9;
  wire [23:0] _T_10;
  wire  _T_11;
  wire  _T_12;
  reg  _T_14;
  reg [31:0] _RAND_0;
  assign _T_9 = io_dataIn[26:24];
  assign _T_10 = io_dataIn[23:0];
  assign _T_11 = io_dataIn[27];
  assign _T_12 = _T_11 & io_trigger;
  assign io_dataOut = _T_10;
  assign io_addr = _T_9;
  assign io_wclk = _T_14;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_14 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    _T_14 <= _T_12;
  end
endmodule
module StatusReg(
  input        clock,
  input        reset,
  input        io_en,
  input        io_din,
  output [1:0] io_dout,
  input        io_done,
  input        io_error
);
  reg  x;
  reg [31:0] _RAND_0;
  wire  _GEN_0;
  reg [1:0] out;
  reg [31:0] _RAND_1;
  wire [1:0] _T_11;
  wire [2:0] _T_12;
  assign _GEN_0 = io_en ? io_din : x;
  assign _T_11 = {io_done,x};
  assign _T_12 = {io_error,_T_11};
  assign io_dout = out;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  x = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  out = _RAND_1[1:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      x <= 1'h0;
    end else begin
      if (io_en) begin
        x <= io_din;
      end
    end
    if (reset) begin
      out <= 2'h0;
    end else begin
      out <= _T_12[1:0];
    end
  end
endmodule
module AddrReg(
  input         clock,
  input         reset,
  input         io_en,
  input  [23:0] io_din,
  output [23:0] io_dout
);
  reg [23:0] x;
  reg [31:0] _RAND_0;
  wire [23:0] _GEN_0;
  assign _GEN_0 = io_en ? io_din : x;
  assign io_dout = x;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  x = _RAND_0[23:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      x <= 24'h0;
    end else begin
      if (io_en) begin
        x <= io_din;
      end
    end
  end
endmodule
module LengthReg(
  input         clock,
  input         reset,
  input         io_en,
  input         io_dec,
  input  [23:0] io_din,
  output [23:0] io_dout
);
  reg [23:0] x;
  reg [31:0] _RAND_0;
  wire [23:0] _GEN_0;
  wire [24:0] _T_9;
  wire [24:0] _T_10;
  wire [23:0] _T_11;
  wire [23:0] _GEN_1;
  assign _GEN_0 = io_en ? io_din : x;
  assign _T_9 = x - 24'h1;
  assign _T_10 = $unsigned(_T_9);
  assign _T_11 = _T_10[23:0];
  assign _GEN_1 = io_dec ? _T_11 : _GEN_0;
  assign io_dout = x;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  x = _RAND_0[23:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      x <= 24'h0;
    end else begin
      if (io_dec) begin
        x <= _T_11;
      end else begin
        if (io_en) begin
          x <= io_din;
        end
      end
    end
  end
endmodule
module ClkDivReg(
  input        clock,
  input        reset,
  input        io_en,
  input  [3:0] io_din,
  output [3:0] io_dout
);
  reg [3:0] x;
  reg [31:0] _RAND_0;
  wire [3:0] _GEN_0;
  assign _GEN_0 = io_en ? io_din : x;
  assign io_dout = x;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  x = _RAND_0[3:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      x <= 4'h0;
    end else begin
      if (io_en) begin
        x <= io_din;
      end
    end
  end
endmodule
module Counter_1(
  input        clock,
  input        reset,
  input        io_inc,
  output [1:0] io_tot
);
  reg [1:0] _T_9;
  reg [31:0] _RAND_0;
  wire [2:0] _T_10;
  wire [1:0] _T_11;
  wire  _T_12;
  wire [1:0] _T_14;
  wire [1:0] _GEN_1;
  assign _T_10 = _T_9 + 2'h1;
  assign _T_11 = _T_10[1:0];
  assign _T_12 = _T_11 > 2'h2;
  assign _T_14 = _T_12 ? 2'h0 : _T_11;
  assign _GEN_1 = io_inc ? _T_14 : _T_9;
  assign io_tot = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_9 = _RAND_0[1:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_9 <= 2'h0;
    end else begin
      if (io_inc) begin
        if (_T_12) begin
          _T_9 <= 2'h0;
        end else begin
          _T_9 <= _T_11;
        end
      end
    end
  end
endmodule
module Counter_2(
  input        clock,
  input        reset,
  input        io_inc,
  output [5:0] io_tot
);
  reg [5:0] _T_9;
  reg [31:0] _RAND_0;
  wire [6:0] _T_10;
  wire [5:0] _T_11;
  wire  _T_12;
  wire [5:0] _T_14;
  wire [5:0] _GEN_1;
  assign _T_10 = _T_9 + 6'h1;
  assign _T_11 = _T_10[5:0];
  assign _T_12 = _T_11 > 6'h29;
  assign _T_14 = _T_12 ? 6'h0 : _T_11;
  assign _GEN_1 = io_inc ? _T_14 : _T_9;
  assign io_tot = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_9 = _RAND_0[5:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_9 <= 6'h0;
    end else begin
      if (io_inc) begin
        if (_T_12) begin
          _T_9 <= 6'h0;
        end else begin
          _T_9 <= _T_11;
        end
      end
    end
  end
endmodule
module SPIFastRead(
  input         clock,
  output        io_MOSI,
  input         io_MISO,
  output        io_SCK,
  output        io_DATA_READY,
  output [31:0] io_DATA,
  input  [23:0] io_ADDR,
  input         io_EN,
  input         io_enqRdy
);
  wire  _T_11;
  reg  _T_14;
  reg [31:0] _RAND_0;
  reg  _T_18;
  reg [31:0] _RAND_1;
  reg  _T_21;
  reg [31:0] _RAND_2;
  wire  Counter_clock;
  wire  Counter_reset;
  wire  Counter_io_inc;
  wire [1:0] Counter_io_tot;
  wire  _T_24;
  wire  _T_25;
  wire  _GEN_1;
  wire  EdgeBuffer_clock;
  wire  EdgeBuffer_io_in;
  wire  EdgeBuffer_io_out;
  wire  EdgeBuffer_io_rising;
  wire  EdgeBuffer_io_falling;
  wire  Counter_1_clock;
  wire  Counter_1_reset;
  wire  Counter_1_io_inc;
  wire [5:0] Counter_1_io_tot;
  wire  Counter_2_clock;
  wire  Counter_2_reset;
  wire  Counter_2_io_inc;
  wire [4:0] Counter_2_io_tot;
  wire  _T_29;
  wire  _T_30;
  reg  _T_32;
  reg [31:0] _RAND_3;
  reg [23:0] _T_35;
  reg [31:0] _RAND_4;
  wire  _T_36;
  wire  _T_39;
  wire [23:0] _GEN_2;
  wire [22:0] _T_43;
  wire [23:0] _T_45;
  wire  _T_47;
  wire [23:0] _GEN_3;
  wire  _T_49;
  wire  _GEN_4;
  wire [23:0] _GEN_5;
  wire  _GEN_6;
  wire  _T_50;
  wire [23:0] _GEN_8;
  wire  _GEN_9;
  reg [31:0] _T_55;
  reg [31:0] _RAND_5;
  wire [32:0] _T_56;
  wire [32:0] _GEN_11;
  wire  _GEN_12;
  wire [31:0] _GEN_13;
  wire  _GEN_14;
  Counter_1 Counter (
    .clock(Counter_clock),
    .reset(Counter_reset),
    .io_inc(Counter_io_inc),
    .io_tot(Counter_io_tot)
  );
  EdgeBuffer EdgeBuffer (
    .clock(EdgeBuffer_clock),
    .io_in(EdgeBuffer_io_in),
    .io_out(EdgeBuffer_io_out),
    .io_rising(EdgeBuffer_io_rising),
    .io_falling(EdgeBuffer_io_falling)
  );
  Counter_2 Counter_1 (
    .clock(Counter_1_clock),
    .reset(Counter_1_reset),
    .io_inc(Counter_1_io_inc),
    .io_tot(Counter_1_io_tot)
  );
  Counter Counter_2 (
    .clock(Counter_2_clock),
    .reset(Counter_2_reset),
    .io_inc(Counter_2_io_inc),
    .io_tot(Counter_2_io_tot)
  );
  assign _T_11 = ~ io_EN;
  assign _T_24 = Counter_io_tot == 2'h2;
  assign _T_25 = ~ _T_21;
  assign _GEN_1 = _T_24 ? _T_25 : _T_21;
  assign _T_29 = Counter_2_io_tot == 5'h1f;
  assign _T_30 = _T_29 & EdgeBuffer_io_rising;
  assign _T_36 = _T_18 == 1'h0;
  assign _T_39 = Counter_1_io_tot == 6'h0;
  assign _GEN_2 = _T_39 ? 24'hb0000 : _T_35;
  assign _T_43 = _T_35[22:0];
  assign _T_45 = {_T_43,1'h0};
  assign _T_47 = Counter_1_io_tot == 6'h8;
  assign _GEN_3 = _T_47 ? io_ADDR : _T_45;
  assign _T_49 = Counter_1_io_tot == 6'h28;
  assign _GEN_4 = _T_49 ? 1'h1 : _T_18;
  assign _GEN_5 = EdgeBuffer_io_falling ? _GEN_3 : _GEN_2;
  assign _GEN_6 = EdgeBuffer_io_falling ? _GEN_4 : _T_18;
  assign _T_50 = _T_35[23];
  assign _GEN_8 = _T_36 ? _GEN_5 : _T_35;
  assign _GEN_9 = _T_36 ? _GEN_6 : _T_18;
  assign _T_56 = {_T_55,_T_14};
  assign _GEN_11 = EdgeBuffer_io_rising ? _T_56 : {{1'd0}, _T_55};
  assign _GEN_12 = _T_18 ? EdgeBuffer_io_rising : 1'h0;
  assign _GEN_13 = _T_18 ? _T_55 : 32'h0;
  assign _GEN_14 = _T_18 ? 1'h0 : _T_50;
  assign io_MOSI = _GEN_14;
  assign io_SCK = EdgeBuffer_io_out;
  assign io_DATA_READY = _T_32;
  assign io_DATA = _GEN_13;
  assign Counter_io_inc = io_enqRdy;
  assign Counter_clock = clock;
  assign Counter_reset = _T_11;
  assign EdgeBuffer_io_in = _T_21;
  assign EdgeBuffer_clock = clock;
  assign Counter_1_io_inc = EdgeBuffer_io_rising;
  assign Counter_1_clock = clock;
  assign Counter_1_reset = _T_11;
  assign Counter_2_io_inc = _GEN_12;
  assign Counter_2_clock = clock;
  assign Counter_2_reset = _T_11;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_14 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  _T_18 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  _T_21 = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  _T_32 = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  _T_35 = _RAND_4[23:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  _T_55 = _RAND_5[31:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    _T_14 <= io_MISO;
    if (_T_11) begin
      _T_18 <= 1'h0;
    end else begin
      if (_T_36) begin
        if (EdgeBuffer_io_falling) begin
          if (_T_49) begin
            _T_18 <= 1'h1;
          end
        end
      end
    end
    if (_T_11) begin
      _T_21 <= 1'h0;
    end else begin
      if (_T_24) begin
        _T_21 <= _T_25;
      end
    end
    _T_32 <= _T_30;
    if (_T_11) begin
      _T_35 <= 24'h0;
    end else begin
      if (_T_36) begin
        if (EdgeBuffer_io_falling) begin
          if (_T_47) begin
            _T_35 <= io_ADDR;
          end else begin
            _T_35 <= _T_45;
          end
        end else begin
          if (_T_39) begin
            _T_35 <= 24'hb0000;
          end
        end
      end
    end
    if (_T_11) begin
      _T_55 <= 32'h0;
    end else begin
      _T_55 <= _GEN_11[31:0];
    end
  end
endmodule
module Fifo(
  input         clock,
  input         reset,
  input         io_enqVal,
  output        io_enqRdy,
  output        io_deqVal,
  input         io_deqRdy,
  input  [31:0] io_enqDat,
  output [31:0] io_deqDat
);
  reg [7:0] enqPtr;
  reg [31:0] _RAND_0;
  reg [7:0] deqPtr;
  reg [31:0] _RAND_1;
  reg  isFull;
  reg [31:0] _RAND_2;
  wire  doEnq;
  wire  doDeq;
  wire  _T_15;
  wire  _T_16;
  wire  isEmpty;
  wire [8:0] _T_18;
  wire [7:0] deqPtrInc;
  wire [8:0] _T_20;
  wire [7:0] enqPtrInc;
  wire  _T_21;
  wire  _T_22;
  wire  _T_23;
  wire  _T_24;
  wire  _T_26;
  wire  _T_28;
  wire  isFullNext;
  wire [7:0] _T_29;
  wire [7:0] _T_30;
  wire [15:0] SB_RAM40_4K_MASK;
  wire  SB_RAM40_4K_WE;
  wire [15:0] SB_RAM40_4K_WDATA;
  wire  SB_RAM40_4K_WCLKE;
  wire  SB_RAM40_4K_WCLK;
  wire [7:0] SB_RAM40_4K_WADDR;
  wire  SB_RAM40_4K_RE;
  wire  SB_RAM40_4K_RCLKE;
  wire  SB_RAM40_4K_RCLK;
  wire [7:0] SB_RAM40_4K_RADDR;
  wire [15:0] SB_RAM40_4K_RDATA;
  wire [15:0] SB_RAM40_4K_1_MASK;
  wire  SB_RAM40_4K_1_WE;
  wire [15:0] SB_RAM40_4K_1_WDATA;
  wire  SB_RAM40_4K_1_WCLKE;
  wire  SB_RAM40_4K_1_WCLK;
  wire [7:0] SB_RAM40_4K_1_WADDR;
  wire  SB_RAM40_4K_1_RE;
  wire  SB_RAM40_4K_1_RCLKE;
  wire  SB_RAM40_4K_1_RCLK;
  wire [7:0] SB_RAM40_4K_1_RADDR;
  wire [15:0] SB_RAM40_4K_1_RDATA;
  wire [15:0] _T_39;
  wire [15:0] _T_40;
  wire [31:0] _T_41;
  wire  _T_45;
  SB_RAM40_4K #(.READ_MODE(0), .WRITE_MODE(0)) SB_RAM40_4K (
    .MASK(SB_RAM40_4K_MASK),
    .WE(SB_RAM40_4K_WE),
    .WDATA(SB_RAM40_4K_WDATA),
    .WCLKE(SB_RAM40_4K_WCLKE),
    .WCLK(SB_RAM40_4K_WCLK),
    .WADDR(SB_RAM40_4K_WADDR),
    .RE(SB_RAM40_4K_RE),
    .RCLKE(SB_RAM40_4K_RCLKE),
    .RCLK(SB_RAM40_4K_RCLK),
    .RADDR(SB_RAM40_4K_RADDR),
    .RDATA(SB_RAM40_4K_RDATA)
  );
  SB_RAM40_4K #(.READ_MODE(0), .WRITE_MODE(0)) SB_RAM40_4K_1 (
    .MASK(SB_RAM40_4K_1_MASK),
    .WE(SB_RAM40_4K_1_WE),
    .WDATA(SB_RAM40_4K_1_WDATA),
    .WCLKE(SB_RAM40_4K_1_WCLKE),
    .WCLK(SB_RAM40_4K_1_WCLK),
    .WADDR(SB_RAM40_4K_1_WADDR),
    .RE(SB_RAM40_4K_1_RE),
    .RCLKE(SB_RAM40_4K_1_RCLKE),
    .RCLK(SB_RAM40_4K_1_RCLK),
    .RADDR(SB_RAM40_4K_1_RADDR),
    .RDATA(SB_RAM40_4K_1_RDATA)
  );
  assign doEnq = io_enqRdy & io_enqVal;
  assign doDeq = io_deqRdy & io_deqVal;
  assign _T_15 = isFull == 1'h0;
  assign _T_16 = enqPtr == deqPtr;
  assign isEmpty = _T_15 & _T_16;
  assign _T_18 = deqPtr + 8'h1;
  assign deqPtrInc = _T_18[7:0];
  assign _T_20 = enqPtr + 8'h1;
  assign enqPtrInc = _T_20[7:0];
  assign _T_21 = ~ doDeq;
  assign _T_22 = doEnq & _T_21;
  assign _T_23 = enqPtrInc == deqPtr;
  assign _T_24 = _T_22 & _T_23;
  assign _T_26 = doDeq & isFull;
  assign _T_28 = _T_26 ? 1'h0 : isFull;
  assign isFullNext = _T_24 ? 1'h1 : _T_28;
  assign _T_29 = doEnq ? enqPtrInc : enqPtr;
  assign _T_30 = doDeq ? deqPtrInc : deqPtr;
  assign _T_39 = io_enqDat[31:16];
  assign _T_40 = io_enqDat[15:0];
  assign _T_41 = {SB_RAM40_4K_RDATA,SB_RAM40_4K_1_RDATA};
  assign _T_45 = isEmpty == 1'h0;
  assign io_enqRdy = _T_15;
  assign io_deqVal = _T_45;
  assign io_deqDat = _T_41;
  assign SB_RAM40_4K_MASK = 16'h0;
  assign SB_RAM40_4K_WE = doEnq;
  assign SB_RAM40_4K_WDATA = _T_39;
  assign SB_RAM40_4K_WCLKE = 1'h1;
  assign SB_RAM40_4K_WCLK = clock;
  assign SB_RAM40_4K_WADDR = enqPtr;
  assign SB_RAM40_4K_RE = 1'h1;
  assign SB_RAM40_4K_RCLKE = 1'h1;
  assign SB_RAM40_4K_RCLK = clock;
  assign SB_RAM40_4K_RADDR = deqPtr;
  assign SB_RAM40_4K_1_MASK = 16'h0;
  assign SB_RAM40_4K_1_WE = doEnq;
  assign SB_RAM40_4K_1_WDATA = _T_40;
  assign SB_RAM40_4K_1_WCLKE = 1'h1;
  assign SB_RAM40_4K_1_WCLK = clock;
  assign SB_RAM40_4K_1_WADDR = enqPtr;
  assign SB_RAM40_4K_1_RE = 1'h1;
  assign SB_RAM40_4K_1_RCLKE = 1'h1;
  assign SB_RAM40_4K_1_RCLK = clock;
  assign SB_RAM40_4K_1_RADDR = deqPtr;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  enqPtr = _RAND_0[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  deqPtr = _RAND_1[7:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  isFull = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      enqPtr <= 8'h0;
    end else begin
      if (doEnq) begin
        enqPtr <= enqPtrInc;
      end
    end
    if (reset) begin
      deqPtr <= 8'h0;
    end else begin
      if (doDeq) begin
        deqPtr <= deqPtrInc;
      end
    end
    if (reset) begin
      isFull <= 1'h0;
    end else begin
      if (_T_24) begin
        isFull <= 1'h1;
      end else begin
        if (_T_26) begin
          isFull <= 1'h0;
        end
      end
    end
  end
endmodule
module Counter_4(
  input        clock,
  input        reset,
  input        io_inc,
  output [8:0] io_tot
);
  reg [8:0] _T_9;
  reg [31:0] _RAND_0;
  wire [9:0] _T_10;
  wire [8:0] _T_11;
  wire  _T_12;
  wire [8:0] _T_14;
  wire [8:0] _GEN_1;
  assign _T_10 = _T_9 + 9'h1;
  assign _T_11 = _T_10[8:0];
  assign _T_12 = _T_11 > 9'h100;
  assign _T_14 = _T_12 ? 9'h0 : _T_11;
  assign _GEN_1 = io_inc ? _T_14 : _T_9;
  assign io_tot = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_9 = _RAND_0[8:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_9 <= 9'h0;
    end else begin
      if (io_inc) begin
        if (_T_12) begin
          _T_9 <= 9'h0;
        end else begin
          _T_9 <= _T_11;
        end
      end
    end
  end
endmodule
module DoubleBarrel(
  input         clock,
  input         reset,
  input  [31:0] io_ADDR_IN,
  input         io_ADDR_SET,
  input         io_DATA_READY,
  input  [31:0] io_DATA_IN,
  output [31:0] io_DATA_OUT,
  input         io_TRIGGER,
  output        io_deqRdy,
  output        io_dataVal,
  input         io_EN,
  output [1:0]  io_A
);
  reg [31:0] addr;
  reg [31:0] _RAND_0;
  wire [31:0] _GEN_0;
  reg [1:0] state;
  reg [31:0] _RAND_1;
  wire  rdy_clock;
  wire  rdy_io_in;
  wire  rdy_io_out;
  wire  rdy_io_rising;
  wire  rdy_io_falling;
  wire  _T_16;
  wire  _T_17;
  wire  _T_18;
  wire  _T_19;
  wire  _T_20;
  wire  _T_21;
  wire  _T_22;
  wire  addrCnt_clock;
  wire  addrCnt_reset;
  wire  addrCnt_io_inc;
  wire [8:0] addrCnt_io_tot;
  wire  _T_24;
  wire  _T_26;
  wire [1:0] _GEN_1;
  wire [1:0] _GEN_3;
  wire  _T_28;
  wire [1:0] _GEN_4;
  wire [31:0] _GEN_6;
  wire [1:0] _GEN_7;
  wire [7:0] _T_31;
  wire [7:0] _T_32;
  wire [7:0] _T_33;
  wire [7:0] _T_34;
  wire [15:0] _T_35;
  wire [23:0] _T_36;
  wire [31:0] _T_37;
  wire  _T_40;
  wire [1:0] _GEN_8;
  wire [32:0] _T_42;
  wire [31:0] _T_43;
  wire [1:0] _GEN_9;
  wire [31:0] _GEN_10;
  wire [31:0] _GEN_11;
  wire [1:0] _GEN_12;
  wire [1:0] _GEN_13;
  wire [31:0] _GEN_14;
  EdgeBuffer rdy (
    .clock(rdy_clock),
    .io_in(rdy_io_in),
    .io_out(rdy_io_out),
    .io_rising(rdy_io_rising),
    .io_falling(rdy_io_falling)
  );
  Counter_4 addrCnt (
    .clock(addrCnt_clock),
    .reset(addrCnt_reset),
    .io_inc(addrCnt_io_inc),
    .io_tot(addrCnt_io_tot)
  );
  assign _GEN_0 = io_ADDR_SET ? io_ADDR_IN : addr;
  assign _T_16 = io_DATA_READY & io_TRIGGER;
  assign _T_17 = _T_16 & io_EN;
  assign _T_18 = state == 2'h2;
  assign _T_19 = rdy_io_rising & _T_18;
  assign _T_20 = state != 2'h0;
  assign _T_21 = ~ rdy_io_rising;
  assign _T_22 = _T_20 & _T_21;
  assign _T_24 = rdy_io_rising & _T_20;
  assign _T_26 = state == 2'h0;
  assign _GEN_1 = rdy_io_rising ? 2'h1 : state;
  assign _GEN_3 = _T_26 ? _GEN_1 : state;
  assign _T_28 = state == 2'h1;
  assign _GEN_4 = rdy_io_rising ? 2'h2 : _GEN_3;
  assign _GEN_6 = _T_28 ? addr : 32'h0;
  assign _GEN_7 = _T_28 ? _GEN_4 : _GEN_3;
  assign _T_31 = io_DATA_IN[7:0];
  assign _T_32 = io_DATA_IN[15:8];
  assign _T_33 = io_DATA_IN[23:16];
  assign _T_34 = io_DATA_IN[31:24];
  assign _T_35 = {_T_33,_T_34};
  assign _T_36 = {_T_32,_T_35};
  assign _T_37 = {_T_31,_T_36};
  assign _T_40 = addrCnt_io_tot == 9'h100;
  assign _GEN_8 = _T_40 ? 2'h1 : _GEN_7;
  assign _T_42 = addr + 32'h4;
  assign _T_43 = _T_42[31:0];
  assign _GEN_9 = rdy_io_rising ? _GEN_8 : _GEN_7;
  assign _GEN_10 = rdy_io_rising ? _T_43 : _GEN_0;
  assign _GEN_11 = _T_18 ? _T_37 : _GEN_6;
  assign _GEN_12 = _T_18 ? 2'h3 : 2'h1;
  assign _GEN_13 = _T_18 ? _GEN_9 : _GEN_7;
  assign _GEN_14 = _T_18 ? _GEN_10 : _GEN_0;
  assign io_DATA_OUT = _GEN_11;
  assign io_deqRdy = _T_19;
  assign io_dataVal = _T_22;
  assign io_A = _GEN_12;
  assign rdy_io_in = _T_17;
  assign rdy_clock = clock;
  assign addrCnt_io_inc = _T_24;
  assign addrCnt_clock = clock;
  assign addrCnt_reset = reset;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  addr = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  state = _RAND_1[1:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      addr <= 32'h0;
    end else begin
      if (_T_18) begin
        if (rdy_io_rising) begin
          addr <= _T_43;
        end else begin
          if (io_ADDR_SET) begin
            addr <= io_ADDR_IN;
          end
        end
      end else begin
        if (io_ADDR_SET) begin
          addr <= io_ADDR_IN;
        end
      end
    end
    if (reset) begin
      state <= 2'h0;
    end else begin
      if (_T_18) begin
        if (rdy_io_rising) begin
          if (_T_40) begin
            state <= 2'h1;
          end else begin
            if (_T_28) begin
              if (rdy_io_rising) begin
                state <= 2'h2;
              end else begin
                if (_T_26) begin
                  if (rdy_io_rising) begin
                    state <= 2'h1;
                  end
                end
              end
            end else begin
              if (_T_26) begin
                if (rdy_io_rising) begin
                  state <= 2'h1;
                end
              end
            end
          end
        end else begin
          if (_T_28) begin
            if (rdy_io_rising) begin
              state <= 2'h2;
            end else begin
              if (_T_26) begin
                if (rdy_io_rising) begin
                  state <= 2'h1;
                end
              end
            end
          end else begin
            if (_T_26) begin
              if (rdy_io_rising) begin
                state <= 2'h1;
              end
            end
          end
        end
      end else begin
        if (_T_28) begin
          if (rdy_io_rising) begin
            state <= 2'h2;
          end else begin
            state <= _GEN_3;
          end
        end else begin
          state <= _GEN_3;
        end
      end
    end
  end
endmodule
module Timer(
  input        clock,
  input        reset,
  input  [3:0] io_period,
  output       io_fire
);
  reg [3:0] cnt;
  reg [31:0] _RAND_0;
  wire [4:0] _T_9;
  wire [3:0] _T_10;
  wire  _T_11;
  wire [3:0] _T_13;
  wire  _T_15;
  reg  _T_17;
  reg [31:0] _RAND_1;
  assign _T_9 = cnt + 4'h1;
  assign _T_10 = _T_9[3:0];
  assign _T_11 = _T_10 > io_period;
  assign _T_13 = _T_11 ? 4'h0 : _T_10;
  assign _T_15 = cnt == io_period;
  assign io_fire = _T_17;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  cnt = _RAND_0[3:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  _T_17 = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      cnt <= 4'h0;
    end else begin
      if (_T_11) begin
        cnt <= 4'h0;
      end else begin
        cnt <= _T_10;
      end
    end
    _T_17 <= _T_15;
  end
endmodule
module Counter_5(
  input        clock,
  input        reset,
  input        io_inc,
  output [5:0] io_tot,
  input        io_rst
);
  reg [5:0] _T_9;
  reg [31:0] _RAND_0;
  wire [6:0] _T_10;
  wire [5:0] _T_11;
  wire  _T_12;
  wire [5:0] _T_14;
  wire [5:0] _GEN_0;
  wire [5:0] _GEN_1;
  assign _T_10 = _T_9 + 6'h1;
  assign _T_11 = _T_10[5:0];
  assign _T_12 = _T_11 > 6'h35;
  assign _T_14 = _T_12 ? 6'h0 : _T_11;
  assign _GEN_0 = io_rst ? 6'h0 : _T_9;
  assign _GEN_1 = io_inc ? _T_14 : _GEN_0;
  assign io_tot = _T_9;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  _T_9 = _RAND_0[5:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      _T_9 <= 6'h0;
    end else begin
      if (io_inc) begin
        if (_T_12) begin
          _T_9 <= 6'h0;
        end else begin
          _T_9 <= _T_11;
        end
      end else begin
        if (io_rst) begin
          _T_9 <= 6'h0;
        end
      end
    end
  end
endmodule
module SWD(
  input         clock,
  input         reset,
  output        io_SWCLK,
  input  [31:0] io_DATA,
  input         io_DATA_READY,
  output        io_deqRdy,
  input  [3:0]  io_CLKDIV,
  input  [1:0]  io_A,
  input         io_D_IN_0,
  output        io_D_OUT_0,
  output        io_OUTPUT_ENABLE,
  output        io_ERROR,
  input         io_EN
);
  reg [31:0] swdio_out_reg;
  reg [31:0] _RAND_0;
  reg [2:0] swdio_response;
  reg [31:0] _RAND_1;
  reg [2:0] state;
  reg [31:0] _RAND_2;
  reg  SWCLKReg;
  reg [31:0] _RAND_3;
  wire  tmr_clock;
  wire  tmr_reset;
  wire [3:0] tmr_io_period;
  wire  tmr_io_fire;
  wire  SWCLKr_clock;
  wire  SWCLKr_io_in;
  wire  SWCLKr_io_out;
  wire  SWCLKr_io_rising;
  wire  SWCLKr_io_falling;
  wire  _T_23;
  wire  _T_24;
  wire  _T_25;
  wire  _T_26;
  wire  _T_27;
  wire  _GEN_0;
  reg  deqRdyr;
  reg [31:0] _RAND_4;
  wire  _T_30;
  wire  _T_31;
  reg  parity;
  reg [31:0] _RAND_5;
  reg  outbit;
  reg [31:0] _RAND_6;
  reg  outen;
  reg [31:0] _RAND_7;
  wire [2:0] _T_42;
  wire [5:0] _T_43;
  wire [7:0] packet;
  wire  bitcnt_clock;
  wire  bitcnt_reset;
  wire  bitcnt_io_inc;
  wire [5:0] bitcnt_io_tot;
  wire  bitcnt_io_rst;
  wire  _T_48;
  wire  _T_49;
  wire  _T_50;
  wire [2:0] _GEN_1;
  wire [2:0] _GEN_2;
  wire [31:0] _GEN_3;
  wire  _GEN_4;
  wire  _GEN_5;
  wire [2:0] _GEN_6;
  wire  _GEN_7;
  wire  _T_54;
  wire  _T_57;
  wire  _T_60;
  wire  _GEN_8;
  wire [30:0] _T_62;
  wire [31:0] _T_63;
  wire  _GEN_9;
  wire [31:0] _GEN_10;
  wire  _T_65;
  wire  _GEN_11;
  wire  _T_68;
  wire [2:0] _GEN_12;
  wire  _GEN_14;
  wire  _GEN_15;
  wire [31:0] _GEN_16;
  wire  _GEN_17;
  wire [2:0] _GEN_18;
  wire  _GEN_19;
  wire  _T_70;
  wire  _T_73;
  wire [2:0] _GEN_20;
  wire  _GEN_21;
  wire [2:0] _GEN_22;
  wire  _T_74;
  wire  _T_76;
  wire [2:0] _GEN_23;
  wire [31:0] _GEN_24;
  wire [1:0] _T_77;
  wire [2:0] _T_78;
  wire [2:0] _GEN_25;
  wire [2:0] _GEN_26;
  wire [31:0] _GEN_27;
  wire [2:0] _GEN_28;
  wire  _GEN_29;
  wire  _T_80;
  wire  _T_82;
  wire  _T_83;
  wire  _T_85;
  wire  _T_92;
  wire  _GEN_30;
  wire [2:0] _GEN_32;
  wire [2:0] _GEN_33;
  wire  _GEN_34;
  wire  _GEN_35;
  wire [31:0] _GEN_36;
  wire  _GEN_37;
  wire [2:0] _GEN_38;
  wire  _GEN_39;
  wire  _GEN_40;
  wire [31:0] _GEN_41;
  wire  _GEN_42;
  wire [2:0] _GEN_43;
  wire  _GEN_44;
  wire  _GEN_45;
  wire [31:0] _GEN_46;
  wire  _GEN_47;
  wire  _T_95;
  wire  _GEN_48;
  wire  _T_105;
  wire  _GEN_49;
  wire  _GEN_50;
  wire [31:0] _GEN_51;
  wire  _GEN_52;
  wire  _T_108;
  wire [2:0] _GEN_53;
  wire  _GEN_54;
  wire  _GEN_55;
  wire  _GEN_56;
  wire [31:0] _GEN_57;
  wire  _GEN_58;
  wire [2:0] _GEN_59;
  wire  _GEN_60;
  Timer tmr (
    .clock(tmr_clock),
    .reset(tmr_reset),
    .io_period(tmr_io_period),
    .io_fire(tmr_io_fire)
  );
  EdgeBuffer SWCLKr (
    .clock(SWCLKr_clock),
    .io_in(SWCLKr_io_in),
    .io_out(SWCLKr_io_out),
    .io_rising(SWCLKr_io_rising),
    .io_falling(SWCLKr_io_falling)
  );
  Counter_5 bitcnt (
    .clock(bitcnt_clock),
    .reset(bitcnt_reset),
    .io_inc(bitcnt_io_inc),
    .io_tot(bitcnt_io_tot),
    .io_rst(bitcnt_io_rst)
  );
  assign _T_23 = state != 3'h6;
  assign _T_24 = tmr_io_fire & _T_23;
  assign _T_25 = state != 3'h0;
  assign _T_26 = _T_24 & _T_25;
  assign _T_27 = ~ SWCLKReg;
  assign _GEN_0 = _T_26 ? _T_27 : SWCLKReg;
  assign _T_30 = deqRdyr & io_EN;
  assign _T_31 = state == 3'h6;
  assign _T_42 = {io_A,1'h0};
  assign _T_43 = {3'h4,_T_42};
  assign packet = {_T_43,2'h3};
  assign _T_48 = state == 3'h0;
  assign _T_49 = io_DATA_READY & io_EN;
  assign _T_50 = _T_49 & tmr_io_fire;
  assign _GEN_1 = _T_50 ? 3'h1 : state;
  assign _GEN_2 = _T_48 ? _GEN_1 : state;
  assign _GEN_3 = _T_48 ? {{24'd0}, packet} : swdio_out_reg;
  assign _GEN_4 = _T_48 ? 1'h0 : _GEN_0;
  assign _GEN_5 = _T_48 ? 1'h1 : parity;
  assign _GEN_6 = _T_48 ? 3'h0 : swdio_response;
  assign _GEN_7 = _T_48 ? io_EN : outen;
  assign _T_54 = state == 3'h1;
  assign _T_57 = swdio_out_reg[0];
  assign _T_60 = ~ parity;
  assign _GEN_8 = _T_57 ? _T_60 : _GEN_5;
  assign _T_62 = swdio_out_reg[31:1];
  assign _T_63 = {1'h0,_T_62};
  assign _GEN_9 = SWCLKr_io_falling ? _GEN_8 : _GEN_5;
  assign _GEN_10 = SWCLKr_io_falling ? _T_63 : _GEN_3;
  assign _T_65 = bitcnt_io_tot == 6'h5;
  assign _GEN_11 = _T_65 ? parity : _T_57;
  assign _T_68 = bitcnt_io_tot == 6'h8;
  assign _GEN_12 = _T_68 ? 3'h2 : _GEN_2;
  assign _GEN_14 = _T_54 ? 1'h0 : deqRdyr;
  assign _GEN_15 = _T_54 ? _GEN_9 : _GEN_5;
  assign _GEN_16 = _T_54 ? _GEN_10 : _GEN_3;
  assign _GEN_17 = _T_54 ? _GEN_11 : outbit;
  assign _GEN_18 = _T_54 ? _GEN_12 : _GEN_2;
  assign _GEN_19 = _T_54 ? 1'h1 : _GEN_7;
  assign _T_70 = state == 3'h2;
  assign _T_73 = bitcnt_io_tot == 6'h9;
  assign _GEN_20 = _T_73 ? 3'h3 : _GEN_18;
  assign _GEN_21 = _T_70 ? 1'h0 : _GEN_19;
  assign _GEN_22 = _T_70 ? _GEN_20 : _GEN_18;
  assign _T_74 = state == 3'h3;
  assign _T_76 = bitcnt_io_tot == 6'hc;
  assign _GEN_23 = _T_76 ? 3'h4 : _GEN_22;
  assign _GEN_24 = _T_76 ? io_DATA : _GEN_16;
  assign _T_77 = swdio_response[2:1];
  assign _T_78 = {io_D_IN_0,_T_77};
  assign _GEN_25 = SWCLKr_io_rising ? _T_78 : _GEN_6;
  assign _GEN_26 = _T_74 ? _GEN_23 : _GEN_22;
  assign _GEN_27 = _T_74 ? _GEN_24 : _GEN_16;
  assign _GEN_28 = _T_74 ? _GEN_25 : _GEN_6;
  assign _GEN_29 = _T_74 ? 1'h0 : _GEN_21;
  assign _T_80 = state == 3'h4;
  assign _T_82 = bitcnt_io_tot == 6'hd;
  assign _T_83 = _T_82 & SWCLKr_io_falling;
  assign _T_85 = swdio_response == 3'h1;
  assign _T_92 = swdio_response == 3'h2;
  assign _GEN_30 = _T_92 ? 1'h0 : _GEN_17;
  assign _GEN_32 = _T_92 ? 3'h0 : 3'h6;
  assign _GEN_33 = _T_85 ? 3'h5 : _GEN_32;
  assign _GEN_34 = _T_85 ? _T_57 : _GEN_30;
  assign _GEN_35 = _T_85 ? _T_57 : _GEN_15;
  assign _GEN_36 = _T_85 ? _T_63 : _GEN_27;
  assign _GEN_37 = _T_85 ? 1'h0 : _T_92;
  assign _GEN_38 = _T_83 ? _GEN_33 : _GEN_26;
  assign _GEN_39 = _T_83 ? _GEN_34 : _GEN_17;
  assign _GEN_40 = _T_83 ? _GEN_35 : _GEN_15;
  assign _GEN_41 = _T_83 ? _GEN_36 : _GEN_27;
  assign _GEN_42 = _T_83 ? _GEN_37 : 1'h0;
  assign _GEN_43 = _T_80 ? _GEN_38 : _GEN_26;
  assign _GEN_44 = _T_80 ? _GEN_39 : _GEN_17;
  assign _GEN_45 = _T_80 ? _GEN_40 : _GEN_15;
  assign _GEN_46 = _T_80 ? _GEN_41 : _GEN_27;
  assign _GEN_47 = _T_80 ? _GEN_42 : 1'h0;
  assign _T_95 = state == 3'h5;
  assign _GEN_48 = _T_57 ? _T_60 : _GEN_45;
  assign _T_105 = bitcnt_io_tot == 6'h2d;
  assign _GEN_49 = _T_105 ? parity : _T_57;
  assign _GEN_50 = SWCLKr_io_falling ? _GEN_48 : _GEN_45;
  assign _GEN_51 = SWCLKr_io_falling ? _T_63 : _GEN_46;
  assign _GEN_52 = SWCLKr_io_falling ? _GEN_49 : _GEN_44;
  assign _T_108 = bitcnt_io_tot == 6'h0;
  assign _GEN_53 = _T_108 ? 3'h0 : _GEN_43;
  assign _GEN_54 = _T_108 ? 1'h1 : _GEN_14;
  assign _GEN_55 = _T_95 ? 1'h1 : _GEN_29;
  assign _GEN_56 = _T_95 ? _GEN_50 : _GEN_45;
  assign _GEN_57 = _T_95 ? _GEN_51 : _GEN_46;
  assign _GEN_58 = _T_95 ? _GEN_52 : _GEN_44;
  assign _GEN_59 = _T_95 ? _GEN_53 : _GEN_43;
  assign _GEN_60 = _T_95 ? _GEN_54 : _GEN_14;
  assign io_SWCLK = SWCLKr_io_out;
  assign io_deqRdy = _T_30;
  assign io_D_OUT_0 = outbit;
  assign io_OUTPUT_ENABLE = outen;
  assign io_ERROR = _T_31;
  assign tmr_io_period = io_CLKDIV;
  assign tmr_clock = clock;
  assign tmr_reset = reset;
  assign SWCLKr_io_in = SWCLKReg;
  assign SWCLKr_clock = clock;
  assign bitcnt_io_inc = SWCLKr_io_rising;
  assign bitcnt_io_rst = _GEN_47;
  assign bitcnt_clock = clock;
  assign bitcnt_reset = reset;
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifndef verilator
      #0.002 begin end
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{$random}};
  swdio_out_reg = _RAND_0[31:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{$random}};
  swdio_response = _RAND_1[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{$random}};
  state = _RAND_2[2:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{$random}};
  SWCLKReg = _RAND_3[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{$random}};
  deqRdyr = _RAND_4[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_5 = {1{$random}};
  parity = _RAND_5[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_6 = {1{$random}};
  outbit = _RAND_6[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_7 = {1{$random}};
  outen = _RAND_7[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      swdio_out_reg <= 32'h0;
    end else begin
      if (_T_95) begin
        if (SWCLKr_io_falling) begin
          swdio_out_reg <= _T_63;
        end else begin
          if (_T_80) begin
            if (_T_83) begin
              if (_T_85) begin
                swdio_out_reg <= _T_63;
              end else begin
                if (_T_74) begin
                  if (_T_76) begin
                    swdio_out_reg <= io_DATA;
                  end else begin
                    if (_T_54) begin
                      if (SWCLKr_io_falling) begin
                        swdio_out_reg <= _T_63;
                      end else begin
                        if (_T_48) begin
                          swdio_out_reg <= {{24'd0}, packet};
                        end
                      end
                    end else begin
                      if (_T_48) begin
                        swdio_out_reg <= {{24'd0}, packet};
                      end
                    end
                  end
                end else begin
                  if (_T_54) begin
                    if (SWCLKr_io_falling) begin
                      swdio_out_reg <= _T_63;
                    end else begin
                      if (_T_48) begin
                        swdio_out_reg <= {{24'd0}, packet};
                      end
                    end
                  end else begin
                    if (_T_48) begin
                      swdio_out_reg <= {{24'd0}, packet};
                    end
                  end
                end
              end
            end else begin
              if (_T_74) begin
                if (_T_76) begin
                  swdio_out_reg <= io_DATA;
                end else begin
                  if (_T_54) begin
                    if (SWCLKr_io_falling) begin
                      swdio_out_reg <= _T_63;
                    end else begin
                      swdio_out_reg <= _GEN_3;
                    end
                  end else begin
                    swdio_out_reg <= _GEN_3;
                  end
                end
              end else begin
                if (_T_54) begin
                  if (SWCLKr_io_falling) begin
                    swdio_out_reg <= _T_63;
                  end else begin
                    swdio_out_reg <= _GEN_3;
                  end
                end else begin
                  swdio_out_reg <= _GEN_3;
                end
              end
            end
          end else begin
            if (_T_74) begin
              if (_T_76) begin
                swdio_out_reg <= io_DATA;
              end else begin
                swdio_out_reg <= _GEN_16;
              end
            end else begin
              swdio_out_reg <= _GEN_16;
            end
          end
        end
      end else begin
        if (_T_80) begin
          if (_T_83) begin
            if (_T_85) begin
              swdio_out_reg <= _T_63;
            end else begin
              if (_T_74) begin
                if (_T_76) begin
                  swdio_out_reg <= io_DATA;
                end else begin
                  swdio_out_reg <= _GEN_16;
                end
              end else begin
                swdio_out_reg <= _GEN_16;
              end
            end
          end else begin
            swdio_out_reg <= _GEN_27;
          end
        end else begin
          swdio_out_reg <= _GEN_27;
        end
      end
    end
    if (reset) begin
      swdio_response <= 3'h0;
    end else begin
      if (_T_74) begin
        if (SWCLKr_io_rising) begin
          swdio_response <= _T_78;
        end else begin
          if (_T_48) begin
            swdio_response <= 3'h0;
          end
        end
      end else begin
        if (_T_48) begin
          swdio_response <= 3'h0;
        end
      end
    end
    if (reset) begin
      state <= 3'h0;
    end else begin
      if (_T_95) begin
        if (_T_108) begin
          state <= 3'h0;
        end else begin
          if (_T_80) begin
            if (_T_83) begin
              if (_T_85) begin
                state <= 3'h5;
              end else begin
                if (_T_92) begin
                  state <= 3'h0;
                end else begin
                  state <= 3'h6;
                end
              end
            end else begin
              if (_T_74) begin
                if (_T_76) begin
                  state <= 3'h4;
                end else begin
                  if (_T_70) begin
                    if (_T_73) begin
                      state <= 3'h3;
                    end else begin
                      if (_T_54) begin
                        if (_T_68) begin
                          state <= 3'h2;
                        end else begin
                          if (_T_48) begin
                            if (_T_50) begin
                              state <= 3'h1;
                            end
                          end
                        end
                      end else begin
                        if (_T_48) begin
                          if (_T_50) begin
                            state <= 3'h1;
                          end
                        end
                      end
                    end
                  end else begin
                    if (_T_54) begin
                      if (_T_68) begin
                        state <= 3'h2;
                      end else begin
                        if (_T_48) begin
                          if (_T_50) begin
                            state <= 3'h1;
                          end
                        end
                      end
                    end else begin
                      if (_T_48) begin
                        if (_T_50) begin
                          state <= 3'h1;
                        end
                      end
                    end
                  end
                end
              end else begin
                if (_T_70) begin
                  if (_T_73) begin
                    state <= 3'h3;
                  end else begin
                    if (_T_54) begin
                      if (_T_68) begin
                        state <= 3'h2;
                      end else begin
                        state <= _GEN_2;
                      end
                    end else begin
                      state <= _GEN_2;
                    end
                  end
                end else begin
                  if (_T_54) begin
                    if (_T_68) begin
                      state <= 3'h2;
                    end else begin
                      state <= _GEN_2;
                    end
                  end else begin
                    state <= _GEN_2;
                  end
                end
              end
            end
          end else begin
            if (_T_74) begin
              if (_T_76) begin
                state <= 3'h4;
              end else begin
                if (_T_70) begin
                  if (_T_73) begin
                    state <= 3'h3;
                  end else begin
                    state <= _GEN_18;
                  end
                end else begin
                  state <= _GEN_18;
                end
              end
            end else begin
              if (_T_70) begin
                if (_T_73) begin
                  state <= 3'h3;
                end else begin
                  state <= _GEN_18;
                end
              end else begin
                state <= _GEN_18;
              end
            end
          end
        end
      end else begin
        if (_T_80) begin
          if (_T_83) begin
            if (_T_85) begin
              state <= 3'h5;
            end else begin
              if (_T_92) begin
                state <= 3'h0;
              end else begin
                state <= 3'h6;
              end
            end
          end else begin
            if (_T_74) begin
              if (_T_76) begin
                state <= 3'h4;
              end else begin
                state <= _GEN_22;
              end
            end else begin
              state <= _GEN_22;
            end
          end
        end else begin
          if (_T_74) begin
            if (_T_76) begin
              state <= 3'h4;
            end else begin
              state <= _GEN_22;
            end
          end else begin
            state <= _GEN_22;
          end
        end
      end
    end
    if (reset) begin
      SWCLKReg <= 1'h0;
    end else begin
      if (_T_48) begin
        SWCLKReg <= 1'h0;
      end else begin
        if (_T_26) begin
          SWCLKReg <= _T_27;
        end
      end
    end
    if (reset) begin
      deqRdyr <= 1'h1;
    end else begin
      if (_T_95) begin
        if (_T_108) begin
          deqRdyr <= 1'h1;
        end else begin
          if (_T_54) begin
            deqRdyr <= 1'h0;
          end
        end
      end else begin
        if (_T_54) begin
          deqRdyr <= 1'h0;
        end
      end
    end
    if (reset) begin
      parity <= 1'h0;
    end else begin
      if (_T_95) begin
        if (SWCLKr_io_falling) begin
          if (_T_57) begin
            parity <= _T_60;
          end else begin
            if (_T_80) begin
              if (_T_83) begin
                if (_T_85) begin
                  parity <= _T_57;
                end else begin
                  if (_T_54) begin
                    if (SWCLKr_io_falling) begin
                      if (_T_57) begin
                        parity <= _T_60;
                      end else begin
                        if (_T_48) begin
                          parity <= 1'h1;
                        end
                      end
                    end else begin
                      if (_T_48) begin
                        parity <= 1'h1;
                      end
                    end
                  end else begin
                    if (_T_48) begin
                      parity <= 1'h1;
                    end
                  end
                end
              end else begin
                if (_T_54) begin
                  if (SWCLKr_io_falling) begin
                    if (_T_57) begin
                      parity <= _T_60;
                    end else begin
                      if (_T_48) begin
                        parity <= 1'h1;
                      end
                    end
                  end else begin
                    parity <= _GEN_5;
                  end
                end else begin
                  parity <= _GEN_5;
                end
              end
            end else begin
              if (_T_54) begin
                if (SWCLKr_io_falling) begin
                  if (_T_57) begin
                    parity <= _T_60;
                  end else begin
                    parity <= _GEN_5;
                  end
                end else begin
                  parity <= _GEN_5;
                end
              end else begin
                parity <= _GEN_5;
              end
            end
          end
        end else begin
          if (_T_80) begin
            if (_T_83) begin
              if (_T_85) begin
                parity <= _T_57;
              end else begin
                if (_T_54) begin
                  if (SWCLKr_io_falling) begin
                    if (_T_57) begin
                      parity <= _T_60;
                    end else begin
                      parity <= _GEN_5;
                    end
                  end else begin
                    parity <= _GEN_5;
                  end
                end else begin
                  parity <= _GEN_5;
                end
              end
            end else begin
              parity <= _GEN_15;
            end
          end else begin
            parity <= _GEN_15;
          end
        end
      end else begin
        if (_T_80) begin
          if (_T_83) begin
            if (_T_85) begin
              parity <= _T_57;
            end else begin
              parity <= _GEN_15;
            end
          end else begin
            parity <= _GEN_15;
          end
        end else begin
          parity <= _GEN_15;
        end
      end
    end
    if (reset) begin
      outbit <= 1'h0;
    end else begin
      if (_T_95) begin
        if (SWCLKr_io_falling) begin
          if (_T_105) begin
            outbit <= parity;
          end else begin
            outbit <= _T_57;
          end
        end else begin
          if (_T_80) begin
            if (_T_83) begin
              if (_T_85) begin
                outbit <= _T_57;
              end else begin
                if (_T_92) begin
                  outbit <= 1'h0;
                end else begin
                  if (_T_54) begin
                    if (_T_65) begin
                      outbit <= parity;
                    end else begin
                      outbit <= _T_57;
                    end
                  end
                end
              end
            end else begin
              if (_T_54) begin
                if (_T_65) begin
                  outbit <= parity;
                end else begin
                  outbit <= _T_57;
                end
              end
            end
          end else begin
            if (_T_54) begin
              if (_T_65) begin
                outbit <= parity;
              end else begin
                outbit <= _T_57;
              end
            end
          end
        end
      end else begin
        if (_T_80) begin
          if (_T_83) begin
            if (_T_85) begin
              outbit <= _T_57;
            end else begin
              if (_T_92) begin
                outbit <= 1'h0;
              end else begin
                if (_T_54) begin
                  if (_T_65) begin
                    outbit <= parity;
                  end else begin
                    outbit <= _T_57;
                  end
                end
              end
            end
          end else begin
            outbit <= _GEN_17;
          end
        end else begin
          outbit <= _GEN_17;
        end
      end
    end
    if (reset) begin
      outen <= 1'h0;
    end else begin
      if (_T_95) begin
        outen <= 1'h1;
      end else begin
        if (_T_74) begin
          outen <= 1'h0;
        end else begin
          if (_T_70) begin
            outen <= 1'h0;
          end else begin
            if (_T_54) begin
              outen <= 1'h1;
            end else begin
              if (_T_48) begin
                outen <= io_EN;
              end
            end
          end
        end
      end
    end
  end
endmodule
module Top(
  input         clock,
  input         reset,
  input         io_MOSI,
  output        io_MISO,
  input         io_SCK,
  input         io_SSEL,
  output        io_FLASH_MOSI,
  input         io_FLASH_MISO,
  output        io_FLASH_SCK,
  output        io_FLASH_SSEL,
  output        io_SWCLK,
  output        io_SWDIO,
  input  [31:0] io_SPI_DATA,
  input         io_SPI_DATA_READY,
  output [23:0] io_SPI_READ_OUT,
  output        io_OUTPUT_ENABLE,
  output        io_D_OUT_0,
  input         io_D_IN_0,
  input  [31:0] io_FAST_READ_DATA,
  output        io_FAST_READ_DATA_READY
);
  wire  SB_PLL40_CORE_PLLOUTCORE;
  wire  SB_PLL40_CORE_REFERENCECLK;
  wire  SB_PLL40_CORE_BYPASS;
  wire  SB_PLL40_CORE_RESETB;
  wire  SB_PLL40_CORE_LOCK;
  wire  SPISlave_clock;
  wire  SPISlave_reset;
  wire  SPISlave_io_MOSI;
  wire  SPISlave_io_MISO;
  wire  SPISlave_io_SCK;
  wire  SPISlave_io_SSEL;
  wire  SPISlave_io_DATA_READY;
  wire [31:0] SPISlave_io_DATA;
  wire [23:0] SPISlave_io_READ_OUT;
  wire  SPIDecode_clock;
  wire [27:0] SPIDecode_io_dataIn;
  wire [23:0] SPIDecode_io_dataOut;
  wire [2:0] SPIDecode_io_addr;
  wire  SPIDecode_io_trigger;
  wire  SPIDecode_io_wclk;
  wire  StatusReg_clock;
  wire  StatusReg_reset;
  wire  StatusReg_io_en;
  wire  StatusReg_io_din;
  wire [1:0] StatusReg_io_dout;
  wire  StatusReg_io_done;
  wire  StatusReg_io_error;
  wire  _T_21;
  wire  _T_23;
  wire  _T_24;
  wire  AddrReg_clock;
  wire  AddrReg_reset;
  wire  AddrReg_io_en;
  wire [23:0] AddrReg_io_din;
  wire [23:0] AddrReg_io_dout;
  wire  _T_26;
  wire  _T_27;
  wire  LengthReg_clock;
  wire  LengthReg_reset;
  wire  LengthReg_io_en;
  wire  LengthReg_io_dec;
  wire [23:0] LengthReg_io_din;
  wire [23:0] LengthReg_io_dout;
  wire  _T_29;
  wire  _T_30;
  wire  ClkDivReg_clock;
  wire  ClkDivReg_reset;
  wire  ClkDivReg_io_en;
  wire [3:0] ClkDivReg_io_din;
  wire [3:0] ClkDivReg_io_dout;
  wire  _T_32;
  wire  _T_33;
  wire  AddrReg_1_clock;
  wire  AddrReg_1_reset;
  wire  AddrReg_1_io_en;
  wire [23:0] AddrReg_1_io_din;
  wire [23:0] AddrReg_1_io_dout;
  wire  _T_35;
  wire  _T_36;
  wire  _T_38;
  wire [23:0] _GEN_0;
  wire [23:0] _GEN_1;
  wire [23:0] _GEN_2;
  wire [23:0] _GEN_3;
  wire [23:0] _GEN_4;
  wire [23:0] _GEN_5;
  wire  _T_51;
  wire  _T_52;
  wire  EdgeBuffer_clock;
  wire  EdgeBuffer_io_in;
  wire  EdgeBuffer_io_out;
  wire  EdgeBuffer_io_rising;
  wire  EdgeBuffer_io_falling;
  wire  SPIFastRead_clock;
  wire  SPIFastRead_io_MOSI;
  wire  SPIFastRead_io_MISO;
  wire  SPIFastRead_io_SCK;
  wire  SPIFastRead_io_DATA_READY;
  wire [31:0] SPIFastRead_io_DATA;
  wire [23:0] SPIFastRead_io_ADDR;
  wire  SPIFastRead_io_EN;
  wire  SPIFastRead_io_enqRdy;
  wire  Fifo_clock;
  wire  Fifo_reset;
  wire  Fifo_io_enqVal;
  wire  Fifo_io_enqRdy;
  wire  Fifo_io_deqVal;
  wire  Fifo_io_deqRdy;
  wire [31:0] Fifo_io_enqDat;
  wire [31:0] Fifo_io_deqDat;
  wire  _T_54;
  wire  _T_56;
  wire  _T_57;
  wire  DoubleBarrel_clock;
  wire  DoubleBarrel_reset;
  wire [31:0] DoubleBarrel_io_ADDR_IN;
  wire  DoubleBarrel_io_ADDR_SET;
  wire  DoubleBarrel_io_DATA_READY;
  wire [31:0] DoubleBarrel_io_DATA_IN;
  wire [31:0] DoubleBarrel_io_DATA_OUT;
  wire  DoubleBarrel_io_TRIGGER;
  wire  DoubleBarrel_io_deqRdy;
  wire  DoubleBarrel_io_dataVal;
  wire  DoubleBarrel_io_EN;
  wire [1:0] DoubleBarrel_io_A;
  wire  SWD_clock;
  wire  SWD_reset;
  wire  SWD_io_SWCLK;
  wire [31:0] SWD_io_DATA;
  wire  SWD_io_DATA_READY;
  wire  SWD_io_deqRdy;
  wire [3:0] SWD_io_CLKDIV;
  wire [1:0] SWD_io_A;
  wire  SWD_io_D_IN_0;
  wire  SWD_io_D_OUT_0;
  wire  SWD_io_OUTPUT_ENABLE;
  wire  SWD_io_ERROR;
  wire  SWD_io_EN;
  wire  _T_58;
  wire  SB_IO_D_IN_0;
  wire  SB_IO_D_OUT_0;
  wire  SB_IO_OUTPUT_ENABLE;
  wire  SB_IO_PACKAGE_PIN;
  wire  SB_IO_1_D_IN_0;
  wire  SB_IO_1_D_OUT_0;
  wire  SB_IO_1_OUTPUT_ENABLE;
  wire  SB_IO_1_PACKAGE_PIN;
  wire  _T_61;
  wire  _T_62;
  wire  _T_63;
  SB_PLL40_CORE #(.PLLOUT_SELECT("GENCLK"), .DIVR(0), .DIVQ(2), .FEEDBACK_PATH("SIMPLE"), .DIVF(23), .FILTER_RANGE(2)) SB_PLL40_CORE (
    .PLLOUTCORE(SB_PLL40_CORE_PLLOUTCORE),
    .REFERENCECLK(SB_PLL40_CORE_REFERENCECLK),
    .BYPASS(SB_PLL40_CORE_BYPASS),
    .RESETB(SB_PLL40_CORE_RESETB),
    .LOCK(SB_PLL40_CORE_LOCK)
  );
  SPISlave SPISlave (
    .clock(SPISlave_clock),
    .reset(SPISlave_reset),
    .io_MOSI(SPISlave_io_MOSI),
    .io_MISO(SPISlave_io_MISO),
    .io_SCK(SPISlave_io_SCK),
    .io_SSEL(SPISlave_io_SSEL),
    .io_DATA_READY(SPISlave_io_DATA_READY),
    .io_DATA(SPISlave_io_DATA),
    .io_READ_OUT(SPISlave_io_READ_OUT)
  );
  SPIDecode SPIDecode (
    .clock(SPIDecode_clock),
    .io_dataIn(SPIDecode_io_dataIn),
    .io_dataOut(SPIDecode_io_dataOut),
    .io_addr(SPIDecode_io_addr),
    .io_trigger(SPIDecode_io_trigger),
    .io_wclk(SPIDecode_io_wclk)
  );
  StatusReg StatusReg (
    .clock(StatusReg_clock),
    .reset(StatusReg_reset),
    .io_en(StatusReg_io_en),
    .io_din(StatusReg_io_din),
    .io_dout(StatusReg_io_dout),
    .io_done(StatusReg_io_done),
    .io_error(StatusReg_io_error)
  );
  AddrReg AddrReg (
    .clock(AddrReg_clock),
    .reset(AddrReg_reset),
    .io_en(AddrReg_io_en),
    .io_din(AddrReg_io_din),
    .io_dout(AddrReg_io_dout)
  );
  LengthReg LengthReg (
    .clock(LengthReg_clock),
    .reset(LengthReg_reset),
    .io_en(LengthReg_io_en),
    .io_dec(LengthReg_io_dec),
    .io_din(LengthReg_io_din),
    .io_dout(LengthReg_io_dout)
  );
  ClkDivReg ClkDivReg (
    .clock(ClkDivReg_clock),
    .reset(ClkDivReg_reset),
    .io_en(ClkDivReg_io_en),
    .io_din(ClkDivReg_io_din),
    .io_dout(ClkDivReg_io_dout)
  );
  AddrReg AddrReg_1 (
    .clock(AddrReg_1_clock),
    .reset(AddrReg_1_reset),
    .io_en(AddrReg_1_io_en),
    .io_din(AddrReg_1_io_din),
    .io_dout(AddrReg_1_io_dout)
  );
  EdgeBuffer EdgeBuffer (
    .clock(EdgeBuffer_clock),
    .io_in(EdgeBuffer_io_in),
    .io_out(EdgeBuffer_io_out),
    .io_rising(EdgeBuffer_io_rising),
    .io_falling(EdgeBuffer_io_falling)
  );
  SPIFastRead SPIFastRead (
    .clock(SPIFastRead_clock),
    .io_MOSI(SPIFastRead_io_MOSI),
    .io_MISO(SPIFastRead_io_MISO),
    .io_SCK(SPIFastRead_io_SCK),
    .io_DATA_READY(SPIFastRead_io_DATA_READY),
    .io_DATA(SPIFastRead_io_DATA),
    .io_ADDR(SPIFastRead_io_ADDR),
    .io_EN(SPIFastRead_io_EN),
    .io_enqRdy(SPIFastRead_io_enqRdy)
  );
  Fifo Fifo (
    .clock(Fifo_clock),
    .reset(Fifo_reset),
    .io_enqVal(Fifo_io_enqVal),
    .io_enqRdy(Fifo_io_enqRdy),
    .io_deqVal(Fifo_io_deqVal),
    .io_deqRdy(Fifo_io_deqRdy),
    .io_enqDat(Fifo_io_enqDat),
    .io_deqDat(Fifo_io_deqDat)
  );
  DoubleBarrel DoubleBarrel (
    .clock(DoubleBarrel_clock),
    .reset(DoubleBarrel_reset),
    .io_ADDR_IN(DoubleBarrel_io_ADDR_IN),
    .io_ADDR_SET(DoubleBarrel_io_ADDR_SET),
    .io_DATA_READY(DoubleBarrel_io_DATA_READY),
    .io_DATA_IN(DoubleBarrel_io_DATA_IN),
    .io_DATA_OUT(DoubleBarrel_io_DATA_OUT),
    .io_TRIGGER(DoubleBarrel_io_TRIGGER),
    .io_deqRdy(DoubleBarrel_io_deqRdy),
    .io_dataVal(DoubleBarrel_io_dataVal),
    .io_EN(DoubleBarrel_io_EN),
    .io_A(DoubleBarrel_io_A)
  );
  SWD SWD (
    .clock(SWD_clock),
    .reset(SWD_reset),
    .io_SWCLK(SWD_io_SWCLK),
    .io_DATA(SWD_io_DATA),
    .io_DATA_READY(SWD_io_DATA_READY),
    .io_deqRdy(SWD_io_deqRdy),
    .io_CLKDIV(SWD_io_CLKDIV),
    .io_A(SWD_io_A),
    .io_D_IN_0(SWD_io_D_IN_0),
    .io_D_OUT_0(SWD_io_D_OUT_0),
    .io_OUTPUT_ENABLE(SWD_io_OUTPUT_ENABLE),
    .io_ERROR(SWD_io_ERROR),
    .io_EN(SWD_io_EN)
  );
  SB_IO #(.PIN_TYPE("6'b101001"), .PULLUP(0)) SB_IO (
    .D_IN_0(SB_IO_D_IN_0),
    .D_OUT_0(SB_IO_D_OUT_0),
    .OUTPUT_ENABLE(SB_IO_OUTPUT_ENABLE),
    .PACKAGE_PIN(SB_IO_PACKAGE_PIN)
  );
  SB_IO #(.PIN_TYPE("6'b101001"), .PULLUP(0)) SB_IO_1 (
    .D_IN_0(SB_IO_1_D_IN_0),
    .D_OUT_0(SB_IO_1_D_OUT_0),
    .OUTPUT_ENABLE(SB_IO_1_OUTPUT_ENABLE),
    .PACKAGE_PIN(SB_IO_1_PACKAGE_PIN)
  );
  assign _T_21 = SPIDecode_io_dataOut[0];
  assign _T_23 = SPIDecode_io_addr == 3'h1;
  assign _T_24 = _T_23 & SPIDecode_io_wclk;
  assign _T_26 = SPIDecode_io_addr == 3'h2;
  assign _T_27 = _T_26 & SPIDecode_io_wclk;
  assign _T_29 = SPIDecode_io_addr == 3'h3;
  assign _T_30 = _T_29 & SPIDecode_io_wclk;
  assign _T_32 = SPIDecode_io_addr == 3'h4;
  assign _T_33 = _T_32 & SPIDecode_io_wclk;
  assign _T_35 = SPIDecode_io_addr == 3'h5;
  assign _T_36 = _T_35 & SPIDecode_io_wclk;
  assign _T_38 = SPIDecode_io_addr == 3'h0;
  assign _GEN_0 = _T_35 ? AddrReg_1_io_dout : 24'h0;
  assign _GEN_1 = _T_32 ? {{20'd0}, ClkDivReg_io_dout} : _GEN_0;
  assign _GEN_2 = _T_29 ? LengthReg_io_dout : _GEN_1;
  assign _GEN_3 = _T_26 ? AddrReg_io_dout : _GEN_2;
  assign _GEN_4 = _T_23 ? {{22'd0}, StatusReg_io_dout} : _GEN_3;
  assign _GEN_5 = _T_38 ? 24'h55 : _GEN_4;
  assign _T_51 = StatusReg_io_dout[0];
  assign _T_52 = ~ _T_51;
  assign _T_54 = SPIFastRead_io_DATA_READY & EdgeBuffer_io_out;
  assign _T_56 = LengthReg_io_dout != 24'h0;
  assign _T_57 = _T_56 & EdgeBuffer_io_out;
  assign _T_58 = DoubleBarrel_io_dataVal & Fifo_io_deqVal;
  assign _T_61 = LengthReg_io_dout == 24'h0;
  assign _T_62 = ~ Fifo_io_deqVal;
  assign _T_63 = _T_61 & _T_62;
  assign io_MISO = SPISlave_io_MISO;
  assign io_FLASH_MOSI = SPIFastRead_io_MOSI;
  assign io_FLASH_SCK = SPIFastRead_io_SCK;
  assign io_FLASH_SSEL = _T_52;
  assign io_SWCLK = SB_IO_PACKAGE_PIN;
  assign io_SWDIO = SB_IO_1_PACKAGE_PIN;
  assign io_SPI_READ_OUT = 24'h0;
  assign io_OUTPUT_ENABLE = 1'h0;
  assign io_D_OUT_0 = 1'h0;
  assign io_FAST_READ_DATA_READY = 1'h0;
  assign SB_PLL40_CORE_REFERENCECLK = clock;
  assign SB_PLL40_CORE_BYPASS = 1'h0;
  assign SB_PLL40_CORE_RESETB = 1'h0;
  assign SPISlave_io_MOSI = io_MOSI;
  assign SPISlave_io_SCK = io_SCK;
  assign SPISlave_io_SSEL = io_SSEL;
  assign SPISlave_io_READ_OUT = _GEN_5;
  assign SPISlave_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign SPISlave_reset = reset;
  assign SPIDecode_io_dataIn = SPISlave_io_DATA[27:0];
  assign SPIDecode_io_trigger = SPISlave_io_DATA_READY;
  assign SPIDecode_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign StatusReg_io_en = _T_24;
  assign StatusReg_io_din = _T_21;
  assign StatusReg_io_done = _T_63;
  assign StatusReg_io_error = SWD_io_ERROR;
  assign StatusReg_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign StatusReg_reset = reset;
  assign AddrReg_io_en = _T_27;
  assign AddrReg_io_din = SPIDecode_io_dataOut;
  assign AddrReg_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign AddrReg_reset = reset;
  assign LengthReg_io_en = _T_30;
  assign LengthReg_io_dec = SPIFastRead_io_DATA_READY;
  assign LengthReg_io_din = SPIDecode_io_dataOut;
  assign LengthReg_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign LengthReg_reset = reset;
  assign ClkDivReg_io_en = _T_33;
  assign ClkDivReg_io_din = SPIDecode_io_dataOut[3:0];
  assign ClkDivReg_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign ClkDivReg_reset = reset;
  assign AddrReg_1_io_en = _T_36;
  assign AddrReg_1_io_din = SPIDecode_io_dataOut;
  assign AddrReg_1_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign AddrReg_1_reset = reset;
  assign EdgeBuffer_io_in = _T_51;
  assign EdgeBuffer_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign SPIFastRead_io_MISO = io_FLASH_MISO;
  assign SPIFastRead_io_ADDR = AddrReg_io_dout;
  assign SPIFastRead_io_EN = _T_57;
  assign SPIFastRead_io_enqRdy = Fifo_io_enqRdy;
  assign SPIFastRead_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign Fifo_io_enqVal = _T_54;
  assign Fifo_io_deqRdy = DoubleBarrel_io_deqRdy;
  assign Fifo_io_enqDat = SPIFastRead_io_DATA;
  assign Fifo_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign Fifo_reset = reset;
  assign DoubleBarrel_io_ADDR_IN = {{8'd0}, AddrReg_1_io_dout};
  assign DoubleBarrel_io_ADDR_SET = EdgeBuffer_io_rising;
  assign DoubleBarrel_io_DATA_READY = Fifo_io_deqVal;
  assign DoubleBarrel_io_DATA_IN = Fifo_io_deqDat;
  assign DoubleBarrel_io_TRIGGER = SWD_io_deqRdy;
  assign DoubleBarrel_io_EN = EdgeBuffer_io_out;
  assign DoubleBarrel_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign DoubleBarrel_reset = reset;
  assign SWD_io_DATA = DoubleBarrel_io_DATA_OUT;
  assign SWD_io_DATA_READY = _T_58;
  assign SWD_io_CLKDIV = ClkDivReg_io_dout;
  assign SWD_io_A = DoubleBarrel_io_A;
  assign SWD_io_D_IN_0 = SB_IO_1_D_IN_0;
  assign SWD_io_EN = EdgeBuffer_io_out;
  assign SWD_clock = SB_PLL40_CORE_PLLOUTCORE;
  assign SWD_reset = reset;
  assign SB_IO_D_OUT_0 = SWD_io_SWCLK;
  assign SB_IO_OUTPUT_ENABLE = EdgeBuffer_io_out;
  assign SB_IO_1_D_OUT_0 = SWD_io_D_OUT_0;
  assign SB_IO_1_OUTPUT_ENABLE = SWD_io_OUTPUT_ENABLE;
endmodule
