`timescale 1us/1ns
module TX_TOP_TB #(parameter  DATA_WIDTH=8)();
  parameter Clock_PERIOD = 8.68055556 ;

    // Input signals
    reg CLK=0;
    reg RST;
    reg PAR_EN;
    reg PAR_TYP;
    reg [7:0] P_DATA;
    reg DATA_VALID;
  
    // Output signals
    wire S_DATA;
    wire BUSY;
  
    // Instantiate the device under test (DUT)
    TX_TOP #(.DATA_WIDTH(8)) DUT (
      .CLK(CLK),
      .RST(RST),
      .PAR_EN(PAR_EN),
      .PAR_TYP(PAR_TYP),
      .P_DATA(P_DATA),
      .DATA_VALID(DATA_VALID),
      .S_DATA(S_DATA),
      .BUSY(BUSY)
    );
  
    // Clock generator
    always #(Clock_PERIOD/2) CLK = ~CLK;
  
    // Initial values
    initial begin
      CLK = 0;
      RST = 1; // Active low
      PAR_EN = 0;
      PAR_TYP = 0;
      DATA_VALID = 0;   
      // Test vector 1
      RST = 0; // Assert reset
      #((Clock_PERIOD/2)*4)
      RST = 1; // Deassert reset
      PAR_EN = 1;
      PAR_TYP = 2'b00; // Even parity
      P_DATA = 8'hFE;
      DATA_VALID = 1;
      #((Clock_PERIOD/2)*2);
      DATA_VALID = 0;
      #((Clock_PERIOD/2)*30);
      // Test vector 2
      PAR_TYP = 2'b01; // Odd parity
      P_DATA = 8'hAA;
      DATA_VALID = 1;
      #((Clock_PERIOD/2)*2)
      DATA_VALID = 0;
      #((Clock_PERIOD/2)*30);
      
      // Test vector 3
      PAR_EN = 0;
      P_DATA = 8'hAA;
      DATA_VALID = 1;
      #((Clock_PERIOD/2)*2);
      DATA_VALID = 0;
      #((Clock_PERIOD/2)*30);
      #((Clock_PERIOD/2)*100);
       $stop;
    end
  
  endmodule