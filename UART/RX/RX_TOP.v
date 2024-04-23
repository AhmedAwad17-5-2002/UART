module RX_TOP (
	input         clk,    // Clock
	input         ARSTn,  // Asynchronous reset active low
	input   [4:0] Prescale,
	input         PAR_EN,
	input         PAR_TYP,
	input         RX_IN,
	output  [7:0] P_DATA,
	output        DATA_VLD,
	output        PAR_ERR,
	output        STP_ERR
);
wire data_samp_en,sampled_bit,deser_en,enable,strt_glitch,dat_samp_en, stp_chk_en,strt_chk_en,par_chk_en,stop_error,parity_error,valid;
wire [2:0] edge_cnt;
wire [3:0] bit_cnt;


RX_data_sampling M0 (
 clk,    
 ARSTn,  
 dat_samp_en,
 edge_cnt,
 RX_IN,
 Prescale,
 sampled_bit	
);


RX_deserializer M1 (
 clk,    
 ARSTn,  
 deser_en,
 sampled_bit,
 edge_cnt,
 P_DATA
);


RX_edge_counter M2 (
 clk,    // Clock
 ARSTn,  // Asynchronous reset active low
 enable,
 PAR_EN,
 edge_cnt,	
 bit_cnt
);


RX_FSM M3 (
 clk,
 ARSTn,
 RX_IN,
 PAR_EN,
 PAR_ERR,
 strt_glitch,
 STP_ERR,
 bit_cnt,
 edge_cnt,
 dat_samp_en,
// valid,
 enable,
 deser_en,
 DATA_VLD,
 stp_chk_en,
 strt_chk_en,
 par_chk_en
);


RX_parity_check M4 (
 par_chk_en,
 sampled_bit,
 PAR_TYP,
 P_DATA,
 PAR_ERR
);


RX_stop_chk M5 (
 stp_chk_en,
 sampled_bit,
 edge_cnt,
 STP_ERR
);


RX_start_chk M6 (
 sampled_bit,
 strt_chk_en,
 edge_cnt,
 strt_glitch
);

// RX_Verifier M7 (
//  strt_glitch,
//  parity_error,
//  stop_error,
//  edge_cnt,
//  valid,
//  PAR_ERR,
//  STP_ERR
// );

endmodule