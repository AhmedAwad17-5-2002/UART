module RX_Verifier (
  input      strt_glitch,
  input      parity_error,
  input      stop_error,
  input      bit_cnt,
  input      edge_cnt,
  output reg valid,
  output reg PAR_ERR,
  output reg STP_ERR
);

  always @(*) begin
  	if(strt_glitch|parity_error|stop_error)
  		valid <= 0;
  	else 
  		valid <= 1;

  	STP_ERR<=stop_error;
  	PAR_ERR<=parity_error;
  	
  end

endmodule : RX_Verifier