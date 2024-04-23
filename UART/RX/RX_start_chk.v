module RX_start_chk (
input            sampled_bit,
input            strt_chk_en,
input      [2:0] edge_cnt,
output reg       strt_glitch
);

always @(*) begin 
	if(strt_chk_en && (edge_cnt==6))
	    strt_glitch = sampled_bit;
	else
	    strt_glitch = 1'b0; 
end

endmodule