module RX_TOP_testbench();

  // Inputs
  reg clk;
  reg ARSTn;
  reg [5:0] Prescale;
  reg PAR_EN;
  reg PAR_TYP;
  reg RX_IN;

  // Outputs
  wire [7:0] P_DATA;
  wire DATA_VLD;
  wire PAR_ERR;
  wire STP_ERR;

  // Instantiate the RX_TOP module
  RX_TOP UUT (
    .clk(clk),
    .ARSTn(ARSTn),
    .Prescale(Prescale),
    .PAR_EN(PAR_EN),
    .PAR_TYP(PAR_TYP),
    .RX_IN(RX_IN),
    .P_DATA(P_DATA),
    .DATA_VLD(DATA_VLD),
    .PAR_ERR(PAR_ERR),
    .STP_ERR(STP_ERR)
  );

  // Clock signal
  initial begin
    clk=0;
    forever #1 clk = ~clk;
  end 

  // Stimulus
  initial begin
    // Initialize inputs
    ARSTn = 1'b1; // Active low
    #50;
    ARSTn = 1'b0;
    #50;
    ARSTn = 1'b1;
    PAR_EN = 1'b0;
    PAR_TYP = 1'b0;
    Prescale='d8;
    RX_IN = 1'b0;

    // Apply stimulus here
    RX_IN=0;
    #16;
    RX_IN=1;
    #16;
    RX_IN=1;
    #16;
    RX_IN=0;
    #16;
    RX_IN=1;
    #16;
    RX_IN=1;
    #16;
    RX_IN=0;
    #16;
    RX_IN=1;
    #16;
    RX_IN=1;
    #16;

    RX_IN=1;
    #16;
    RX_IN=1;

    // Wait for a while

    #128;

    // Stop stimulus
    $stop;
  end

endmodule