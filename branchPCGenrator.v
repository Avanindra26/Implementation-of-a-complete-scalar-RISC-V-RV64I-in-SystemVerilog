module branchPCGenrator(input  wire          branchControl,
                        input  wire          zeroFlag,
                        input  wire  [63:0]  newPC,
                        input  wire  [63:0]  curretPC,
                        input  wire  [63:0]  immidiateValue,
                        output wire   [63:0]  nextPC );

// Signal declarations
wire branchDecision;

// Branch Decision 
assign branchDecision = branchControl & zeroFlag;
 
// next PC Mux    
assign nextPC = branchDecision ? curretPC + (immidiateValue << 1) : newPC;              

endmodule
