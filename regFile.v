module regFile(input   wire         clk,
               input   wire         reset,
               input   wire         regWriteFlag,
               input   wire [4:0]   readAddr01,
               input   wire [4:0]   readAddr02,
               input   wire [4:0]   writeAddr01,
               input   wire [63:0]  writeResult,
               output  wire  [63:0]  readResult01,
               output  wire  [63:0]  readResult02);

// 32 registers of 64 bits width
reg [63:0] registerFile [31:0];
integer i;

// Read
assign readResult01 = registerFile[readAddr01];
assign readResult02 = registerFile[readAddr02];          

// Wirte
always @(posedge clk or posedge reset)
    begin 
    if (reset) begin
            // Reset all registers to 0      
            for (i = 0; i < 32; i = i + 1) begin
                registerFile[i] <= 64'b0;
            end
     end
     else 
     begin  
            // Write to registers of the reg file when reg write enable
            if (regWriteFlag)            
                registerFile[writeAddr01] <= writeResult;  
     end
    end          

endmodule
