module instructionMemory(input   wire [63:0]  pc,
                         input   wire flashEn,
                         input   wire [7:0]  flashInstruction,                             
                         output  wire [63:0]  pcBypass,
                         output  reg  [31:0]  instruction);

// Signal declaration
reg [7:0] instructionMem [127:0];
reg [31:0] nextInstruction;

// Pass the PC to further blocks
assign pcBypass = flashEn ? 64'dX : pc;

// Instruction memory flash and read
 always @(*)
 begin
    if (flashEn) 
    begin
        // Write flash instruction to instruction memory at pc
        instructionMem[pc] = flashInstruction[7:0];
        
        // Stop outputing current instruction
        instruction[31:0] = 32'dX;
    end 
    else 
    begin
        // Output current instruction
        instruction[31:0] = { instructionMem[pc+3], instructionMem[pc+2], instructionMem[pc+1], instructionMem[pc]}; 
    end
 end

// Instruction 1 00003083
// ld r1 0(r0) where r0=0

// Instruction 2 00803103
// ld r1 8(r0) where r0=0

// Branch Condition
// Instruction 3 002001b3
// add r3 r2 r0

// No Branch Condition
// Instruction 3 002081b3
// add r3 r2 r1

// Instruction 4 00310463
// beq r3 r2 4(offset)

// Instruction 5 00310233
// add r4 r3 r2

// Instruction 6 02302023
// sd r3 32(r0)

// Instruction 7 40208133
// sub r2 r2 r1

endmodule
