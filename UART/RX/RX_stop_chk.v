module RX_stop_chk (
    input            stp_chk_en,
    input            sampled_bit,
    input      [2:0] edge_cnt,
    output reg       stp_err
);

always @(*) begin
	if (stp_chk_en && (edge_cnt==6))
		stp_err = ~sampled_bit;
    else
    	stp_err = 1'b0;
end

endmodule 