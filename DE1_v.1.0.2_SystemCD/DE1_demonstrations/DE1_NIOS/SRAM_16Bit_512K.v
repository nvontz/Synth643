module	SRAM_16Bit_512K(//	Host Data
						oDATA,iDATA,iADDR,
						iWE_N,iOE_N,
						iCE_N,iRST_N,
						iUB_N,iLB_N,
						//	SRAM
						SRAM_DQ,
						SRAM_ADDR,
						SRAM_UB_N,
						SRAM_LB_N,
						SRAM_WE_N,
						SRAM_CE_N,
						SRAM_OE_N
						);
//	Host Side
input	[15:0]	iDATA;
output	[15:0]	oDATA;
input	[17:0]	iADDR;
input			iWE_N,iOE_N;
input			iCE_N,iRST_N;
input			iUB_N,iLB_N;
//	SRAM Side
inout	[15:0]	SRAM_DQ;
output	[17:0]	SRAM_ADDR;
output			SRAM_UB_N,
				SRAM_LB_N,
				SRAM_WE_N,
				SRAM_CE_N,
				SRAM_OE_N;

assign	SRAM_DQ 	=	SRAM_WE_N ? 16'hzzzz : iDATA;
assign	oDATA		=	SRAM_DQ;
assign	SRAM_ADDR	=	iADDR;
assign	SRAM_WE_N	=	iWE_N;
assign	SRAM_OE_N	=	iOE_N;
assign	SRAM_CE_N	=	iCE_N;
assign	SRAM_RST_N	=	iRST_N;
assign	SRAM_UB_N	=	iUB_N;
assign	SRAM_LB_N	=	iLB_N;

endmodule