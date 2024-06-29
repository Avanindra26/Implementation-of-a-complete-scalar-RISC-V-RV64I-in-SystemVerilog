module ALU_Bhv(
    input    wire [63:0]    data01,
    input    wire [63:0]    data02,
    input    wire [3:0]     aluCtl,
    input    wire [1:0]     aluOp,
    output   wire           zeroFlag,
    output   reg  [63:0]    result
     );

parameter loadOrStoreOp = 2'b00,
          branchOp      = 2'bx1,
          rTypeOp       = 2'b1x,
          store         = 4'b0010,
          load          = 4'b0010,
          branchIfEqual = 4'b0110,
          ariAdd        = 4'b0010,
          ariSub        = 4'b0110,
          bitAnd        = 4'b0000,
          bitOr         = 4'b0001;

// Zero flag generator
assign zeroFlag = ~|result;

// ALU instruction class decoding
always @(*)
    casex (aluOp)
        // load and store instruction ALU operation
        loadOrStoreOp : 
                        case (aluCtl)
                            load          : begin
                                            result = data01 + data02;                                      
                                            end
                        endcase
        
        // Branch instruction ALU operation               
        branchOp      : case (aluCtl)
                            branchIfEqual : begin
                                            result = data01 - data02;                                          
                                            end
                        endcase
       
        // Rtype instruction ALU operation
        rTypeOp       : case (aluCtl)
                            ariAdd        : begin
                                            result = data01 + data02;                                           
                                            end
                            ariSub        : begin
                                            result = data01 - data02;
                                            end
                            bitAnd        : begin
                                            result = data01 & data02;
                                            end
                            bitOr         : begin
                                            result = data01 | data02;
                                            end
                        endcase 
        
        // Default case
        default       :    result = 64'dx;
                       
    endcase 
endmodule
