module RX_deserializer (
	input      clk,    // Clock
	input      ARSTn,  // Asynchronous reset active low
	input      deser_en,
	input      sampled_bit,
	input      [2:0] edge_cnt,
	output reg [7:0] P_DATA
);

//reg [2:0] counter=0;

always @(posedge clk or negedge ARSTn) begin
	if(~ARSTn) begin
		P_DATA <= 0;
//		counter <= 0;
	end 
	else begin
		if((deser_en==1) && (edge_cnt==6)) begin
           P_DATA <= {sampled_bit,P_DATA[7:1]}	;
		end
		else begin
			P_DATA <= P_DATA;
		end 

	end
end

endmodule 