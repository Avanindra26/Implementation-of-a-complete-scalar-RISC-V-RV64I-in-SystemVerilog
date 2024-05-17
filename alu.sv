module alu(
    // input ports for data coming from register
    input logic [63:0] data1_i,
    input logic [63:0] data2_i,
    // 2-bits ALUOp to decide wether it is load, Store, branch or Arithmatic operation
    input logic [1:0] ALUOp_i, 
    //  4-Bits
    input logic [3:0] ALUControl_i,
    
    // output ports
    output logic [63:0] result_o,
    //Zero to check whether we have to take branch or not
    output logic zero // Output indicating if result is zero
);

     // Declare two wires to store tempo result and zero flag
     // wire [63:0] result_o;
      // wire zero;

always_comb begin

    case({ALUOp_i, ALUControl_i})
           6'b000010: begin
           // add and load doubleword
           result_o = data1_i + data2_i;
           zero = 1'b0; 
            end
            
            // add and store doubleword
            
            
            // subtract and take brach if equal
            6'b010110: begin
            result_o = data2_i - data1_i;
            zero = (result_o == 64'h0);
            end          
            
            6'b100010: begin
            // add
            result_o = data1_i + data2_i;
            zero = 1'b0; 
            end
            
            6'b100110: begin
            // subtract
            result_o = data1_i - data2_i;
            zero = 1'b0; 
            end
            
            6'b100000: begin
            // AND
            result_o = data1_i && data2_i;
            zero = 1'b0; 
            end
            
            6'b100001: begin
            // OR
            result_o = data1_i || data2_i;
            zero = 1'b0;         
            end
     
            default: begin
                // Unknown operation   
            result_o = 64'h0; // Default output value
            zero = 1'b0; 
            $display("Unknown operation code");
            end
    endcase
end

endmodule :alu