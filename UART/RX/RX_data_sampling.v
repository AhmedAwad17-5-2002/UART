module RX_data_sampling (
	input        clk,    // Clock
	input        ARSTn,  // Asynchronous reset active low
	input        data_samp_en,
	input  [2:0] edge_cnt,
	input        RX_IN,
	input  [4:0] prescale,
	output reg   sampled_bit	
);
reg  [2:0] samples; 
wire [2:0] half,pre_half,post_half;

assign half=(prescale>>1)-1'b1;
assign pre_half = half-1'b1;
assign post_half = half+1'b1;


always @(posedge clk or negedge ARSTn) begin 
	if(~ARSTn) 
		samples <= 3'b0;
	
	else
	 begin
		if(data_samp_en) begin
			if(edge_cnt==pre_half)
				samples[0]<=RX_IN;
			else if(edge_cnt==half)
				samples[1]<=RX_IN;
			else if(edge_cnt==post_half)
			    samples[2]<=RX_IN;
			else
			    samples<=samples;				
		end

		else
			samples<=3'b0;
	 end
end

always @(*) begin 

	  if (edge_cnt>post_half)
	    	sampled_bit = (samples[0] & samples[1])  | (samples[0] & samples[2]) | (samples[2] & samples[1]);
      else
      	    sampled_bit=0;	
end

endmodule


/*
module TB();
reg	clk;    // Clock
reg	ARSTn;  // Asynchronous reset active low
reg	data_samp_en;
reg [2:0] edge_cnt;
reg	RX_IN;
reg [5:0] prescale;
wire   sampled_bit;

RX_data_sampling M (.*);

initial begin
	clk=0;
	forever  #1 clk = ~clk;
end

initial begin
	$display("Starting Test");
	ARSTn=0;
	data_samp_en=0;
	edge_cnt=0;
	RX_IN=1;
	prescale=8;
	#2;
	ARSTn=1;
	data_samp_en=1;
	edge_cnt=0;
	RX_IN=1;
	#2;
	edge_cnt=1;
	#2;
	edge_cnt=2;
	#2;
	edge_cnt=3;
	#2;
	RX_IN=0;
	edge_cnt=4;
	#2;
	edge_cnt=5;
	#2;
	edge_cnt=6;
	#2;
	edge_cnt=7;
	#1 $stop;
end
endmodule*/