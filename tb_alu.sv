`timescale 1ns/1ps
module tb_alu();

    //  inputs
    logic [63:0] data1_s, data2_s;
    logic [1:0] ALUOp_s;
    logic [3:0] ALUControl_s;

    // outputs
    logic [63:0] result_o;
    logic zero;

    // Instantiate the ALU module
    alu DUT (
        .data1_i(data1_s),
        .data2_i(data2_s),
        .ALUOp_i(ALUOp_s),
        .ALUControl_i(ALUControl_s),
        .result_o(result_o),
        .zero(zero)
    );

 initial begin
    // Test case 1: Load operation
    data1_s = 64'h000000000000000A; data2_s = 64'h0000000000000014; ALUOp_s = 2'b00; ALUControl_s = 4'b0010; #10;
    $display("Test case 1 - Load: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);

    // Test case 2: Store operation
    data1_s = 64'h0000000000000001; data2_s = 64'h0000000000000014; ALUOp_s = 2'b00; ALUControl_s = 4'b0010; #10; 
    $display("Test case 2 - Store: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);

    // Test case 3: Branch operation
    data1_s = 64'h000000000000000A; data2_s = 64'h000000000000000A; ALUOp_s = 2'b01; ALUControl_s = 4'b0110; #10; 
    $display("Test case 3 - Branch: data1_s = %h, data2_s = %h, result_o = %h, zero = %b", data1_s, data2_s, result_o, zero);

    // Test case 4: Addition operation
    data1_s = 64'h000000000000003C; data2_s = 64'h0000000000000014; ALUOp_s = 2'b10; ALUControl_s = 4'b0010; #10;
    $display("Test case 4 - Addition: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);

    // Test case 5: Subtraction operation
    data1_s = 64'h000000000000001E; data2_s = 64'h000000000000000F; ALUOp_s = 2'b10; ALUControl_s = 4'b0110; #10;
    $display("Test case 5 - Subtraction: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);

    // Test case 6: AND operation
    data1_s = 64'hFFFFFFFFFFFFFFFF; data2_s = 64'h000000000000FFFF; ALUOp_s = 2'b10; ALUControl_s = 4'b0000; #10;
    $display("Test case 6 - AND: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);

    // Test case 7: OR operation
    data1_s = 64'hFFFFFFFFFFFFFFFF; data2_s = 64'h000000000000FFFF; ALUOp_s = 2'b10; ALUControl_s = 4'b0001; #10;
    $display("Test case 7 - OR: data1_s = %h, data2_s = %h, result_o = %h", data1_s, data2_s, result_o);
    $finish;
end


endmodule
