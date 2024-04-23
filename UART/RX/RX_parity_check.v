module RX_parity_check (
	input      par_chk_en,
	input      sampled_bit,
	input      PAR_TYP,
	input      [7:0] P_DATA,
	output reg par_err
);

always @(*) begin 
	if(par_chk_en) begin
	   if(PAR_TYP==0) begin
		   if((^P_DATA)==sampled_bit)
			    par_err=0;
			else
				par_err=1;
		end

		else begin
		    if((~^P_DATA)==sampled_bit)
			    par_err=0;
			else
				par_err=1;
		end
   end

   else
   	par_err=0;
	
end

endmodule 