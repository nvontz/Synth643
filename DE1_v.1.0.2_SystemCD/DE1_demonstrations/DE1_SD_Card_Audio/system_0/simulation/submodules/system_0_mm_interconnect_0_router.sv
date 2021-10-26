// (C) 2001-2017 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/17.1std/ip/merlin/altera_merlin_router/altera_merlin_router.sv.terp#1 $
// $Revision: #1 $
// $Date: 2017/07/30 $
// $Author: swbranch $

// -------------------------------------------------------
// Merlin Router
//
// Asserts the appropriate one-hot encoded channel based on 
// either (a) the address or (b) the dest id. The DECODER_TYPE
// parameter controls this behaviour. 0 means address decoder,
// 1 means dest id decoder.
//
// In the case of (a), it also sets the destination id.
// -------------------------------------------------------

`timescale 1 ns / 1 ns

module system_0_mm_interconnect_0_router_default_decode
  #(
     parameter DEFAULT_CHANNEL = 16,
               DEFAULT_WR_CHANNEL = -1,
               DEFAULT_RD_CHANNEL = -1,
               DEFAULT_DESTID = 12 
   )
  (output [91 - 87 : 0] default_destination_id,
   output [18-1 : 0] default_wr_channel,
   output [18-1 : 0] default_rd_channel,
   output [18-1 : 0] default_src_channel
  );

  assign default_destination_id = 
    DEFAULT_DESTID[91 - 87 : 0];

  generate
    if (DEFAULT_CHANNEL == -1) begin : no_default_channel_assignment
      assign default_src_channel = '0;
    end
    else begin : default_channel_assignment
      assign default_src_channel = 18'b1 << DEFAULT_CHANNEL;
    end
  endgenerate

  generate
    if (DEFAULT_RD_CHANNEL == -1) begin : no_default_rw_channel_assignment
      assign default_wr_channel = '0;
      assign default_rd_channel = '0;
    end
    else begin : default_rw_channel_assignment
      assign default_wr_channel = 18'b1 << DEFAULT_WR_CHANNEL;
      assign default_rd_channel = 18'b1 << DEFAULT_RD_CHANNEL;
    end
  endgenerate

endmodule


module system_0_mm_interconnect_0_router
(
    // -------------------
    // Clock & Reset
    // -------------------
    input clk,
    input reset,

    // -------------------
    // Command Sink (Input)
    // -------------------
    input                       sink_valid,
    input  [105-1 : 0]    sink_data,
    input                       sink_startofpacket,
    input                       sink_endofpacket,
    output                      sink_ready,

    // -------------------
    // Command Source (Output)
    // -------------------
    output                          src_valid,
    output reg [105-1    : 0] src_data,
    output reg [18-1 : 0] src_channel,
    output                          src_startofpacket,
    output                          src_endofpacket,
    input                           src_ready
);

    // -------------------------------------------------------
    // Local parameters and variables
    // -------------------------------------------------------
    localparam PKT_ADDR_H = 60;
    localparam PKT_ADDR_L = 36;
    localparam PKT_DEST_ID_H = 91;
    localparam PKT_DEST_ID_L = 87;
    localparam PKT_PROTECTION_H = 95;
    localparam PKT_PROTECTION_L = 93;
    localparam ST_DATA_W = 105;
    localparam ST_CHANNEL_W = 18;
    localparam DECODER_TYPE = 0;

    localparam PKT_TRANS_WRITE = 63;
    localparam PKT_TRANS_READ  = 64;

    localparam PKT_ADDR_W = PKT_ADDR_H-PKT_ADDR_L + 1;
    localparam PKT_DEST_ID_W = PKT_DEST_ID_H-PKT_DEST_ID_L + 1;



    // -------------------------------------------------------
    // Figure out the number of bits to mask off for each slave span
    // during address decoding
    // -------------------------------------------------------
    localparam PAD0 = log2ceil(64'h800000 - 64'h0); 
    localparam PAD1 = log2ceil(64'h1000000 - 64'hc00000); 
    localparam PAD2 = log2ceil(64'h1100000 - 64'h1080000); 
    localparam PAD3 = log2ceil(64'h1101800 - 64'h1101000); 
    localparam PAD4 = log2ceil(64'h1102000 - 64'h1101800); 
    localparam PAD5 = log2ceil(64'h1102020 - 64'h1102000); 
    localparam PAD6 = log2ceil(64'h1102040 - 64'h1102020); 
    localparam PAD7 = log2ceil(64'h1102060 - 64'h1102040); 
    localparam PAD8 = log2ceil(64'h1102070 - 64'h1102060); 
    localparam PAD9 = log2ceil(64'h1102080 - 64'h1102070); 
    localparam PAD10 = log2ceil(64'h1102090 - 64'h1102080); 
    localparam PAD11 = log2ceil(64'h11020a0 - 64'h1102090); 
    localparam PAD12 = log2ceil(64'h11020b0 - 64'h11020a0); 
    localparam PAD13 = log2ceil(64'h11020c0 - 64'h11020b0); 
    localparam PAD14 = log2ceil(64'h11020d0 - 64'h11020c0); 
    localparam PAD15 = log2ceil(64'h11020d8 - 64'h11020d0); 
    localparam PAD16 = log2ceil(64'h11020dc - 64'h11020d8); 
    localparam PAD17 = log2ceil(64'h11020e0 - 64'h11020dc); 
    // -------------------------------------------------------
    // Work out which address bits are significant based on the
    // address range of the slaves. If the required width is too
    // large or too small, we use the address field width instead.
    // -------------------------------------------------------
    localparam ADDR_RANGE = 64'h11020e0;
    localparam RANGE_ADDR_WIDTH = log2ceil(ADDR_RANGE);
    localparam OPTIMIZED_ADDR_H = (RANGE_ADDR_WIDTH > PKT_ADDR_W) ||
                                  (RANGE_ADDR_WIDTH == 0) ?
                                        PKT_ADDR_H :
                                        PKT_ADDR_L + RANGE_ADDR_WIDTH - 1;

    localparam RG = RANGE_ADDR_WIDTH-1;
    localparam REAL_ADDRESS_RANGE = OPTIMIZED_ADDR_H - PKT_ADDR_L;

      reg [PKT_ADDR_W-1 : 0] address;
      always @* begin
        address = {PKT_ADDR_W{1'b0}};
        address [REAL_ADDRESS_RANGE:0] = sink_data[OPTIMIZED_ADDR_H : PKT_ADDR_L];
      end   

    // -------------------------------------------------------
    // Pass almost everything through, untouched
    // -------------------------------------------------------
    assign sink_ready        = src_ready;
    assign src_valid         = sink_valid;
    assign src_startofpacket = sink_startofpacket;
    assign src_endofpacket   = sink_endofpacket;
    wire [PKT_DEST_ID_W-1:0] default_destid;
    wire [18-1 : 0] default_src_channel;




    // -------------------------------------------------------
    // Write and read transaction signals
    // -------------------------------------------------------
    wire write_transaction;
    assign write_transaction = sink_data[PKT_TRANS_WRITE];
    wire read_transaction;
    assign read_transaction  = sink_data[PKT_TRANS_READ];


    system_0_mm_interconnect_0_router_default_decode the_default_decode(
      .default_destination_id (default_destid),
      .default_wr_channel   (),
      .default_rd_channel   (),
      .default_src_channel  (default_src_channel)
    );

    always @* begin
        src_data    = sink_data;
        src_channel = default_src_channel;
        src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = default_destid;

        // --------------------------------------------------
        // Address Decoder
        // Sets the channel and destination ID based on the address
        // --------------------------------------------------

    // ( 0x0 .. 0x800000 )
    if ( {address[RG:PAD0],{PAD0{1'b0}}} == 25'h0   ) begin
            src_channel = 18'b010000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 12;
    end

    // ( 0xc00000 .. 0x1000000 )
    if ( {address[RG:PAD1],{PAD1{1'b0}}} == 25'hc00000   ) begin
            src_channel = 18'b100000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 6;
    end

    // ( 0x1080000 .. 0x1100000 )
    if ( {address[RG:PAD2],{PAD2{1'b0}}} == 25'h1080000   ) begin
            src_channel = 18'b000000000000000100;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 13;
    end

    // ( 0x1101000 .. 0x1101800 )
    if ( {address[RG:PAD3],{PAD3{1'b0}}} == 25'h1101000   ) begin
            src_channel = 18'b000000000000010000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 11;
    end

    // ( 0x1101800 .. 0x1102000 )
    if ( {address[RG:PAD4],{PAD4{1'b0}}} == 25'h1101800   ) begin
            src_channel = 18'b000000000000100000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 7;
    end

    // ( 0x1102000 .. 0x1102020 )
    if ( {address[RG:PAD5],{PAD5{1'b0}}} == 25'h1102000   ) begin
            src_channel = 18'b000010000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 16;
    end

    // ( 0x1102020 .. 0x1102040 )
    if ( {address[RG:PAD6],{PAD6{1'b0}}} == 25'h1102020   ) begin
            src_channel = 18'b000100000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 15;
    end

    // ( 0x1102040 .. 0x1102060 )
    if ( {address[RG:PAD7],{PAD7{1'b0}}} == 25'h1102040   ) begin
            src_channel = 18'b001000000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 17;
    end

    // ( 0x1102060 .. 0x1102070 )
    if ( {address[RG:PAD8],{PAD8{1'b0}}} == 25'h1102060   ) begin
            src_channel = 18'b000000000001000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 9;
    end

    // ( 0x1102070 .. 0x1102080 )
    if ( {address[RG:PAD9],{PAD9{1'b0}}} == 25'h1102070   ) begin
            src_channel = 18'b000000000010000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 10;
    end

    // ( 0x1102080 .. 0x1102090 )
    if ( {address[RG:PAD10],{PAD10{1'b0}}} == 25'h1102080   ) begin
            src_channel = 18'b000000000100000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 1;
    end

    // ( 0x1102090 .. 0x11020a0 )
    if ( {address[RG:PAD11],{PAD11{1'b0}}} == 25'h1102090   ) begin
            src_channel = 18'b000000001000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 2;
    end

    // ( 0x11020a0 .. 0x11020b0 )
    if ( {address[RG:PAD12],{PAD12{1'b0}}} == 25'h11020a0   ) begin
            src_channel = 18'b000000010000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 3;
    end

    // ( 0x11020b0 .. 0x11020c0 )
    if ( {address[RG:PAD13],{PAD13{1'b0}}} == 25'h11020b0  && read_transaction  ) begin
            src_channel = 18'b000000100000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 14;
    end

    // ( 0x11020c0 .. 0x11020d0 )
    if ( {address[RG:PAD14],{PAD14{1'b0}}} == 25'h11020c0   ) begin
            src_channel = 18'b000001000000000000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 5;
    end

    // ( 0x11020d0 .. 0x11020d8 )
    if ( {address[RG:PAD15],{PAD15{1'b0}}} == 25'h11020d0   ) begin
            src_channel = 18'b000000000000000001;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 8;
    end

    // ( 0x11020d8 .. 0x11020dc )
    if ( {address[RG:PAD16],{PAD16{1'b0}}} == 25'h11020d8   ) begin
            src_channel = 18'b000000000000001000;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 0;
    end

    // ( 0x11020dc .. 0x11020e0 )
    if ( {address[RG:PAD17],{PAD17{1'b0}}} == 25'h11020dc  && write_transaction  ) begin
            src_channel = 18'b000000000000000010;
            src_data[PKT_DEST_ID_H:PKT_DEST_ID_L] = 4;
    end

end


    // --------------------------------------------------
    // Ceil(log2()) function
    // --------------------------------------------------
    function integer log2ceil;
        input reg[65:0] val;
        reg [65:0] i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1;
            end
        end
    endfunction

endmodule


