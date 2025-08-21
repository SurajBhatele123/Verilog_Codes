## Configuration options, can be used for all designs
#set_property CONFIG_VOLTAGE 3.3 [current_design]
#set_property CFGBVS VCCO [current_design]

## SPI configuration mode options for QSPI boot, can be used for all designs
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
#set_property CONFIG_MODE SPIx4 [current_design]

## Clock signal
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]
## reset
set_property -dict { PACKAGE_PIN R2 IOSTANDARD LVCMOS33 }  [get_ports rst]

##Pmod Header JB
set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {lcd_data[0]}]
set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {lcd_data[1]}]
set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {lcd_data[2]}]
set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {lcd_data[3]}]
set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {lcd_data[4]}]
set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports {lcd_data[5]}]
set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {lcd_data[6]}]
set_property -dict {PACKAGE_PIN C16 IOSTANDARD LVCMOS33} [get_ports {lcd_data[7]}]

##Pmod Header JC
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports lcd_rs]
#set_property -dict {PACKAGE_PIN A17 IOSTANDARD LVCMOS33} [get_ports lcd_rs]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports lcd_rw]
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS33} [get_ports lcd_e]

set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN V17 [get_ports rst]

