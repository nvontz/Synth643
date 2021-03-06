
// 3-digit BCD counter with seven segment outputs
// ctr_3digit_sseg.v
// Don M. Gruenbacher
// August 28, 2021

`timescale 100 ns / 1 ns

module ctr_3digit_sseg (clk, ar, e_in, digit5_leds, digit4_leds, digit3_leds, digit2_leds, digit1_leds, digit0_leds);
	input  clk, ar, e_in;
	output [6:0] digit5_leds, digit4_leds, digit3_leds, digit2_leds, digit1_leds, digit0_leds; // Digit5=most signif.
	
	
	
	// Internal declarations 
	
	wire [3:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0;
	wire		en_ctr5, en_ctr4, en_ctr3, en_ctr2, en_ctr1;   // Input enables
	wire		en_out_ctr0, en_out_ctr1, en_out_ctr2, en_out_ctr3, en_out_ctr4, en_out_ctr5;
	
	
	// Instantiate the counters and generate the Ctr2 input enable
	
	assign en_ctr1 = ~e_in & en_out_ctr0;
	assign en_ctr2 = en_ctr1 & en_out_ctr1;
	assign en_ctr3 = en_ctr2 & en_out_ctr2;
	assign en_ctr4 = en_ctr3 & en_out_ctr3;
	assign en_ctr5 = en_ctr4 & en_out_ctr4;
	
	
	ctr_bcd_en dig0_ctr (.clk(clk), .ar(ar), .en_in(~e_in),  // Ctr always enabled
							.en_out(en_out_ctr0), .q(bcd0));

	ctr_bcd_en dig1_ctr (.clk(clk), .ar(ar), .en_in(en_ctr1),  
							.en_out(en_out_ctr1), .q(bcd1));

	ctr_bcd_en dig2_ctr (.clk(clk), .ar(ar), .en_in(en_ctr2),  
							.en_out(en_out_ctr2), .q(bcd2));
							
	ctr_bcd_en dig3_ctr (.clk(clk), .ar(ar), .en_in(en_ctr3),  
							.en_out(en_out_ctr3), .q(bcd3));
							
	ctr_bcd_en dig4_ctr (.clk(clk), .ar(ar), .en_in(en_ctr4),  
							.en_out(en_out_ctr4), .q(bcd4));
							
	ctr_bcd_en dig5_ctr (.clk(clk), .ar(ar), .en_in(en_ctr5),  
							.en_out(en_out_ctr5), .q(bcd5));
							

	// Instantiate the 7-segment decoders
	
	sevseg_dec dec0 (.x_in(bcd0), .segs(digit0_leds));
	sevseg_dec dec1 (.x_in(bcd1), .segs(digit1_leds));
	sevseg_dec dec2 (.x_in(bcd2), .segs(digit2_leds));
	sevseg_dec dec3 (.x_in(bcd3), .segs(digit3_leds));
	sevseg_dec dec4 (.x_in(bcd4), .segs(digit4_leds));
	sevseg_dec dec5 (.x_in(bcd5), .segs(digit5_leds));
	

endmodule
