module RX_FSM (
	input clk,
	input ARSTn,
	input RX_IN,
	input PAR_EN,
	input par_err,
	input strt_glitch,
	input stp_err,
	input [3:0] bit_cnt,
	input [2:0] edge_cnt,
	output reg dat_samp_en,
	output reg enable,
	output reg deser_en,
	output reg data_valid,
	output reg stp_chk_en,
	output reg strt_chk_en,
	output reg par_chk_en
	);

    parameter IDEL=3'b000,
              START=3'b001,
              DATA=3'b011,
              PARITY=3'b010,
              STOP=3'b110,
              CHK=3'b111,
			  VALID=3'b101;




    reg [2:0] cs,ns;
    reg data_v_reg;

  always @(posedge clk or negedge ARSTn) begin
       if(~ARSTn) begin
         data_v_reg <= 0;
       end 
       else if(cs==STOP && edge_cnt==7) begin
          data_v_reg <= data_valid ;
       end
  end


    always@(posedge clk , negedge ARSTn) begin
    	if(~ARSTn)
    		cs<=IDEL;
    	else
    		cs<=ns;
    end





    always @(*) begin 
    	case (cs)
    		IDEL : begin 
    			    if(~RX_IN)
    				   ns<=START;
    			    else
    				   ns<=IDEL;
    		       end

    		START : begin
                     if(edge_cnt==3'b111 && bit_cnt==4'b0000) begin
    			       if(strt_glitch)
    			       	    ns<=IDEL;

    			       else 
                         ns<=DATA;
    			     end

    			     else 
    			     	ns<=START;   			       			     
    		        end


    		DATA : begin
    			    if(edge_cnt==3'b111 && bit_cnt==4'b1000) begin
    			    	if(PAR_EN)
    			    		ns<=PARITY;
    			    	else
    			    		ns<=STOP;
    			    end

    			    else
    			    	ns<=DATA;
    			   end


    	    PARITY : begin
    	               if(edge_cnt==3'b111 && bit_cnt==4'b1001) 
    	             	 ns<=STOP;
    	               else
    	             	ns<=PARITY;   	               	    	      
    	             end

    	    STOP : begin
    	               if(edge_cnt==3'b111 && (bit_cnt==4'b1010 || bit_cnt==4'b1001)) 
    	             	 ns<=IDEL;
    	               else
    	             	ns<=STOP;   	               	    	      
    	           end


    	   /* CHK : ns<=VALID;

			VALID : ns<=IDEL;*/

    		default : ns<=IDEL;
    	endcase
    end




    always @(*) begin
    	case (cs)
    		    IDEL : begin 
              data_valid=data_v_reg;
    			    if(~RX_IN) begin
    			            dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=1;
                      par_chk_en=0;
                    end
                    else begin
                      dat_samp_en=0;
                      enable=0;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=0;
                    end
    		       end

    		    START : begin
                      data_valid=data_v_reg;
    			            dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=1;
                      par_chk_en=0;
    		        end

            DATA : begin
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=1;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=0;                                          
                      data_valid=0;
                   end

            PARITY : begin
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=0;
                      strt_chk_en=0;
                      par_chk_en=1;
                      data_valid=0;
                     end

            STOP : begin
            	        dat_samp_en=1;
                      enable=1;
                      deser_en=0;
                      stp_chk_en=1;
                      strt_chk_en=0;
                      par_chk_en=0;
                      if(~(par_err | stp_err | strt_glitch) && (edge_cnt>5))
                        data_valid=1;
                      else
                        data_valid=0;
                   end

    		default : begin
    			              dat_samp_en=0;
                        enable=0;
                        deser_en=0;
                        data_valid=0;
                        stp_chk_en=0;
                        strt_chk_en=0;
                        par_chk_en=0;
                      end
    	endcase
    end
endmodule