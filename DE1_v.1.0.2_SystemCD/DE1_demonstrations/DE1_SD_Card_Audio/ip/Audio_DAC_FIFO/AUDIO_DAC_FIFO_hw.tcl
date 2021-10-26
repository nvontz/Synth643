# TCL File Generated by Component Editor 11.1sp1
# Tue Jan 31 09:48:28 CST 2012
# DO NOT MODIFY


# +-----------------------------------
# | 
# | audio_dac_fifo "AUDIO_DAC_FIFO" v1.0.2
# | null 2012.01.31.09:48:28
# | 
# | 
# | D:/SVN/DE2/DE2/test/SOPC_Q11_1/DE2_NIOS_HOST_MOUSE_VGA/Audio_DAC_FIFO/hdl/AUDIO_DAC_FIFO.v
# | 
# |    ./hdl/AUDIO_DAC_FIFO.v syn, sim
# |    ./hdl/FIFO_16_256.v syn, sim
# | 
# +-----------------------------------

# +-----------------------------------
# | request TCL package from ACDS 11.0
# | 
package require -exact sopc 11.0
# | 
# +-----------------------------------

# +-----------------------------------
# | module audio_dac_fifo
# | 
set_module_property NAME audio_dac_fifo
set_module_property VERSION 1.0.2
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP "Terasic Technologies Inc"
set_module_property DISPLAY_NAME AUDIO_DAC_FIFO
set_module_property TOP_LEVEL_HDL_FILE hdl/AUDIO_DAC_FIFO.v
set_module_property TOP_LEVEL_HDL_MODULE AUDIO_DAC_FIFO
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL TRUE
set_module_property STATIC_TOP_LEVEL_MODULE_NAME AUDIO_DAC_FIFO
set_module_property FIX_110_VIP_PATH false
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
add_file hdl/AUDIO_DAC_FIFO.v {SYNTHESIS SIMULATION}
add_file hdl/FIFO_16_256.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter REF_CLK INTEGER 18432000 ""
set_parameter_property REF_CLK DEFAULT_VALUE 18432000
set_parameter_property REF_CLK DISPLAY_NAME REF_CLK
set_parameter_property REF_CLK TYPE INTEGER
set_parameter_property REF_CLK UNITS None
set_parameter_property REF_CLK ALLOWED_RANGES -2147483648:2147483647
set_parameter_property REF_CLK DESCRIPTION ""
set_parameter_property REF_CLK AFFECTS_GENERATION false
set_parameter_property REF_CLK HDL_PARAMETER true
add_parameter SAMPLE_RATE INTEGER 48000 ""
set_parameter_property SAMPLE_RATE DEFAULT_VALUE 48000
set_parameter_property SAMPLE_RATE DISPLAY_NAME SAMPLE_RATE
set_parameter_property SAMPLE_RATE TYPE INTEGER
set_parameter_property SAMPLE_RATE UNITS None
set_parameter_property SAMPLE_RATE ALLOWED_RANGES -2147483648:2147483647
set_parameter_property SAMPLE_RATE DESCRIPTION ""
set_parameter_property SAMPLE_RATE AFFECTS_GENERATION false
set_parameter_property SAMPLE_RATE HDL_PARAMETER true
add_parameter DATA_WIDTH INTEGER 16 ""
set_parameter_property DATA_WIDTH DEFAULT_VALUE 16
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH TYPE INTEGER
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DESCRIPTION ""
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
add_parameter CHANNEL_NUM INTEGER 2 ""
set_parameter_property CHANNEL_NUM DEFAULT_VALUE 2
set_parameter_property CHANNEL_NUM DISPLAY_NAME CHANNEL_NUM
set_parameter_property CHANNEL_NUM TYPE INTEGER
set_parameter_property CHANNEL_NUM UNITS None
set_parameter_property CHANNEL_NUM ALLOWED_RANGES -2147483648:2147483647
set_parameter_property CHANNEL_NUM DESCRIPTION ""
set_parameter_property CHANNEL_NUM AFFECTS_GENERATION false
set_parameter_property CHANNEL_NUM HDL_PARAMETER true
# | 
# +-----------------------------------

# +-----------------------------------
# | display items
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clk
# | 
add_interface clk clock end
set_interface_property clk clockRate 0

set_interface_property clk ENABLED true

add_interface_port clk iWR_CLK clk Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_slave_0_export
# | 
add_interface avalon_slave_0_export conduit end

set_interface_property avalon_slave_0_export ENABLED true

add_interface_port avalon_slave_0_export oAUD_DATA export Output 1
add_interface_port avalon_slave_0_export oAUD_LRCK export Output 1
add_interface_port avalon_slave_0_export oAUD_BCK export Output 1
add_interface_port avalon_slave_0_export oAUD_XCK export Output 1
add_interface_port avalon_slave_0_export iCLK_18_4 export Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point avalon_slave_0
# | 
add_interface avalon_slave_0 avalon end
set_interface_property avalon_slave_0 addressAlignment NATIVE
set_interface_property avalon_slave_0 addressUnits WORDS
set_interface_property avalon_slave_0 associatedClock clk
set_interface_property avalon_slave_0 associatedReset reset_n
set_interface_property avalon_slave_0 burstOnBurstBoundariesOnly false
set_interface_property avalon_slave_0 explicitAddressSpan 1
set_interface_property avalon_slave_0 holdTime 0
set_interface_property avalon_slave_0 isMemoryDevice false
set_interface_property avalon_slave_0 isNonVolatileStorage false
set_interface_property avalon_slave_0 linewrapBursts false
set_interface_property avalon_slave_0 maximumPendingReadTransactions 0
set_interface_property avalon_slave_0 printableDevice false
set_interface_property avalon_slave_0 readLatency 0
set_interface_property avalon_slave_0 readWaitStates 0
set_interface_property avalon_slave_0 readWaitTime 0
set_interface_property avalon_slave_0 setupTime 0
set_interface_property avalon_slave_0 timingUnits Cycles
set_interface_property avalon_slave_0 writeWaitTime 0

set_interface_property avalon_slave_0 ENABLED true

add_interface_port avalon_slave_0 iDATA writedata Input DATA_WIDTH
add_interface_port avalon_slave_0 iWR write Input 1
add_interface_port avalon_slave_0 oDATA readdata Output DATA_WIDTH
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point reset_n
# | 
add_interface reset_n reset end
set_interface_property reset_n associatedClock clk
set_interface_property reset_n synchronousEdges DEASSERT

set_interface_property reset_n ENABLED true

add_interface_port reset_n iRST_N reset_n Input 1
# | 
# +-----------------------------------