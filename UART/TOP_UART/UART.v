module UART (
	input clk,    // Clock
	input ARSTn,  // Asynchronous reset active low
//TX_PORTS
	input        TX_PAR_EN,
	input        TX_PAR_TYP,
	input  [7:0] TX_P_DATA,
	input        TXDATA_VALID,
	output       TX_S_DATA,
	output       TX_BUSY,
//RX_PORTS
  input   [4:0] RX_Prescale,
	input         RX_PAR_EN,
	input         RX_PAR_TYP,
	input         RX_RX_IN,
	output  [7:0] RX_P_DATA,
	output        RX_DATA_VLD,
	output        RX_PAR_ERR,
	output        RX_STP_ERR
);


TX_TOP TX (
  clk,    // Clock
  ARSTn,  // Asynchronous reset active low
//TX_PORTS
  TX_PAR_EN,
  TX_PAR_TYP,
  TX_P_DATA,
  TXDATA_VALID,
  TX_S_DATA,
  TX_BUSY
);


RX_TOP RX (
 clk,    // Clock
 ARSTn,  // Asynchronous reset active low
//RX_PORTS
	RX_Prescale,
  RX_PAR_EN,
  RX_PAR_TYP,
  RX_RX_IN,
  RX_P_DATA,
  RX_DATA_VLD,
  RX_PAR_ERR,
  RX_STP_ERR
);
endmodule : UART