module TX_TOP #(parameter DATA_WIDTH=8) (
	input CLK,    // Clock
	input RST,  // Asynchronous reset active low
	input PAR_EN,
	input PAR_TYP,
	input [DATA_WIDTH-1:0] P_DATA,
	input DATA_VALID,
	output  S_DATA,
	output  BUSY
);

wire [1:0] mux_sel; 
wire serial_done,serial_en,parity,data_s;

reg [DATA_WIDTH-1:0] TEMPO;

always@(posedge CLK, negedge RST) begin
    if(~RST)
      TEMPO<=0;
    else begin
        if(DATA_VALID)
          TEMPO<=P_DATA;
        else
          TEMPO<=TEMPO;
    end
      
end

TX_FSM M1 (CLK,RST,DATA_VALID,PAR_EN,serial_done,mux_sel,BUSY,serial_en);
TX_mux M2 (1'b1,1'b0,parity,data_s,mux_sel,S_DATA);
TX_PARITY M3(TEMPO,PAR_TYP,DATA_VALID,PAR_EN,parity);
TX_Serializer M4(CLK,RST,TEMPO,serial_en,serial_done,data_s);

endmodule 