/* Quartus Prime Version 17.1.0 Build 590 10/25/2017 SJ Lite Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("C:/Users/nvontz/Documents/lab4week3fixed/lab4week3/lab4/lab4/my_first_hps-fpga_base/quartus/") File("soc_system.sof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(5CSEMA5F31) Path("C:/Users/nvontz/Documents/lab4week3fixed/lab4week3/lab4/lab4/my_first_hps-fpga_base/quartus/") File("soc_system.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
