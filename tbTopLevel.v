`timescale 1ns / 1ps

module tbTopLevel;

  // Parameters
  parameter CLK_PERIOD = 10; // Clock period in ns

  // Signals
  reg clk =0;
  reg reset;
  reg flashEn;
  reg [7:0] flashInstruction;
  integer file, r;
  reg [7:0] instruction_data;

  
  // Instantiate the module under test
  topLevel dut (
    .clk(clk),
    .reset(reset),
    .flashEn(flashEn),
    .flashInstruction(flashInstruction)
  );
  
  // Clock generation
  always #((CLK_PERIOD / 2)) clk = ~clk;
  
  // Example: Test case for observing PC increment after reset
  initial begin
   
   // Pull up reset and flash enable
   reset = 1;
   flashEn = 1;
   #10;
   
   // Pull down reset and flash enable 
   flashEn = 0;
   reset = 0;
   
   // Open file cotaining instructions in HEX format
   file = $fopen("D:\\Desktop_Clone\\Vivado_Projects\\instructions.txt", "r");

    if (file == 0) begin
        $display("Failed to open file.");
        $finish;
    end

    // Flash data from file to instruction memory
    while (!$feof(file)) begin
        r = $fscanf(file, "%2h\n", instruction_data);
        flashInstruction[7:0] = instruction_data[7:0];
        flashEn = 1;
        #10;
        flashEn = 0;
    end
    
    // Close the file
    $fclose(file);
    
    // Reset the processor 
    reset = 1;
    #10; // Wait for a while
    reset = 0;
    
    // Processor starts the operation
    #80; // Wait for a while
    $finish; // End simulation
  end

endmodule
