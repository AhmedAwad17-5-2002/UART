module RX_edge_counter (
	input      clk,    // Clock
	input      ARSTn,  // Asynchronous reset active low
	input      enable,
	input      PAR_EN,
	output reg [2:0] edge_cnt,	
	output reg [3:0] bit_cnt
);

always @(posedge clk or negedge ARSTn) begin
	if(~ARSTn) begin
		edge_cnt <= 0;
		bit_cnt <= 0;
	end

	else begin
		if(enable)  begin
			if(edge_cnt==3'd7) begin
				if((bit_cnt=='d10 && PAR_EN==1) || (bit_cnt=='d9 && PAR_EN==0))
					bit_cnt<=0;
			else 
				 bit_cnt<=bit_cnt+1'b1;

			 edge_cnt<=edge_cnt+1'b1;
			end
         
			else 
				edge_cnt<=edge_cnt+1'b1;
		end

		else begin
		   edge_cnt <= 0;
		   bit_cnt <= 0;			
		end
	end
end

endmodule 