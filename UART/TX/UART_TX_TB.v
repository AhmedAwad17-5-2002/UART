
`timescale 1ns/1ps


module UART_TX_TB ();

/////////////////////////////////////////////////////////
///////////////////// Parameters ////////////////////////
/////////////////////////////////////////////////////////

parameter DATA_WD_TB = 8 ;      
parameter CLK_PERIOD = 10 ; 


/////////////////////////////////////////////////////////
//////////////////// DUT Signals ////////////////////////
/////////////////////////////////////////////////////////

reg    [10:0]  gener_out ;
// reg                  		CLK;
// reg                  		RST;
// reg     [DATA_WD_TB-1:0]    P_DATA;
// reg                  		DATA_VALID;
// reg                 		PAR_EN;
// reg                 		PAR_TYP; 
// wire                		S_DATA;
// wire                		BUSY;
	reg CLK;    // Clock
	reg RST;  // Asynchronous reset active low
	reg PAR_EN;
	reg PAR_TYP;
	reg [DATA_WD_TB-1:0] P_DATA;
	reg DATA_VALID;
	wire  S_DATA;
	wire  BUSY;



////////////////////////////////////////////////////////
////////////////// initial block /////////////////////// 
////////////////////////////////////////////////////////

initial
 begin

 // Initialization
 initialize() ;

 // Reset
 reset() ; 


 ////////////// Test Case 1 (No Parity) //////////////////

 // UART Configuration (Parity Enable = 0)
 PAR_EN=0;
 UART_CONFG (1'b0,1'b0);

 // Load Data 
 DATA_IN(8'hA3);  

 // Check Output
 chk_tx_out(8'hA3,0,0,1) ;

 #2000
 
 ////////////// Test Case 2 (Even Parity) ////////////////

 // UART Configuration (Parity Enable = 1 && Parity Type = 0)
 PAR_EN=1;
 PAR_TYP=0;
 UART_CONFG (1'b1,1'b0);

 // Load Data 
 DATA_IN(8'hB4);  

 // Check Output
 chk_tx_out(8'hB4,1,0,2) ;
 
 #2000
 
 ////////////// Test Case 3 (Odd Parity) ////////////////

 // UART Configuration (Parity Enable = 1 && Parity Type = 1)
 PAR_TYP=1;
 UART_CONFG (1'b1,1'b1);

 // Load Data 
 DATA_IN(8'hD2);  

 // Check Output
 chk_tx_out(8'hD2,1,1,3) ; 

  #2000

$stop ;

end
 
 

///////////////////// Clock Generator //////////////////

always #(CLK_PERIOD/2) CLK = ~CLK ;

////////////////////////////////////////////////////////
/////////////////////// TASKS //////////////////////////
////////////////////////////////////////////////////////

/////////////// Signals Initialization //////////////////

task initialize ;
  begin
	CLK            = 1'b0   ;
	RST            = 1'b1   ;    // rst is deactivated
	P_DATA         = 8'h00  ;
	PAR_EN  = 1'b0   ;
	PAR_TYP    = 1'b0   ;
	DATA_VALID     = 1'b0   ;
  end
endtask

///////////////////////// RESET /////////////////////////
task reset ;
  begin
	#(CLK_PERIOD)
	RST  = 'b0;           // rst is activated
	#(CLK_PERIOD)
	RST  = 'b1;
	#(CLK_PERIOD) ;
  end
endtask

///////////////////// Configuration ////////////////////
task UART_CONFG ;
  input                   PAR_EN ;
  input                   PAR_TYP ;

  begin
	PAR_EN  = PAR_EN   ;
	PAR_TYP    = PAR_TYP   ;
  end
endtask

/////////////////////// Data IN /////////////////////////
task DATA_IN ;
 input  [DATA_WD_TB-1:0]  DATA ;

 begin
	P_DATA         = DATA  ;
	DATA_VALID     = 1'b1   ;
	#CLK_PERIOD
	DATA_VALID     = 1'b0   ;
 end
endtask

//////////////////  Check Output  ////////////////////
task chk_tx_out ;
 input  [DATA_WD_TB-1:0]  		DATA    ;
 input                          PAR_EN  ; 
 input                          PAR_TYP ; 
 input  [2:0]                   Test_NUM;
 
 reg    [10:0]  expec_out;     //longest frame = 11 bits (1-start,1-stop,8-data,1-parity)
 reg            parity_bit;
 
 integer   i ;

 begin
 
	if (BUSY == 'b1)
	begin
		for(i=0; i<11; i=i+1)
		begin
		@(negedge CLK) gener_out[i] = S_DATA ;
		end
    if(PAR_EN)
		if(PAR_TYP)
			parity_bit = ~^DATA ;
		else
			parity_bit = ^DATA ;
	else
			parity_bit = 1'b1 ;	
	
    if(PAR_EN)
		expec_out = {1'b1,parity_bit,DATA,1'b0} ;
	else
		expec_out = {1'b1,1'b1,DATA,1'b0} ;
			
	if(gener_out == expec_out) 
		begin
			$display("Test Case %d is succeeded",Test_NUM);
		end
	else
		begin
			$display("Test Case %d is failed", Test_NUM);
		end
 end
 end
endtask
///////////////// Design Instaniation //////////////////
TX_TOP DUT (.*);

endmodule